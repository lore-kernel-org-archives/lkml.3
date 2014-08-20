Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaHTEIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:08:06 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:54554 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHTEIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:08:04 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org (open list:IOMMU DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc: fsl_pamu_domain: Fix build error
Date: Wed, 20 Aug 2014 00:08:04 -0400
Message-Id: <1408507684-20716-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure in fsl_pamu_domain.o caused as follows

drivers/iommu/fsl_pamu_domain.c: In function 'pamu_domain_init':
drivers/iommu/fsl_pamu_domain.c:1103:17: error: 'pci_bus_type' undeclared
(first use in this function)
drivers/iommu/fsl_pamu_domain.c:1103:17: note: each undeclared identifier is
reported only once for each function it appears in
make[2]: *** [drivers/iommu/fsl_pamu_domain.o] Error 1
make[1]: *** [drivers/iommu] Error 2
make: *** [drivers] Error 2

We fix this by trying to dereference pci_bus_type only if CONFIG_PCI is defined.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/iommu/fsl_pamu_domain.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 61d1daf..bb56f86 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -1099,7 +1099,9 @@ int pamu_domain_init(void)
 		return ret;
 
 	bus_set_iommu(&platform_bus_type, &fsl_pamu_ops);
+#ifdef CONFIG_PCI
 	bus_set_iommu(&pci_bus_type, &fsl_pamu_ops);
+#endif
 
 	return ret;
 }
-- 
1.9.1

