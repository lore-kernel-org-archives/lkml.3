Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaEHUtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:49:15 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54760 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaEHUtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:49:12 -0400
Subject: [PATCH v3 4/4] iommu/exynos: Remove unnecessary "&" from function
 pointers
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 08 May 2014 14:49:14 -0600
Message-ID: <20140508204914.17877.15500.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140508204257.17877.4639.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140508204257.17877.4639.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary "&" from function pointers in exynos_iommu_ops.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/iommu/exynos-iommu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 074018979cdf..2ca0744b0a45 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1011,13 +1011,13 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 }
 
 static struct iommu_ops exynos_iommu_ops = {
-	.domain_init = &exynos_iommu_domain_init,
-	.domain_destroy = &exynos_iommu_domain_destroy,
-	.attach_dev = &exynos_iommu_attach_device,
-	.detach_dev = &exynos_iommu_detach_device,
-	.map = &exynos_iommu_map,
-	.unmap = &exynos_iommu_unmap,
-	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.domain_init = exynos_iommu_domain_init,
+	.domain_destroy = exynos_iommu_domain_destroy,
+	.attach_dev = exynos_iommu_attach_device,
+	.detach_dev = exynos_iommu_detach_device,
+	.map = exynos_iommu_map,
+	.unmap = exynos_iommu_unmap,
+	.iova_to_phys = exynos_iommu_iova_to_phys,
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 

