Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaD0HlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31207 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaD0Hjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:47 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-df-535cb442a9f5
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 21/31] iommu/exynos: fix address handling
Date: Sun, 27 Apr 2014 13:07:53 +0530
Message-id: <1398584283-22846-22-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkVtdpS0ywwde5ghZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8asV4vY
	C17LVjy6+IOxgfGURBcjJ4eEgInEpvcP2SFsMYkL99azdTFycQgJLGWUWHhlERNM0f3226wg
	tpDAIkaJ9ftyIYomMEm0zFkCVsQmYCix/d4VVpCEiMBqRom+i2fYQRxmgbtMEnNWvWMEqRIW
	sJWYNXMSWAeLgKrE13+3wHbzCnhIdO24DRTnAFqnIDFnkg1ImBMo/OTOHhaIze4Sb099AVsg
	ITCTQ6Jv0g2oOQIS3yYfYoHolZXYdIAZ4mpJiYMrbrBMYBRewMiwilE0tSC5oDgpvchIrzgx
	t7g0L10vOT93EyMwHk//e9a3g/HmAetDjMlA4yYyS4km5wPjOa8k3tDYzMjC1MTU2Mjc0ow0
	YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MLL8ulGsLrew+Gi8Ua/9IY4Tshxc
	r38o1ns84qpaGhfptih507NHXP3xN23ftC2ouiP0e6redSbGozbHzjYsWM4cu6c88/c19kVM
	C173Klc+s9B46Ol7UHGL6u3oA0w6iesk2oKEbtn+NZdOVQ1Yzb7Gwkf6s+GeM98XhzyM+/+3
	dK+h0uO+20osxRmJhlrMRcWJACUsQiPdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV2nLTHBBvOWslncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzZr1axF7wWrbi0cUfjA2MpyS6GDk5JARMJO6332aFsMUkLtxb
	zwZiCwksYpRYvy+3i5ELyJ7AJNEyZwkTSIJNwFBi+70rrCAJEYHVjBJ9F8+wgzjMAneZJOas
	escIUiUsYCsxa+YksA4WAVWJr/9usYPYvAIeEl07bgPFOYDWKUjMmWQDEuYECj+5s4cFYrO7
	xNtTX1gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc7c+kdzCuarA4xCjAwajE
	w/tDOiZYiDWxrLgy9xCjBAezkggv53SgEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDE1Fe
	SbyhsYm5qbGppYmFiZklacJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTC2NvxJ7H/6Np33
	rY3S9zttcd+zzi3ra2T0sJoy83LwrSmCaaukDtdN1JRru5VlliiWMHvrz0fv/3gFmpXcuTgv
	f9Pud+v3r2WcuPTMRuOuptIp7lHrJyqufXsk8c0Jvu3Ox0I85YyS5/1tFFo/4dtGb+bHNjNs
	Dz6cO2U6Q+mahqLkBI9qge3iSizFGYmGWsxFxYkAIWdhXDoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Use of __pa and __va macro is changed to virt_to_phys and phys_to_virt
which are recommended in driver code. printk formatting of physical
address is also fixed to %pa.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 5c7f4d2..08a7ce0 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -131,7 +131,8 @@ static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 
 static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
 {
-	return (unsigned long *)__va(lv2table_base(sent)) + lv2ent_offset(iova);
+	return (unsigned long *)phys_to_virt(
+				lv2table_base(sent)) + lv2ent_offset(iova);
 }
 
 enum exynos_sysmmu_inttype {
@@ -204,7 +205,7 @@ struct sysmmu_drvdata {
 	struct iommu_domain *domain;
 	bool powered_on;
 	bool suspended;
-	unsigned long pgtable;
+	phys_addr_t pgtable;
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -296,17 +297,17 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 
 static void show_fault_information(const char *name,
 		enum exynos_sysmmu_inttype itype,
-		unsigned long pgtable_base, unsigned long fault_addr)
+		phys_addr_t pgtable_base, unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx by %s(Page table base: 0x%lx)\n",
-		sysmmu_fault_name[itype], fault_addr, name, pgtable_base);
+	pr_err("%s occurred at %#lx by %s(Page table base: %pa)\n",
+		sysmmu_fault_name[itype], fault_addr, name, &pgtable_base);
 
-	ent = section_entry(__va(pgtable_base), fault_addr);
+	ent = section_entry(phys_to_virt(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
 
 	if (lv1ent_page(ent)) {
@@ -909,7 +910,7 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
 			kmem_cache_free(lv2table_kmem_cache,
-					__va(lv2table_base(priv->pgtable + i)));
+				phys_to_virt(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -928,8 +929,7 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-
-	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+	ret = __exynos_sysmmu_enable(dev, pagetable, domain);
 	if (ret == 0) {
 		list_add_tail(&owner->client, &priv->clients);
 		owner->domain = domain;
@@ -937,13 +937,14 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %pa\n",
-					__func__, &pagetable);
-	else
-		dev_dbg(dev, "%s: Attached IOMMU with pgtable %pa%s\n",
-					__func__, &pagetable,
-					(ret == 0) ? "" : ", again");
+				__func__, &pagetable);
+		return ret;
+	}
+
+	dev_dbg(dev, "%s: Attached IOMMU with pgtable %pa %s\n",
+		__func__, &pagetable, (ret == 0) ? "" : ", again");
 
 	return ret;
 }
@@ -993,7 +994,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
 
-		*sent = mk_lv1ent_page(__pa(pent));
+		*sent = mk_lv1ent_page(virt_to_phys(pent));
 		*pgcounter = NUM_LV2ENTRIES;
 		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
 		pgtable_flush(sent, sent + 1);
-- 
1.7.9.5

