Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaLEIsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:48:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:34038 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaLEIsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:48:38 -0500
Message-Id: <20141205084147.472428339@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 05 Dec 2014 08:48:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: [patch 5/5] iommu/vt-d: Convert allocations to GFP_KERNEL
References: <20141204234737.728961990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=iommu-convert-allocations-to-kernel.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason anymore to do GFP_ATOMIC allocations which are not harmful
in the normal bootup case, but matter in the physical hotplug
scenario.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: tip/drivers/iommu/intel_irq_remapping.c
===================================================================
--- tip.orig/drivers/iommu/intel_irq_remapping.c
+++ tip/drivers/iommu/intel_irq_remapping.c
@@ -406,11 +406,11 @@ static int intel_setup_irq_remapping(str
 	if (iommu->ir_table)
 		return 0;
 
-	ir_table = kzalloc(sizeof(struct ir_table), GFP_ATOMIC);
+	ir_table = kzalloc(sizeof(struct ir_table), GFP_KERNEL);
 	if (!ir_table)
 		return -ENOMEM;
 
-	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
+	pages = alloc_pages_node(iommu->node, GFP_KERNEL | __GFP_ZERO,
 				 INTR_REMAP_PAGE_ORDER);
 	if (!pages) {
 		pr_err("IR%d: failed to allocate pages of order %d\n",


