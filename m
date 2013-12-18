Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3LRGeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:34:36 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35524 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3LRGef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:34:35 -0500
Date: Wed, 18 Dec 2013 12:04:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        josh@joshtriplett.org
Subject: [PATCH 2/3] drivers: iommu: Mark functions as static in
 intel_irq_remapping.c
Message-ID: <ac2232eb56e74f3b891ad53f1a6a542494f04c1e.1387265905.git.rashika.kheria@gmail.com>
References: <6d0cb39e3d1128669e7740943efce3996ab0d8ab.1387265904.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d0cb39e3d1128669e7740943efce3996ab0d8ab.1387265904.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions int get_irte() and ir_dev_scope_init() as static in
intel_irq_remapping.c because they are not used outside this file.

This eliminates the following warnings in intel_irq_remapping.c:
drivers/iommu/intel_irq_remapping.c:49:5: warning: no previous prototype for ‘get_irte’ [-Wmissing-prototypes]
drivers/iommu/intel_irq_remapping.c:810:12: warning: no previous prototype for ‘ir_dev_scope_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/iommu/intel_irq_remapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index bab10b1..c988b8d 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -46,7 +46,7 @@ static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 	return cfg ? &cfg->irq_2_iommu : NULL;
 }
 
-int get_irte(int irq, struct irte *entry)
+static int get_irte(int irq, struct irte *entry)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -807,7 +807,7 @@ int __init parse_ioapics_under_ir(void)
 	return 1;
 }
 
-int __init ir_dev_scope_init(void)
+static int __init ir_dev_scope_init(void)
 {
 	if (!irq_remapping_enabled)
 		return 0;
-- 
1.7.9.5

