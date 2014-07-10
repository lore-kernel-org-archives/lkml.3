Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaGJKpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:45:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38631 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaGJKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:45:04 -0400
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] AMD IOMMU v2: Drop oprofile dependency
Date: Thu, 10 Jul 2014 12:44:56 +0200
Message-Id: <1404989096-20104-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

a40d4c67d7de ("iommu/amd: Implement mmu_notifier_release call-back")
removed the oprofile task_exit notifier hack^Wusage but forgot to
readjust the Kconfig dependency. Fix that.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d260605e6d5f..b2807185bf50 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -76,7 +76,7 @@ config AMD_IOMMU_STATS
 
 config AMD_IOMMU_V2
 	tristate "AMD IOMMU Version 2 driver"
-	depends on AMD_IOMMU && PROFILING
+	depends on AMD_IOMMU
 	select MMU_NOTIFIER
 	---help---
 	  This option enables support for the AMD IOMMUv2 features of the IOMMU
-- 
2.0.0

