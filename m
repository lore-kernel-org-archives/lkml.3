Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3K2Ptj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:49:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48323 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392Ab3K2Ptc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:49:32 -0500
Message-ID: <5298B789.70100@ti.com>
Date: Fri, 29 Nov 2013 10:49:29 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <nsekhar@ti.com>, <prabhakar.csengg@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC v1 3/9] gpio: davinci: use chained_irq_enter/chained_irq_exit
 API
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com> <1385494815-15740-4-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1385494815-15740-4-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 02:40 PM, Grygorii Strashko wrote:
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
> ---
>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

