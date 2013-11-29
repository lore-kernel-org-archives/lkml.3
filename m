Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3K2IkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:40:03 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:50294 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3K2Ij7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:39:59 -0500
MIME-Version: 1.0
In-Reply-To: <1385494815-15740-4-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
	<1385494815-15740-4-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 29 Nov 2013 09:39:58 +0100
Message-ID: <CACRpkdZ_hd3eVm6Z6ZtvynxX_OXc5Fn-REjmGwgmGasoQRr=jw@mail.gmail.com>
Subject: Re: [RFC v1 3/9] gpio: davinci: use chained_irq_enter/chained_irq_exit
 API
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 8:40 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> It's unsafe to call IRQ chip callbacks (.irq_mask/irq_unmask/irq_ack)
> from chained IRQ handler directly. Because, Davinci GPIO block is used
> by different SoCs, which, in turn, have different Main IRQ controllers
> (Davinci - aintc, cp-intc; Keystone - arm-gic) which may introduce
> diffrent set of IRQ chip callbacks. As result, call of
> gpio_irq_handler() on Keysone will simply cause crash the system,
> because ARM-GIC implements .irq_eoi() instead of .irq_ack().
>
> Hence, fix it by using Kernel chained_irq_enter/chained_irq_exit APIs as
> they are intended to handle exact such cases.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
