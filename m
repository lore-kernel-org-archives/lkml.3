Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3GQWeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:34:15 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:41848 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab3GQWeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:34:14 -0400
Date: Wed, 17 Jul 2013 18:34:11 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Javi Merino <javi.merino@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if UP
 system
In-Reply-To: <51E71249.4050200@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1307171830170.14924@syhkavp.arg>
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org> <20130712111322.GC3213@e102654-lin.cambridge.arm.com> <20130712121023.GB27430@codeaurora.org> <51E71249.4050200@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Stephen Boyd wrote:

> On 07/12/13 05:10, Stephen Boyd wrote:
> > On 07/12, Javi Merino wrote:
> >> I agree, we should drop the check.  It's annoying in uniprocessors and
> >> unlikely to be found in the real world unless your gic entry in the dt
> >> is wrong.

And that's a likely outcome in the real world.

> >>
> > Ok. How about this?
> 
> Any comments?

What about this instead:

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 19ceaa60e0..86d21bc6cb 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -368,7 +368,7 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 			break;
 	}
 
-	if (!mask)
+	if (is_smp() && !mask)
 		pr_crit("GIC CPU mask not found - kernel will fail to boot.\n");
 
 	return mask;


Nicolas
