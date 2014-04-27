Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaD0HkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8573 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaD0Hi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:38:59 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-df-535cb4120235
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
Subject: [PATCH v12 04/31] iommu/exynos: fix L2TLB invalidation
Date: Sun, 27 Apr 2014 13:07:36 +0530
Message-id: <1398584283-22846-5-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkVldoS0ywwZoLBhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV0bLqdus
	BcskK15veMfcwDhfpIuRk0NCwETi889eJghbTOLCvfVsXYxcHEICSxklvpydyARTdKxzCSNE
	YhGjxKMTM6CcCUwSV1d1g1WxCRhKbL93hRUkISKwmlGi7+IZdhCHWeAuk8ScVe8YQaqEBewl
	nl34wg5iswioSkya9RCsm1fAXWL60+NANRxA+xQk5kyyAQlzCnhIPLmzhwXEFgIqeXvqC9gC
	CYGZHBI/Pl1khJgjIPFt8iEWiF5ZiU0HmCHOlpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLTPWK
	E3OLS/PS9ZLzczcxAiPy9L9nE3cw3j9gfYgxGWjcRGYp0eR8YETnlcQbGpsZWZiamBobmVua
	kSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjxUpWx1lSfN02U/LOHLwcfzXH
	+H0Cg8HkHr7an3eT56f7PNPkXHX53HWJ6lmfFeWaJHOdbnxkebq4fbqceD1rxpnTDGLuH77o
	mC68tOR3zHHLVV2LGJ+49c17uX7+50wnvitrptc3XO3+tVgpKuZ6Zde866z3PNjjQr2uf731
	6AHPpuCL4QbvlViKMxINtZiLihMBuLwDY94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV2hLTHBBvvnqljcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzWk7dZi1YJlnxesM75gbG+SJdjJwcEgImEsc6lzBC2GISF+6t
	Z+ti5OIQEljEKPHoxAxGCGcCk8TVVd1MIFVsAoYS2+9dYQVJiAisZpTou3iGHcRhFrjLJDFn
	1TuwWcIC9hLPLnxhB7FZBFQlJs16CNbNK+AuMf3pcaAaDqB9ChJzJtmAhDkFPCSe3NnDAmIL
	AZW8PfWFdQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH+THoH46oGi0OMAhyM
	Sjy8P6RjgoVYE8uKK3MPMUpwMCuJ8HJOBwrxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjAV
	5ZXEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDoxLnBObZb3ex
	M6l4te7RO7ptebdT7tL2sycOxegcYHsWbM/QWess+MjM2aPGTb6gzoF///KZDKtlymcHSZUu
	Xs1bKX1C87dKD29ji+rS1yv1fRS5fJXTb/LoBj4+z2XY+Fq5+tPqithnefosWmd5X7DJ7njc
	sKxs5dFEjoCZM93bpkbOqNyixFKckWioxVxUnAgANP/ssDsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

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
 drivers/iommu/exynos-iommu.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 84fc3b4..7ce44a8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -224,9 +224,14 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
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
@@ -476,7 +481,8 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
+static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
+					size_t size)
 {
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
@@ -486,9 +492,24 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
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
+			 * because it is set-associative TLB
+			 * with 8-way and 64 sets.
+			 * 1MB page can be cached in one of all sets.
+			 * 64KB page can be one of 16 consecutive sets.
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
@@ -998,7 +1019,7 @@ done:
 
 	spin_lock_irqsave(&priv->lock, flags);
 	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
-- 
1.7.9.5

