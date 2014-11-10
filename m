Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKJGgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:36:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:54509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaKJGgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364161"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 13/13] iommu/vt-d: Add a command line parameter for VT-d posted-interrupts
Date: Mon, 10 Nov 2014 14:26:52 +0800
Message-Id: <1415600812-27773-14-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable VT-d Posted-Interrtups and add a command line
parameter for it.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 drivers/iommu/irq_remapping.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 0e36860..3cb9429 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -23,7 +23,7 @@ int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
-int disable_irq_post = 1;
+int disable_irq_post = 0;
 int irq_post_enabled = 0;
 EXPORT_SYMBOL_GPL(irq_post_enabled);
 
@@ -206,6 +206,13 @@ static __init int setup_irqremap(char *str)
 }
 early_param("intremap", setup_irqremap);
 
+static __init int setup_nointpost(char *str)
+{
+	disable_irq_post = 1;
+	return 0;
+}
+early_param("nointpost", setup_nointpost);
+
 void __init setup_irq_remapping_ops(void)
 {
 	remap_ops = &intel_irq_remap_ops;
-- 
1.7.1

