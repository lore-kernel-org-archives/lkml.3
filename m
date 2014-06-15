Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaFOFQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:16:20 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33539 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaFOFQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZvANiXp2S134jmcsFDr1m=dqGkpsf3Y6ZAg6mvd6RHOQ@mail.gmail.com>
References: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
	<CACRpkdZvANiXp2S134jmcsFDr1m=dqGkpsf3Y6ZAg6mvd6RHOQ@mail.gmail.com>
Date: Sun, 15 Jun 2014 13:16:17 +0800
Message-ID: <CAL8JtxAhx9R2XC11d_eAObnjxFVKQ6R7auvUd_=Uw40HYH3UyQ@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: Add a defer reset object to send board specific reset
From: Houcheng Lin <houcheng@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please see my replies below,

2014-06-12 20:35 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
>
> OK this is interesting stuff..
>
> But this driver *MUST* live under drivers/power/reset/*, as it
> has absolutely *nothing* to do with GPIO except for being a consumer
> of it. I won't merge it.
>
> And you should discuss it with Dmitry and David W.
>
> But I will review it nevertheless :-D

Thanks for this information, I changed source to under drivers/
power/reset.

>
> OK so reset init and reset end is a way to specify when reset
> is asserted (as one or zero).
>
> DON'T do this. The GPIO bindings already know a way to define
> if GPIOs are active high or low, and the gpiod interface will invert
> the signal for you if this is specified as active low.
>
> This way you get rid of both strange properties.
>

May I reserve the "reset-init" and ""reset-end" properties? As
some boards use power line off to reset device. The power line
is active high when as power but active low when as a reset signal.

>
> You forgot to free the deferred_reset_list here. Fix that.
>

Thank a lot for your reviews :) Here are fixed of version 2:
    - change location to drivers/power/reset
    - remove unused #include
    - change to use GPIO descriptor interface and use customer.h
    - free resources after issue reset. However, if a enclosing
      chip is not probled, the correpsonding reset will not send
      and memeory is still not free in this case.
    - other minor fixs

Best regards,
Houcheng Lin
