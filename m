Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaKUDUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 22:20:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:2053 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbaKUDUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 22:20:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,428,1413270000"; 
   d="scan'208";a="640907592"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [Patch irqdomain: Enhance irq_domain_free_irqs_common() to support parentless irqdomain
Date: Fri, 21 Nov 2014 11:23:26 +0800
Message-Id: <1416540206-18103-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally irq_domain_free_irqs_common() is designed to be used by
irqdomains with parent. But there are desires to reuse for parentless
irqdomains for code reduction.
So check domain->parent before invoking irq_domain_free_irqs_parent().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Thomas,
	This patch applies to tip/irq/irqdomain, it helps to reduce code
size on ARM. Seems we still have chance to merge it into tip/irq/irqdomain:)
Regards!
Gerry
---
 kernel/irq/irqdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 029acf11efed..0449d2869e17 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -975,7 +975,8 @@ void irq_domain_free_irqs_common(struct irq_domain *domain, unsigned int virq,
 		if (irq_data)
 			irq_domain_reset_irq_data(irq_data);
 	}
-	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+	if (domain->parent)
+		irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
 /**
-- 
1.7.10.4

