Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaK1EqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:46:15 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25355 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750754AbaK1EqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:46:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/N+aWLlRPaHvGFJJs6SXi9B+jgDB8d0tw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 12AC4625DCE
Date: Thu, 27 Nov 2014 23:46:04 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irqchip: gic: Remove warning by including linux/irqdomain.h
Message-ID: <20141128044604.GO22670@titan.lakedaemon.net>
References: <20141127172822.593adbd2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127172822.593adbd2@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit

  853a33ce6932 irqchip: gic-v2m: Add support for ARM GICv2m MSI(-X) doorbell

Introduced a series of warnings when building ARM multi_v7_defconfig:

  include/linux/irqchip/arm-gic.h:109:53: warning: its scope is only this definition or declaration, which is probably not what you want
  In file included from arch/arm/mach-ux500/pm.c:13:0:
  include/linux/irqchip/arm-gic.h:109:53: warning: 'struct irq_domain' declared inside parameter list
   int gicv2m_of_init(struct device_node *node, struct irq_domain *parent);
                                                       ^

Fix this by adding the proper include.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
I've added this to irqchip/irqdomain-arm locally and pushed it to next.  If
there are no objections, I'll push it to irqchip/irqdomain-arm.

thx,

Jason.

 include/linux/irqchip/arm-gic.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 60b09ed58cae..d1b2263a4db3 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -10,6 +10,8 @@
 #ifndef __LINUX_IRQCHIP_ARM_GIC_H
 #define __LINUX_IRQCHIP_ARM_GIC_H
 
+#include <linux/irqdomain.h>
+
 #define GIC_CPU_CTRL			0x00
 #define GIC_CPU_PRIMASK			0x04
 #define GIC_CPU_BINPOINT		0x08
-- 
2.1.3

