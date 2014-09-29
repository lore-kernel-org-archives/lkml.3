Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaI2QKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:10:33 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55534 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaI2QKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <54297D10.9050907@linaro.org>
References: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>
	<542970CF.6040405@linaro.org>
	<CAMf-jSmdNibSK+ffBOdcuVjyhmHFcfi5s4nQzctrS0dK889+FA@mail.gmail.com>
	<54297D10.9050907@linaro.org>
Date: Mon, 29 Sep 2014 21:40:29 +0530
Message-ID: <CAMf-jSnDVw+UEXKwSNmJJ+whuq-Rf07avXP9uPZUxmOE53jg_A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: Fix Sparse error
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 9:08 PM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
>
>
> On 29/09/14 16:05, Pramod Gurav wrote:
>>>
>>> >I think the correct fix is:
>>> >
>>> >diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
>>> >index 5475374..4060c30 100644
>>> >--- a/drivers/pinctrl/pinctrl-st.c
>>> >+++ b/drivers/pinctrl/pinctrl-st.c
>>> >@@ -1512,7 +1512,7 @@ static int st_gpiolib_register_bank(struct
>>> > st_pinctrl
>>> >*info,
>>> >                                              gpio_irq,
>>> > st_gpio_irq_handler);
>>> >         }
>>> >
>>> >-       if (info->irqmux_base > 0 || gpio_irq > 0) {
>>> >+       if (!IS_ERR(info->irqmux_base) || gpio_irq > 0) {
>>> >                 err = gpiochip_irqchip_add(&bank->gpio_chip,
>>
>> But if I am not wrong in function st_pctl_probe_dt, This is already done:
>>
>> if (IS_ERR(info->irqmux_base))
>>              return PTR_ERR(info->irqmux_base);
>>
>> That is the reason I thought there is no need to recheck the pointer
>> info->irqmux_base.
>> Am I misunderstanding something?
>
>
> Ok, we want to add the irqchip only when there is a valid irqmux_base or a
> valid gpio_irq per bank.
>
> As st_gpiolib_register_bank() is used by both types of irq wirings and it
> does not know if irqmux or gpio irq is in use, so we need this explicit
> check. Also we want to make sure that atleast one type is valid before
> adding irqchip.
>
> If you just check for only gpio_irq in this code, you would miss the case
> where irqmux is used.
>
> As Dan pointed you could check if irqmux_base is valid and not remove it
> totally. Removing it will *break* the irqmux support as I explained.
Thanks Srini, Will resend the patch.
>
> thanks,
> srini
>
>
>
>>> >&st_gpio_irqchip,
>>> >                                            0, handle_simple_irq,
>>> >                                            IRQ_TYPE_LEVEL_LOW);
>>> >
>>> >



-- 
Thanks and Regards
Pramod
