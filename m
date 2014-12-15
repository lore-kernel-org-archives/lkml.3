Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaLOPNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:13:39 -0500
Received: from 8bytes.org ([81.169.241.247]:48623 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaLOPN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:13:29 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/5] iommu/vt-d: Don't check for ecap_ir_support in intel_irq_remapping_supported
Date: Mon, 15 Dec 2014 16:13:21 +0100
Message-Id: <1418656404-28575-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418656404-28575-1-git-send-email-joro@8bytes.org>
References: <1418656404-28575-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This check needs an initialized dmar-table and is already
done in intel_prepare_irq_remapping().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel_irq_remapping.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 3ef63b8..45223ea 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -512,9 +512,6 @@ static int __init dmar_x2apic_optout(void)
 
 static int __init intel_irq_remapping_supported(void)
 {
-	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
-
 	if (disable_irq_remap)
 		return 0;
 	if (irq_remap_broken) {
@@ -532,10 +529,6 @@ static int __init intel_irq_remapping_supported(void)
 	if (!dmar_ir_support())
 		return 0;
 
-	for_each_iommu(iommu, drhd)
-		if (!ecap_ir_support(iommu->ecap))
-			return 0;
-
 	return 1;
 }
 
-- 
1.9.1

