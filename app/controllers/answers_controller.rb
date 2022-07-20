class AnswersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_question!
  before_action :set_answer!, except: :create

  def create
    @answer = @question.answers.build answer_params

    if @answer.save
      flash[:success] = 'Answer created'
      redirect_to question_path(@question)
    else
      @question = @question.decorate
      @pagy, @answers = pagy @question.answers.order created_at: :desc
      @answer = @answer.decorate
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = 'Answer deleted'
    redirect_to question_path(@question)
  end

  def edit; end

  def update
    if @answer.update answer_params
      flash[:success] = 'Answer updated'
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      render :edit
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question!
    @question = Question.find params[:question_id]
  end

  def set_answer!
    @answer = @question.answers.find params[:id]
  end
end
