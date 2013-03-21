Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3CUSDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:03:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48561 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3CUSC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <1363820051-24428-4-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
	<1363820051-24428-4-git-send-email-robherring2@gmail.com>
Date: Thu, 21 Mar 2013 19:02:57 +0100
Message-ID: <CACRpkdZCF1KXgGXw2Hj91duGd6kZR8JW0CBhKHRLeXjnfFO7+Q@mail.gmail.com>
Subject: Re: [PATCH 03/11] ARM: timer-sp: convert to use CLKSRC_OF init
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:54 PM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
>
> This adds CLKSRC_OF based init for sp804 timer. The clock initialization is
> refactored to support retrieving the clock(s) from the DT.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
(...)
> @@ -186,6 +201,57 @@ void __init sp804_clockevents_init(void __iomem *base, unsigned int irq,
>         evt->irq = irq;
>         evt->cpumask = cpu_possible_mask;
>
> +       writel(0, clkevt_base + TIMER_CTRL);
> +

Wait, patch 1/11 depends on this being done first, right?

So patch 1/11 has to be moved after this one in the series
to avoid bisectability problems?

Apart from that:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
