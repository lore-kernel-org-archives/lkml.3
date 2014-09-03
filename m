Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaICL5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:57:43 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26090 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaICL5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:57:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/hEyBX2Wpp18+7Tv66X8mm1QHgMwQ4zM4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 249E55D6ACA
Date: Wed, 3 Sep 2014 07:57:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, naveenkrishna.ch@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v2] irqchip: exynos-combiner: Fix compilation error on
 ARM64
Message-ID: <20140903115728.GJ30467@titan.lakedaemon.net>
References: <1409722329-18309-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409722329-18309-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 11:02:09AM +0530, Naveen Krishna Chatradhi wrote:
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
> Fix the build error by including linux/interrupt.h.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> ---
> Changes since v1:
> Used linux/interrupt.h instead of asm/hardirq.h
> 
>  drivers/irqchip/exynos-combiner.c |    1 +
>  1 file changed, 1 insertion(+)

Applied to irqchip/urgent

thx,

Jason.
