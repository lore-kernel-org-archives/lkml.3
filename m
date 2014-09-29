Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaI2Nr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:47:29 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47304 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbaI2Nr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:47:28 -0400
Message-ID: <542962E6.1000005@st.com>
Date: Mon, 29 Sep 2014 15:47:18 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>,
        <linux-kernel@vger.kernel.org>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] pinctrl: st: Fix Sparse error
References: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-29_03:2014-09-29,2014-09-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pramod

On 09/29/2014 03:48 PM, Pramod Gurav wrote:
> This change fixes below sparse error,
> drivers/pinctrl/pinctrl-st.c:1515:31: error: incompatible types for operation (>)
> drivers/pinctrl/pinctrl-st.c:1515:31:    left side has type void [noderef] <asn:2>*irqmux_base
> drivers/pinctrl/pinctrl-st.c:1515:31:    right side has type int
>
> The fix is done by removing a check on info->irqmux_base as
> info->irqmux_base has already been checked  for error when allocating it.
> Hence there is no need to redo the check.
>
> Cc: Maxime Coquelin <maxime.coquelin@st.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>   drivers/pinctrl/pinctrl-st.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 5475374..ddeaeda 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1512,7 +1512,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
>   					     gpio_irq, st_gpio_irq_handler);
>   	}
>   
> -	if (info->irqmux_base > 0 || gpio_irq > 0) {
> +	if (gpio_irq > 0) {
>   		err = gpiochip_irqchip_add(&bank->gpio_chip, &st_gpio_irqchip,
>   					   0, handle_simple_irq,
>   					   IRQ_TYPE_LEVEL_LOW);


Acked-by: Patrice Chotard <patrice.chotard@st.com>

Thanks
