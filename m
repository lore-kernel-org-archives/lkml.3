Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3JGBxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:53:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12997 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab3JGBxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:53:34 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-33-5252141da119
Date: Mon, 07 Oct 2013 10:53:32 +0900
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
Subject: [PATCH v10 04/20] iommu/exynos: fix L2TLB invalidation
Message-id: <20131007105332.19e4b08b18e6092a466c3928@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY11ZkaAggzO7eSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAldFzfy9zwWHxig/z1zE2MP4Q6mLk5JAQMJF4
	eaOVFcIWk7hwbz1bFyMXh5DAMkaJI4camGGKTi1oYASxhQSmM0r0vKuGKJrEJPH26EJ2kASL
	gKrEvF2/WUBsNgEtidVzjzOCFIkItDFJfG08xALiMAucZpZYtXsF2FhhAXuJN9N+sIHYvAKO
	Elv/XoK6w0LiQlMHO0RcUOLH5HtgU5mBpm7e1sQKYctLbF7zlhlkqITARA6Jt9c/M0KcISDx
	bTLINg6ghKzEpgNQL0hKHFxxg2UCo8gsJGNnIRk7C8nYBYzMqxhFUwuSC4qT0osM9YoTc4tL
	89L1kvNzNzFCIrl3B+PtA9aHGJOBVk5klhJNzgcmgrySeENjMyMLUxNTYyNzSzPShJXEedVa
	rAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MF6zn+7+99uyFytlXBet+2rNaxa18In/MmOb
	nbLhanvUrlmcXxZ19uKKbRH5IfnPdLhYWwJmRl6b8K5zt0N2y4mVj25ob2FgTHjPcXqyj+fJ
	xMgERQ6X9EN/qjZmaZiwRtxIPV+nudznPou/zDbnv226Ki67L9bOtDVvt9nhlRD0kHv71OZ0
	NyWW4oxEQy3mouJEANb4sCf6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQV1ZkaAggz1n2S3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjGj5/5e
	5oLD4hUf5q9jbGD8IdTFyMkhIWAicWpBAyOELSZx4d56NhBbSGA6o0TPu+ouRi4gexKTxNuj
	C9lBEiwCqhLzdv1mAbHZBLQkVs89zghSJCLQxiTxtfEQC4jDLHCaWWLV7hXMIFXCAvYSb6b9
	ABvLK+AosfXvJVaIdRYSF5o62CHighI/Jt8Dm8oMNHXztiZWCFteYvOat8wTGPlmISmbhaRs
	FpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC08Qz6R2MqxosDjEKcDAq8fDuuB8Y
	JMSaWFZcmXuIUYKDWUmE91IdUIg3JbGyKrUoP76oNCe1+BBjMtDfE5mlRJPzgSksryTe0NjE
	zMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYmwRXGa7i11oh7/c5oPvw
	6rzpk5OzbVjaH1/dtaI5MZ7zSMRubQf3X4yuYco3UrkqhS9u9V/43v+wlbP7bJnEU3qqx64K
	n3O04nyxeErB3cV/H82IPrNGy0Cx60qyvNOHpivBlR+2N+1bz1Jd9VjizkuTxrOBx77F79rY
	GHf0xCaDystb1S+rKrEUZyQaajEXFScCACMTDHdXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L2TLB is 8-way set-associative TLB with 512 entries. The number of
sets is 64.
A single 4KB(small page) translation information is cached
only to a set whose index is the same with the lower 6 bits of the page
frame number.
A single 64KB(large page) translation information can be
cached to any 16 sets whose top two bits of their indices are the same
with the bit [5:4] of the page frame number.
A single 1MB(section) or larger translation information can be cached to
any set in the TLB.

It is required to invalidate entire sets that may cache the target
translation information to guarantee that the L2TLB has no stale data.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4a74ed8..cbe1e5a 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -225,9 +225,14 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
 }
 
 static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
-						unsigned long iova)
+				unsigned long iova, unsigned int num_inv)
 {
-	__raw_writel((iova & SPAGE_MASK) | 1, sfrbase + REG_MMU_FLUSH_ENTRY);
+	unsigned int i;
+	for (i = 0; i < num_inv; i++) {
+		__raw_writel((iova & SPAGE_MASK) | 1,
+				sfrbase + REG_MMU_FLUSH_ENTRY);
+		iova += SPAGE_SIZE;
+	}
 }
 
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
@@ -477,7 +482,8 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
+static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
+					size_t size)
 {
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
@@ -487,9 +493,20 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	if (is_sysmmu_active(data)) {
 		int i;
 		for (i = 0; i < data->nsfrs; i++) {
+			unsigned int maj;
+			unsigned int num_inv = 1;
+			maj = __raw_readl(data->sfrbases[i] + REG_MMU_VERSION);
+			/*
+			 * L2TLB invalidation required
+			 * 4KB page: 1 invalidation
+			 * 64KB page: 16 invalidation
+			 * 1MB page: 64 invalidation
+			 */
+			if ((maj >> 28) == 2) /* major version number */
+				num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
 			if (sysmmu_block(data->sfrbases[i])) {
 				__sysmmu_tlb_invalidate_entry(
-						data->sfrbases[i], iova);
+					data->sfrbases[i], iova, num_inv);
 				sysmmu_unblock(data->sfrbases[i]);
 			}
 		}
@@ -999,7 +1016,7 @@ done:
 
 	spin_lock_irqsave(&priv->lock, flags);
 	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
-- 
1.7.2.5

