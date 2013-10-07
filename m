Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3JGBxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:53:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12946 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3JGBxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:53:10 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-b0-5252140470eb
Date: Mon, 07 Oct 2013 10:53:07 +0900
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
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 03/20] iommu/exynos: change error handling when page table
 update is failed
Message-id: <20131007105307.649760aafa6cb73b381d64b9@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zQ10WkaAggy131Szu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbH852vWgieqFYtWujcwvpLtYuTkkBAwkVj9
	qZcNwhaTuHBvPZDNxSEksIxRYuH0vcwwReef34dKLGKUeLhrGQtIQkhgEpPE9HWMIDaLgKrE
	ufXHwSaxCWhJrJ57nBGkQUSgjUnia+MhFhCHWeA0s8Sq3SvAxgoLJEq8P9LACmLzCjhKPH7y
	mRVinYXEhaYOdoi4oMSPyffAtjEDTd28rYkVwpaX2LzmLTPIUAmBiRwS5+b1sUGcISDxbTLI
	Ng6ghKzEpgNQL0hKHFxxg2UCo8gsJGNnIRk7C8nYBYzMqxhFUwuSC4qT0otM9IoTc4tL89L1
	kvNzNzFC4njCDsZ7B6wPMSYDrZzILCWanA9MA3kl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcK
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGST2sbO7Hr26o4vduar+58Fd97eePTKu50eIgWC
	Lz6IXF5Ymdf8a8dX/k32v9NnHT672tLs0yZlNh6PHbs3RHraXgw3vfVEKEUhZlGoqOksLodp
	086+X/T2StyJHc2K186keB/tfR73TNP6reeXZQ2ue/cvesvMcHt17qzOyTs/qqW84jXVn8Os
	xFKckWioxVxUnAgArUHmD/kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV0WkaAggyfrFCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj+c/X
	rAVPVCsWrXRvYHwl28XIySEhYCJx/vl9NghbTOLCvfVANheHkMAiRomHu5axgCSEBCYxSUxf
	xwhiswioSpxbfxysgU1AS2L13OOMIA0iAm1MEl8bD7GAOMwCp5klVu1ewQxSJSyQKPH+SAMr
	iM0r4Cjx+MlnVoh1FhIXmjrYIeKCEj8m3wPbxgw0dfO2JlYIW15i85q3zBMY+WYhKZuFpGwW
	krIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKTxDPpHYyrGiwOMQpwMCrx8O64Hxgk
	xJpYVlyZe4hRgoNZSYT3Uh1QiDclsbIqtSg/vqg0J7X4EGMy0N8TmaVEk/OBCSyvJN7Q2MTM
	yNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjLuVenr5uzrdOjPLKv4lfb
	Uncn8d0Tk7v2l2j/m+S6onTzv+Vaeg1NU2+Efj6rs4Y9dkYd49yfXotPWf/4YKJ5UdZv05WH
	QiZbWLNuyFz/0CJbUnR5/48rWwP+6/jfvbl4gkrl0kUT3Zdap75j2DOZh2vewXi97I/6FROf
	7v+/cdaz3w28328uUmIpzkg01GIuKk4EAM6L695WAwAA
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
 drivers/iommu/exynos-iommu.c |   58 +++++++++++++++++++++++++++++++----------
 1 files changed, 44 insertions(+), 14 deletions(-)

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
1.7.2.5

