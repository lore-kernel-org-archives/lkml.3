Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbbAUNhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:37:37 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:56002 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbbAUNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:37:32 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYww-6HbmM9uViyB6ZRp2MQnkTYz-7ZxAVN_GsRTNqaoA@mail.gmail.com>
References: <1421316574-10022-1-git-send-email-dbaryshkov@gmail.com>
	<CACRpkdYww-6HbmM9uViyB6ZRp2MQnkTYz-7ZxAVN_GsRTNqaoA@mail.gmail.com>
Date: Wed, 21 Jan 2015 17:37:31 +0400
Message-ID: <CALT56yOuSV9X3m5fkjv16=7PXd8SrkKoy_TyH6DkMpQv68YaEA@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: sa1100: add platform functions to handle PWER settings
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrea Adami <andrea.adami@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2015-01-21 13:05 GMT+03:00 Linus Walleij <linus.walleij@linaro.org>:
>
> On Thu, Jan 15, 2015 at 11:09 AM, Dmitry Eremin-Solenikov
> <dbaryshkov@gmail.com> wrote:
>
> > PWER settings logically belongs neither to GPIO nor to system IRQ code.
> > Add special functions to handle PWER (for GPIO and for system IRQs)
> > from platform code.
> >
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>
> > diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
> (...)
> > +int sa11x0_gpio_set_wake(unsigned int gpio, unsigned int on)
> (...)
> > +int sa11x0_sc_set_wake(unsigned int irq, unsigned int on)
>
> Why are these two functions not added to any .h file?
>
> Did you miss to commit something or are there compile
> warnings about this?

I thought quite a while about adding them to any header. In the end I ended
adding them to the irqchip header file. PWER handling is (a bit) related to IRQ
handling. The only other user of those functions would be a gpio (or pinctrl
if it ends that way) driver.

-- 
With best wishes
Dmitry
