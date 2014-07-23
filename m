Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaGWPKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:10:30 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44765 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaGWPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>
Date: Wed, 23 Jul 2014 17:10:26 +0200
Message-ID: <CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>, Suman Anna <s-anna@ti.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        ivan.khoronzhuk@ti.com, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 12:43 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> From: Murali Karicheri <m-karicheri2@ti.com>
>
> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
> each DSP core. This is one of the component used by the IPC mechanism used
> on Keystone SOCs.
>
> Keystone 2 DSP GPIO controller has specific features:
> - each GPIO can be configured only as output pin;
> - setting GPIO value to 1 causes IRQ generation on target DSP core;
> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>   pending.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Pardon me. How is this GENERAL PURPOSE Input/Output?

It seems very very much SPECIAL PURPOSE to me, it's like
you're just shoehorning some IPC mechanism into the GPIO
subsystem, and this may be because the datasheet calls it
GPIO when it's not.

What other stuff than DSP is connected to these lines, and is it
really even external lines? Aren't these just polysilicon rails
pretty much hammered to be used by the DSP and nothing else.

What is the difference between this and a mailbox IRQ line
and the kind of stuff handled by drivers/mailbox?

I'd like Suman and Jassi to have a look at this to see if it's
actually a mailbox before we proceed.

And if you proceed with this, please integrate it with
drivers/gpio/gpio-syscon.c, I don't need more special
syscons GPIO handlers.

> +#include <linux/mfd/syscon.h>

Kconfig needs depends on MFD_SYSCON, right?

Yours,
Linus Walleij
