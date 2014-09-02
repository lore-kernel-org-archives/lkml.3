Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaIBQ7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:59:03 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11372 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbaIBQ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:59:01 -0400
Date: Tue, 2 Sep 2014 09:58:59 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "agross@codeaurora.org" <agross@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Make the target processor value
 configurable
Message-ID: <20140902165858.GN12494@sonymobile.com>
References: <1409663625-3185-1-git-send-email-gdjakov@mm-sol.com>
 <1409663625-3185-5-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409663625-3185-5-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02 Sep 06:13 PDT 2014, Georgi Djakov wrote:

> Currently the value used for specify that interrupts from the gpio should
> be routed to the application processor is hardcoded for all Qualcomm SoCs.
> But the new APQ8084 SoC uses a different value. To resolve this, we make
> this value configurable for each SoC. For all existing SoCs we continue
> to use the current value, and only for APQ8084 we use the new value.
> 
> Suggested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Looks good.

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

> ---
>  drivers/pinctrl/qcom/pinctrl-apq8064.c |    2 ++
>  drivers/pinctrl/qcom/pinctrl-apq8084.c |    2 ++
>  drivers/pinctrl/qcom/pinctrl-ipq8064.c |    2 ++
>  drivers/pinctrl/qcom/pinctrl-msm.c     |    4 +---
>  drivers/pinctrl/qcom/pinctrl-msm.h     |    3 +++
>  drivers/pinctrl/qcom/pinctrl-msm8960.c |    2 ++
>  drivers/pinctrl/qcom/pinctrl-msm8x74.c |    2 ++
>  7 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
> index feb6f15..f877aed 100644
> --- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
> +++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
> @@ -258,6 +258,7 @@ static const unsigned int sdc3_data_pins[] = { 95 };
>  		.intr_status_bit = 0,			\
>  		.intr_ack_high = 1,			\
>  		.intr_target_bit = 0,			\
> +		.intr_target_kpss_val = 4,		\
>  		.intr_raw_status_bit = 3,		\
>  		.intr_polarity_bit = 1,			\
>  		.intr_detection_bit = 2,		\
> @@ -283,6 +284,7 @@ static const unsigned int sdc3_data_pins[] = { 95 };
>  		.intr_enable_bit = -1,			\
>  		.intr_status_bit = -1,			\
>  		.intr_target_bit = -1,			\
> +		.intr_target_kpss_val = -1,		\
>  		.intr_raw_status_bit = -1,		\
>  		.intr_polarity_bit = -1,		\
>  		.intr_detection_bit = -1,		\
> diff --git a/drivers/pinctrl/qcom/pinctrl-apq8084.c b/drivers/pinctrl/qcom/pinctrl-apq8084.c
> index 5362959..138cbf6 100644
> --- a/drivers/pinctrl/qcom/pinctrl-apq8084.c
> +++ b/drivers/pinctrl/qcom/pinctrl-apq8084.c
> @@ -371,6 +371,7 @@ static const unsigned int sdc2_data_pins[] = { 152 };
>  		.intr_status_bit = 0,			\
>  		.intr_ack_high = 0,			\
>  		.intr_target_bit = 5,			\
> +		.intr_target_kpss_val = 3,		\
>  		.intr_raw_status_bit = 4,		\
>  		.intr_polarity_bit = 1,			\
>  		.intr_detection_bit = 2,		\
> @@ -396,6 +397,7 @@ static const unsigned int sdc2_data_pins[] = { 152 };
>  		.intr_enable_bit = -1,                  \
>  		.intr_status_bit = -1,                  \
>  		.intr_target_bit = -1,                  \
> +		.intr_target_kpss_val = -1,		\
>  		.intr_raw_status_bit = -1,              \
>  		.intr_polarity_bit = -1,                \
>  		.intr_detection_bit = -1,               \
> diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
> index 767cf11..81f49a9 100644
> --- a/drivers/pinctrl/qcom/pinctrl-ipq8064.c
> +++ b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
> @@ -211,6 +211,7 @@ static const unsigned int sdc3_data_pins[] = { 71 };
>  		.intr_status_bit = 0,			\
>  		.intr_ack_high = 1,			\
>  		.intr_target_bit = 0,			\
> +		.intr_target_kpss_val = 4,		\
>  		.intr_raw_status_bit = 3,		\
>  		.intr_polarity_bit = 1,			\
>  		.intr_detection_bit = 2,		\
> @@ -236,6 +237,7 @@ static const unsigned int sdc3_data_pins[] = { 71 };
>  		.intr_enable_bit = -1,                  \
>  		.intr_status_bit = -1,                  \
>  		.intr_target_bit = -1,                  \
> +		.intr_target_kpss_val = -1,		\
>  		.intr_raw_status_bit = -1,              \
>  		.intr_polarity_bit = -1,                \
>  		.intr_detection_bit = -1,               \
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 2738108..592c6fc 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -649,8 +649,6 @@ static void msm_gpio_irq_ack(struct irq_data *d)
>  	spin_unlock_irqrestore(&pctrl->lock, flags);
>  }
>  
> -#define INTR_TARGET_PROC_APPS    4
> -
>  static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  {
>  	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> @@ -674,7 +672,7 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  	/* Route interrupts to application cpu */
>  	val = readl(pctrl->regs + g->intr_target_reg);
>  	val &= ~(7 << g->intr_target_bit);
> -	val |= INTR_TARGET_PROC_APPS << g->intr_target_bit;
> +	val |= g->intr_target_kpss_val << g->intr_target_bit;
>  	writel(val, pctrl->regs + g->intr_target_reg);
>  
>  	/* Update configuration for gpio.
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
> index 7b2a227..b952c4b 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.h
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.h
> @@ -53,6 +53,8 @@ struct msm_function {
>   * @intr_status_bit:      Offset in @intr_status_reg for reading and acking the interrupt
>   *                        status.
>   * @intr_target_bit:      Offset in @intr_target_reg for configuring the interrupt routing.
> + * @intr_target_kpss_val: Value in @intr_target_bit for specifying that the interrupt from
> + *                        this gpio should get routed to the KPSS processor.
>   * @intr_raw_status_bit:  Offset in @intr_cfg_reg for the raw status bit.
>   * @intr_polarity_bit:    Offset in @intr_cfg_reg for specifying polarity of the interrupt.
>   * @intr_detection_bit:   Offset in @intr_cfg_reg for specifying interrupt type.
> @@ -88,6 +90,7 @@ struct msm_pingroup {
>  	unsigned intr_ack_high:1;
>  
>  	unsigned intr_target_bit:5;
> +	unsigned intr_target_kpss_val:5;
>  	unsigned intr_raw_status_bit:5;
>  	unsigned intr_polarity_bit:5;
>  	unsigned intr_detection_bit:5;
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm8960.c b/drivers/pinctrl/qcom/pinctrl-msm8960.c
> index 3504703..2ab21ce 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm8960.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm8960.c
> @@ -384,6 +384,7 @@ static const unsigned int sdc3_data_pins[] = { 157 };
>  		.intr_status_bit = 0,			\
>  		.intr_ack_high = 1,			\
>  		.intr_target_bit = 0,			\
> +		.intr_target_kpss_val = 4,		\
>  		.intr_raw_status_bit = 3,		\
>  		.intr_polarity_bit = 1,			\
>  		.intr_detection_bit = 2,		\
> @@ -409,6 +410,7 @@ static const unsigned int sdc3_data_pins[] = { 157 };
>  		.intr_enable_bit = -1,			\
>  		.intr_status_bit = -1,			\
>  		.intr_target_bit = -1,			\
> +		.intr_target_kpss_val = -1,		\
>  		.intr_raw_status_bit = -1,		\
>  		.intr_polarity_bit = -1,		\
>  		.intr_detection_bit = -1,		\
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm8x74.c b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
> index 8c97201..3c85838 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm8x74.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
> @@ -366,6 +366,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
>  		.intr_enable_bit = 0,			\
>  		.intr_status_bit = 0,			\
>  		.intr_target_bit = 5,			\
> +		.intr_target_kpss_val = 4,		\
>  		.intr_raw_status_bit = 4,		\
>  		.intr_polarity_bit = 1,			\
>  		.intr_detection_bit = 2,		\
> @@ -391,6 +392,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
>  		.intr_enable_bit = -1,			\
>  		.intr_status_bit = -1,			\
>  		.intr_target_bit = -1,			\
> +		.intr_target_kpss_val = -1,		\
>  		.intr_raw_status_bit = -1,		\
>  		.intr_polarity_bit = -1,		\
>  		.intr_detection_bit = -1,		\
> -- 
> 1.7.9.5
> 
