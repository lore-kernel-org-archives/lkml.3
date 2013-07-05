Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab3GEM3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36075 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3GEM3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:14 -0400
X-AuditID: cbfee68e-b7f276d000002279-4d-51d6bc194948
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: [PATCH v7 2/9] iommu/exynos: add missing cache flush for removed page
 table entries
Date: Fri, 05 Jul 2013 21:29:13 +0900
Message-id: <002a01ce797b$421b5970$c6520c50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d49h2SeAId+HSZirtmyZeFGJug==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zQ13JPdcCDdbfMrN4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZVzf
	epet4C1HxcXdC1gaGFezdzFyckgImEjMXL8MyhaTuHBvPVsXIxeHkMAyRonds++wwhQ9+DIb
	KjGdUeLLgYtMIAkhgb+MEqfOmYHYbAJaEqvnHmcEsUUE7jJKvDzPA9LALHCDSWLDpzYWkISw
	QJzExKNLwZpZBFQlzn/oBrN5BSwlfhz6C2ULSvyYfA+snhlo6Pqdx5kgbHmJzWveMkNcpCCx
	4+xroGXsQMv0JP7GQFSISOx78Y4RZK2EQCOHxOqGW+wQqwQkvk0+BDSSAyghK7HpANQUSYmD
	K26wTGAUm4Vk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MULiuW8H
	480D1ocYk4HWT2SWEk3OB6aDvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwrvmbULhqWezmPUGsIkpqz5R+Pziyd0vK8R8qoX2cPx+1hWj/Mrvg
	u/JKoNp+gW0TNup/r9Mqv3rhylqNyeofit5ad9jEBvP+VE8zOvAl0prj+7J5/zcqs8/gSkkX
	ey+qHGZzvXnLmRt7zy1OEvgUlrDrzZPpa9y3KRs9Oe3WeITlsrjmI+stSkosxRmJhlrMRcWJ
	AHHDJ9/9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV3JPdcCDQ5dNrR4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8y4vvUuW8FbjoqLuxewNDCuZu9i5OSQEDCRePBlNhuELSZx
	4d56IJuLQ0hgOqPElwMXmUASQgJ/GSVOnTMDsdkEtCRWzz3OCGKLCNxllHh5ngekgVngBpPE
	hk9tLCAJYYE4iYlHl4I1swioSpz/0A1m8wpYSvw49BfKFpT4MfkeWD0z0ND1O48zQdjyEpvX
	vGWGuEhBYsfZ10DL2IGW6Un8jYGoEJHY9+Id4wRGgVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iRGcLJ5J72Bc1WBxiFGAg1GJh/dB/dVAIdbEsuLK3EOMEhzM
	SiK89gnXAoV4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5jI8kriDY1NzIwsjcwsjEzMzUkT
	VhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBke2xA/sR23turMoHPBdoOxxy+CcYlZ58Yn/s
	nS0yJ05tlGbcVrs2ckfzdAn1Uw5zQ57bHHY0cF//cWL6h6Lt+wxl2zYd7bq8IyNu+TLtiu6v
	CopptSd7m1WKDlYF/iqLSTTwbPVkzp/acqJL/TjjT5ev0r4bM2ZkSpwpVf0aaZ2kNrv/+ZxL
	SizFGYmGWsxFxYkAgUOjxloDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds cache flush for removed small and large page entries
in exynos_iommu_unmap(). Missing cache flush of removed page table
entries can cause missing page fault interrupt when a master IP
accesses an unmapped area.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 233f382..e3be3e5 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	if (lv2ent_small(ent)) {
 		*ent = 0;
 		size = SPAGE_SIZE;
+		pgtable_flush(ent, ent +1);
 		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
 	}
@@ -1010,6 +1011,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	BUG_ON(size < LPAGE_SIZE);
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
 	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
-- 
1.7.2.5


