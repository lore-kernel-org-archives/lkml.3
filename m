Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaIBR4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:56:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65465 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIBR4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:56:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nO2FpByI9Uwz48W66qULEnsbXchQWUw0=
X-DKIM: OpenDKIM Filter v2.0.1 titan B9B7C5D5E3A
Date: Tue, 2 Sep 2014 13:56:21 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, naveenkrishna.ch@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: exynos-combiner: Fix compilation error on
 ARM64
Message-ID: <20140902175621.GG30467@titan.lakedaemon.net>
References: <1409671492-7725-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409671492-7725-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Tue, Sep 02, 2014 at 08:54:52PM +0530, Naveen Krishna Chatradhi wrote:
> The following compilation error occurs on 64-bit Exynos7 SoC:
> 
> drivers/irqchip/exynos-combiner.c: In function ‘combiner_irq_domain_map’:
> drivers/irqchip/exynos-combiner.c:162:2: error: implicit declaration of function ‘set_irq_flags’ [-Werror=implicit-function-declaration]
>   set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>   ^
> drivers/irqchip/exynos-combiner.c:162:21: error: ‘IRQF_VALID’ undeclared (first use in this function)
>   set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>                      ^
> drivers/irqchip/exynos-combiner.c:162:21: note: each undeclared identifier is reported only once for each function it appears in
> drivers/irqchip/exynos-combiner.c:162:34: error: ‘IRQF_PROBE’ undeclared (first use in this function)
>   set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> 
> Fix the build error by including asm/hardirq.h.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/irqchip/exynos-combiner.c |    2 ++
>  1 file changed, 2 insertions(+)

Please include me in the Cc on future irqchip fixes, I almost missed
this one.

thx,

Jason.
