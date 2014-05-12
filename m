Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaELGQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:16:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17646 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaELGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:38 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-8e-5370673708d9
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 02/19] iommu/exynos: change error handling when page table
 update is failed
Date: Mon, 12 May 2014 11:44:47 +0530
Message-id: <1399875304-19948-3-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkVtcivSDY4MtTRos7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6MqasdClaqVcy51s3YwLhMrouRk0NCwESid88fJghbTOLCvfVsXYxcHEIC
	Sxkl9nd8Z4YpejrrLCNEYhGjxIVbs5ghnAlMEqv2vmIDqWITMJTYfu8KK0hCRGA1o0TfxTPs
	IA6zwGxmiSOPFjOCVAkLJEo0T3vOCmKzCKhK/DnzBGw5r4C7xKJri4HGcgDtU5CYM8kGJMwp
	4CHxefUUsAVCQCXHXl0FWyAhsIVDou3CK3aIOQIS3yYfYoHolZXYdADqbEmJgytusExgFF7A
	yLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzBaT/97NmEH470D1ocYk4HGTWSWEk3OB0Z7
	Xkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwyv/N
	2S/ztCfG+7uL0L9oN/XaJzNanG3tAhxu3Pu12qrkTq1pf4HQzLYOw6KHwmZxp7c2/Prib8x/
	e1tcSs8+xYTNLH4dky+UqdSnTlosZuS98viEb6qqBkvsnaIjypcLW83JE166u11YzsPv+tW9
	8+f//F76vMzh9a4LTH5341ecSBVQ3dSvxFKckWioxVxUnAgAiqfIBOwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV3z9IJggzPvjCzu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZkxd7VCwUq1izrVuxgbGZXJdjJwc
	EgImEk9nnWWEsMUkLtxbz9bFyMUhJLCIUeLCrVnMEM4EJolVe1+xgVSxCRhKbL93hRUkISKw
	mlGi7+IZdhCHWWA2s8SRR4vBZgkLJEo0T3vOCmKzCKhK/DnzhAnE5hVwl1h0bTHQWA6gfQoS
	cybZgIQ5BTwkPq+eArZACKjk2KurrBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CE4Fz6R2MK5ssDjEKMDBqMTD+4GhIFiINbGsuDL3EKMEB7OSCO9Hf6AQb0piZVVqUX58UWlO
	avEhxmSgoyYyS4km5wPTVF5JvKGxibmpsamliYWJmSVpwkrivAdarQOFBNITS1KzU1MLUotg
	tjBxcEo1ME6bH3bkXKv4rC3ut5t/2v66z3psYfHE/vNH/H7MZC5OfVfs5u8kIO1Ws+tF6vy7
	Pal7/l2MrK2ZGRtgXRcUnBjUMnnm4s1XZqtLzLB8aK3Td0fKvD3SMm1uhfuTZga7aLOlt/8x
	fT3kVXplmc3+wgk7d/h4WF80jPx541TU4YAalc+/XkbJ2iixFGckGmoxFxUnAgCaUBAhSQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch changes not to panic on any error when updating page table.
Instead prints error messages with callstack.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   58 ++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 8d7c3f9..aec7fd7 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -728,13 +728,18 @@ finish:
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
 
 		*sent = mk_lv1ent_page(virt_to_phys(pent));
 		*pgcounter = NUM_LV2ENTRIES;
@@ -745,14 +750,21 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
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
 
@@ -770,8 +782,10 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
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
@@ -780,7 +794,10 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
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
 
@@ -808,7 +825,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	entry = section_entry(priv->pgtable, iova);
 
 	if (size == SECT_SIZE) {
-		ret = lv1set_section(entry, paddr,
+		ret = lv1set_section(entry, iova, paddr,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
 		unsigned long *pent;
@@ -816,17 +833,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
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
 
@@ -840,6 +856,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
+	size_t err_pgsize;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -848,7 +865,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		BUG_ON(size < SECT_SIZE);
+		if (size < SECT_SIZE) {
+			err_pgsize = SECT_SIZE;
+			goto err;
+		}
 
 		*ent = 0;
 		pgtable_flush(ent, ent + 1);
@@ -879,7 +899,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	BUG_ON(size < LPAGE_SIZE);
+	if (size < LPAGE_SIZE) {
+		err_pgsize = LPAGE_SIZE;
+		goto err;
+	}
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
 
@@ -893,8 +916,15 @@ done:
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

