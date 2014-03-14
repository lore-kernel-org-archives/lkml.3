Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaCNFCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:02:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50610 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbaCNFCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:02:45 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-77-53228d73bf62
Date: Fri, 14 Mar 2014 14:02:43 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v11 03/27] iommu/exynos: change error handling when page table
 update is failed
Message-id: <20140314140243.853cb1fc76afdc7e713c58da@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ93iXqVgg5b/1hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGX0373GWPBEtWLCxeOsDYyvZLsYOTgkBEwkFr5V7GLk
	BDLFJC7cW8/WxcjFISSwjFHix79edoiEicT37dMYIRKLGCUuLjvJAuFMZpLY1tXECDKJRUBV
	4shzSZAGNgEtidVzj4M1iAi0MUl8bTwE1sAsMJdZ4tnap6wgVcICiRJ7XjQzgdi8Ao4SO29M
	YoRYZyFxoamDHSIuKPFj8j0WEJsZaOrmbU2sELa8xOY1b5lBhkoI9HJIrDp7mRkkwSIgIPFt
	Msg2kN9kJTYdYIaYKSlxcMUNlgmMIrOQjJ2FZOwsJGMXMDKvYhRNLUguKE5KLzLVK07MLS7N
	S9dLzs/dxAiJ3ok7GO8fsD7EmAy0ciKzlGhyPjD680riDY3NjCxMTUyNjcwtzUgTVhLnTX+U
	FCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0SHIRpBf5dlnbUsDjrMPpy9w9hXJ25d/UPbO
	50UutrnHJKY0tkQoBvmEqh8qMczgi7G/F/WoPttd/Ou/FarZZ033dDY+Msw5dWrPI/tQqT9q
	qjrs2m/CuFq35M8T2Lrz7X3l59PenP19bUURv/uvQsHHs1+2JJ93tw/YbT9t9/edtUoaBovK
	lFiKMxINtZiLihMBvqP7ifQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd3iXqVgg8VzzSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0X/3GmPBE9WK
	CRePszYwvpLtYuTkkBAwkfi+fRojhC0mceHeerYuRi4OIYFFjBIXl51kgXAmM0ls62oCquLg
	YBFQlTjyXBKkgU1AS2L13OOMIDUiAm1MEl8bD4E1MAvMZZZ4tvYpK0iVsECixJ4XzUwgNq+A
	o8TOG5Og1llIXGjqYIeIC0r8mHyPBcRmBpq6eVsTK4QtL7F5zVvmCYx8s5CUzUJSNgtJ2QJG
	5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwcnhmdQOxpUNFocYBTgYlXh4HQ4rBguxJpYV
	V+YeYpTgYFYS4a2KUAoW4k1JrKxKLcqPLyrNSS0+xJgM9PZEZinR5Hxg4soriTc0NjEzsjQy
	szAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsaoTR2JIa7KuW5VJ7d2tCnOvi9Z
	2hw069Qdv4mLHDi2Oh+um3/U9ml5sEQN2yf3k+Wp+9YmXjohuvE3Sz3P35x/8Z8P+ehP65/X
	evnBmiTPV+0RNz768bfGzQne2PtTQePspLNxBz++uPD5W9DNk1YPjl1neru04H3HW84NSUeS
	e9SiWHb2Oj1UYinOSDTUYi4qTgQAeLTMh1IDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes not to panic on any error when updating page table.
Instead prints error messages with callstack.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   58 ++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 1c3a397..4a74ed8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -812,13 +812,18 @@ finish:
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 					short *pgcounter)
 {
+	if (lv1ent_section(sent)) {
+		WARN(1, "Trying mapping on %#08lx mapped with 1MiB page", iova);
+		return ERR_PTR(-EADDRINUSE);
+	}
+
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
 		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 
 		*sent = mk_lv1ent_page(__pa(pent));
 		*pgcounter = NUM_LV2ENTRIES;
@@ -829,14 +834,21 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	return page_entry(sent, iova);
 }
 
-static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
+static int lv1set_section(unsigned long *sent, unsigned long iova,
+			  phys_addr_t paddr, short *pgcnt)
 {
-	if (lv1ent_section(sent))
+	if (lv1ent_section(sent)) {
+		WARN(1, "Trying mapping on 1MiB@%#08lx that is mapped",
+			iova);
 		return -EADDRINUSE;
+	}
 
 	if (lv1ent_page(sent)) {
-		if (*pgcnt != NUM_LV2ENTRIES)
+		if (*pgcnt != NUM_LV2ENTRIES) {
+			WARN(1, "Trying mapping on 1MiB@%#08lx that is mapped",
+				iova);
 			return -EADDRINUSE;
+		}
 
 		kfree(page_entry(sent, 0));
 
@@ -854,8 +866,10 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
-		if (!lv2ent_fault(pent))
+		if (!lv2ent_fault(pent)) {
+			WARN(1, "Trying mapping on 4KiB where mapping exists");
 			return -EADDRINUSE;
+		}
 
 		*pent = mk_lv2ent_spage(paddr);
 		pgtable_flush(pent, pent + 1);
@@ -864,7 +878,10 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 		int i;
 		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
 			if (!lv2ent_fault(pent)) {
-				memset(pent, 0, sizeof(*pent) * i);
+				WARN(1,
+				"Trying mapping on 64KiB where mapping exists");
+				if (i > 0)
+					memset(pent - i, 0, sizeof(*pent) * i);
 				return -EADDRINUSE;
 			}
 
@@ -892,7 +909,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	entry = section_entry(priv->pgtable, iova);
 
 	if (size == SECT_SIZE) {
-		ret = lv1set_section(entry, paddr,
+		ret = lv1set_section(entry, iova, paddr,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
 		unsigned long *pent;
@@ -900,17 +917,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 		pent = alloc_lv2entry(entry, iova,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 
-		if (!pent)
-			ret = -ENOMEM;
+		if (IS_ERR(pent))
+			ret = PTR_ERR(pent);
 		else
 			ret = lv2set_page(pent, paddr, size,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	}
 
-	if (ret) {
+	if (ret)
 		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
 							__func__, iova, size);
-	}
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
@@ -924,6 +940,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
+	size_t err_pgsize;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -932,7 +949,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		BUG_ON(size < SECT_SIZE);
+		if (size < SECT_SIZE) {
+			err_pgsize = SECT_SIZE;
+			goto err;
+		}
 
 		*ent = 0;
 		pgtable_flush(ent, ent + 1);
@@ -964,7 +984,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	BUG_ON(size < LPAGE_SIZE);
+	if (size < LPAGE_SIZE) {
+		err_pgsize = LPAGE_SIZE;
+		goto err;
+	}
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
 	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
@@ -979,8 +1002,15 @@ done:
 		sysmmu_tlb_invalidate_entry(data->dev, iova);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-
 	return size;
+err:
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	WARN(1,
+	"%s: Failed due to size(%#x) @ %#08lx is smaller than page size %#x\n",
+	__func__, size, iova, err_pgsize);
+
+	return 0;
 }
 
 static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
-- 
1.7.9.5

