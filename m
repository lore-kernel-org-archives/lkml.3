Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaELGSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:18:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35615 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaELGRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:17:05 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-c9-53706760fea7
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
Subject: [PATCH v13 15/19] iommu/exynos: enhanced error messages
Date: Mon, 12 May 2014 11:45:00 +0530
Message-id: <1399875304-19948-16-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkVjchvSDYoOUKu8Wdu+dYLf5OOsZu
	Mf8IkPXqyA8miwX7rS06Z29gt/i+6wu7Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLC6s2Mhu8a/3
	IKPFlEWHWS0Ov2lntTj5p5fR4sjD3ewWLdd7mSzWz3jNYrFq1x9Gi5m31rA4iHo8OTiPyeP3
	r0mMHrMbLrJ4/Dvcz+Sxc9Zddo871/aweWxeUu8x+cZyRo++LasYPT5vkvO4cvQMUwB3FJdN
	SmpOZllqkb5dAlfGzIbH7AVnxSq+fVrP3sD4QbCLkZNDQsBE4teChewQtpjEhXvr2UBsIYGl
	jBJnJ6XC1Fw908nUxcgFFF/EKLHi0ipWiKIJTBJL2vlAbDYBQ4nt966wghSJCKxmlOi7eIYd
	xGEWmM0sceTRYkaQKmEBB4m/Tz4xdzFycLAIqEqcWQ3WzCvgIXF05RRWkLCEgILEnEk2IGFO
	oPDn1VOgDnKXOPbqKth8CYEtHBKzX7xjBkmwCAhIfJt8iAWiV1Zi0wFmiKMlJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzASD3971nvDsbbB6wPMSYDjZvILCWanA+M
	9LySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNzq
	5+0voy8V8nl208qVe9d6nNqqUKD+2pjngOcsE/7EpiSru7t3m94QTvzTon3X+Nf772eOC/67
	ml+5c17pirVs28rY1vILrLzDpvrtjdOGlQH7phemOwox6bPutN64W2Bz3S2PZJ2K+gu8V3hP
	83lvdF5vPPOA/mXZE/WBqU9CKhw+MKklNSmxFGckGmoxFxUnAgAdrgQ36gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd349IJgg5+nbSzu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZsxseMxecFas4tun9ewNjB8Euxg5
	OSQETCSunulkgrDFJC7cW8/WxcjFISSwiFFixaVVrCAJIYEJTBJL2vlAbDYBQ4nt966wghSJ
	CKxmlOi7eIYdxGEWmM0sceTRYkaQKmEBB4m/Tz4xdzFycLAIqEqcWQ3WzCvgIXF05RRWkLCE
	gILEnEk2IGFOoPDn1VPYIHa5Sxx7dZV1AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBieCZ9A7GVQ0WhxgFOBiVeHg/MBQEC7EmlhVX5h5ilOBgVhLh/egPFOJNSaysSi3Kjy8q
	zUktPsSYDHTTRGYp0eR8YJLKK4k3NDYxNzU2tTSxMDGzJE1YSZz3YKt1oJBAemJJanZqakFq
	EcwWJg5OqQZGtykXVYpc5HJ2yunZnz0vWbeQN8/jRJlidZM1yxvX1aY7vXZIWl8O4Uzw1ii9
	Ifg1QiFFhZ1/SnBZ6Xz52/PW/K/yWpx/79KExXPZ6k2eHNzO5s6Xeixpdee8xljnfVuu/NEs
	2OM3sX1+5flvGj/3tO9sC5KofWPCdbF35193lvTi9UsdmQuVWIozEg21mIuKEwE7ryraSAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Some redundant error message is removed and some error messages
are changed to error level from debug level.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index d18dc37..7188b47 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -525,7 +525,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
-		dev_dbg(dev, "Unable to find IRQ resource\n");
+		dev_err(dev, "Unable to find IRQ resource\n");
 		return irq;
 	}
 
@@ -787,10 +787,8 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
-		if (!lv2ent_fault(pent)) {
-			WARN(1, "Trying mapping on 4KiB where mapping exists");
+		if (WARN_ON(!lv2ent_fault(pent)))
 			return -EADDRINUSE;
-		}
 
 		*pent = mk_lv2ent_spage(paddr);
 		pgtable_flush(pent, pent + 1);
@@ -798,9 +796,7 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 	} else { /* size == LPAGE_SIZE */
 		int i;
 		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
-			if (!lv2ent_fault(pent)) {
-				WARN(1,
-				"Trying mapping on 64KiB where mapping exists");
+			if (WARN_ON(!lv2ent_fault(pent))) {
 				if (i > 0)
 					memset(pent - i, 0, sizeof(*pent) * i);
 				return -EADDRINUSE;
@@ -847,8 +843,8 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 	}
 
 	if (ret)
-		pr_debug("%s: Failed to map iova %#x/%#zx bytes\n",
-							__func__, iova, size);
+		pr_err("%s: Failed(%d) to map %#zx bytes @ %#x\n",
+			__func__, ret, size, iova);
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
@@ -872,7 +868,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		if (size < SECT_SIZE) {
+		if (WARN_ON(size < SECT_SIZE)) {
 			err_pgsize = SECT_SIZE;
 			goto err;
 		}
@@ -907,7 +903,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	if (size < LPAGE_SIZE) {
+	if (WARN_ON(size < LPAGE_SIZE)) {
 		err_pgsize = LPAGE_SIZE;
 		goto err;
 	}
@@ -929,9 +925,8 @@ done:
 err:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
-	WARN(1,
-	"%s: Failed due to size(%#zx) @ %#x is smaller than page size %#zx\n",
-	__func__, size, iova, err_pgsize);
+	pr_err("%s: Failed: size(%#zx) @ %#x is smaller than page size %#zx\n",
+		__func__, size, iova, err_pgsize);
 
 	return 0;
 }
-- 
1.7.9.5

