Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaEGPoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:48537 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaEGPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:55 -0400
Message-Id: <20140507154336.178850165@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Joerg Roedel <joro@8bytes.org>
Subject: [patch 11/32] iommu: dmar: Fix return value check of create_irq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=iommu-dmar-fix-return-value-check-of-create_irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 returns a negative error code when allocation fails andx86
returns 0. Make it handle both.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/drivers/iommu/dmar.c
===================================================================
--- tip.orig/drivers/iommu/dmar.c
+++ tip/drivers/iommu/dmar.c
@@ -1551,7 +1551,7 @@ int dmar_set_interrupt(struct intel_iomm
 		return 0;
 
 	irq = create_irq();
-	if (!irq) {
+	if (irq <= 0) {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
 	}


