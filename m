Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaH2S5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:57:48 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3401 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbaH2S5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:57:46 -0400
Date: Fri, 29 Aug 2014 11:57:46 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v2] pinctrl: qcom: remove gpiochip in failure cases
Message-ID: <20140829185744.GK12494@sonymobile.com>
References: <1409299909-5128-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409299909-5128-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29 Aug 01:11 PDT 2014, Pramod Gurav wrote:

> This patch releases gpiochip related resources by calling
> gpiochip_remove when either of gpiochip_add_pin_range and
> gpiochip_irqchip_add fails.
> 
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

> ---
> 
> Changes since v1:
> - In v1 of this patch gpiochip_remove was called only in failure case of
>   gpiochip_irqchip_add. This patchs adds a call to gpiochip_remove in failure
>   case of gpiochip_add_pin_range as well.
> 
>  drivers/pinctrl/qcom/pinctrl-msm.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 2738108..9175bbc 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -829,6 +829,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>  	ret = gpiochip_add_pin_range(&pctrl->chip, dev_name(pctrl->dev), 0, 0, chip->ngpio);
>  	if (ret) {
>  		dev_err(pctrl->dev, "Failed to add pin range\n");
> +		gpiochip_remove(&pctrl->chip);
>  		return ret;
>  	}
>  
> @@ -839,6 +840,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>  				   IRQ_TYPE_NONE);
>  	if (ret) {
>  		dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
> +		gpiochip_remove(&pctrl->chip);
>  		return -ENOSYS;
>  	}
>  

It seems like pinctrl-st.c and pinctrl-sirf.c is suffering the same problem,
would you mind spinning patches for those too?

Regards,
Bjorn
