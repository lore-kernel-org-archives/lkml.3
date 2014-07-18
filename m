Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbaGRNRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:17:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28650 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161208AbaGRNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:17:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gY25cX/aiwl6qCSdasRzNoLSB9ZW4hNY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1C44C5AF66B
Date: Fri, 18 Jul 2014 09:17:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] irqchip: gic: Fix core ID calculation when topology is
 read from DT
Message-ID: <20140718131704.GG24496@titan.lakedaemon.net>
References: <1405610624-18722-1-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405610624-18722-1-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:23:44PM +0200, Tomasz Figa wrote:
> Certain GIC implementation, namely those found on earlier, single
> cluster, Exynos SoCs, have registers mapped without per-CPU banking,
> which means that the driver needs to use different offset for each CPU.
> 
> Currently the driver calculates the offset by multiplying value returned
> by cpu_logical_map() by CPU offset parsed from DT. This is correct when
> CPU topology is not specified in DT and aforementioned function returns
> core ID alone. However when DT contains CPU topology, the function
> changes to return cluster ID as well, which is non-zero on mentioned
> SoCs and so breaks the calculation in GIC driver.
> 
> This patch fixes this by masking out cluster ID in CPU offset
> calculation so that only core ID is considered. Multi-cluster Exynos
> SoCs already have banked GIC implementations, so this simple fix should
> be enough.
> 
> Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/irqchip/irq-gic.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index ddee133..5c15a09 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -40,6 +40,7 @@
>  #include <linux/irqchip/chained_irq.h>
>  #include <linux/irqchip/arm-gic.h>

Applied to irqchip/urgent and Cc'd to stable for v3.3+

thx,

Jason.
