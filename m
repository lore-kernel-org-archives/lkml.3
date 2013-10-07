Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3JGBwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:52:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3JGBwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:52:45 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-75-525213ecc984
Date: Mon, 07 Oct 2013 10:52:43 +0900
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
Subject: [PATCH v10 02/20] iommu/exynos: add missing cache flush for removed
 page table entries
Message-id: <20131007105243.bfb2983f50d37183d3362f14@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zI903wkFBBi97JS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlfH93ivGglOcFTtu7mZuYPzP3sXIySEhYCIx
	bd09RghbTOLCvfVsILaQwDJGievf/WBqLk09zdLFyAUUn84osa7jFhOEM4lJ4n/vCrBJLAKq
	EjdW3WEFsdkEtCRWzz3OCFIkItDGJPG18RBYO7PAaWaJVbtXMINUCQskSpzeOZkFxOYVcJT4
	saCDGWKfhcSFpg52iLigxI/J98BqmIGmbt7WxAphy0tsXvOWGWSohMBEDokN3S9ZIc4QkPg2
	GWQbB1BCVmLTAaiZkhIHV9xgmcAoMgvJ2FlIxs5CMnYBI/MqRtHUguSC4qT0IhO94sTc4tK8
	dL3k/NxNjJBInrCD8d4B60OMyUArJzJLiSbnAxNBXkm8obGZkYWpiamxkbmlGWnCSuK86i3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYZ8v59x6O+JOno/7Tzcf2zv5TX7l/ZyVnyP+7
	tJqlzLx8q9K8qDl6DYeS9rJf0elj5evNFg6XaFm48/+nbO7/yRMOPjf5u8y7atrGqx2svO0i
	KoGa8bI3H/GolfxfcWHyJwWJ3rnnf2xb3XDeNXFH0mSntXrfTBJPL+yd07A/S/bAouPPCv8V
	KbEUZyQaajEXFScCAB+jWOj6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd03wkFBBqueCVvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG93uv
	GAtOcVbsuLmbuYHxP3sXIyeHhICJxKWpp1kgbDGJC/fWs3UxcnEICUxnlFjXcYsJwpnEJPG/
	dwVYB4uAqsSNVXdYQWw2AS2J1XOPM4IUiQi0MUl8bTzEAuIwC5xmlli1ewUzSJWwQKLE6Z2T
	wXbwCjhK/FjQwQyxz0LiQlMHO0RcUOLH5HtgNcxAUzdva2KFsOUlNq95yzyBkW8WkrJZSMpm
	ISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4UTyT3sG4qsHiEKMAB6MSD++O+4FB
	QqyJZcWVuYcYJTiYlUR4L9UBhXhTEiurUovy44tKc1KLDzEmA/09kVlKNDkfmMTySuINjU3M
	jCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoExKXv51qojT0qkC+T7WcUP
	hzycaPT3+ym93ta58fMMpn+ce1iMm40zcaN/wVLnZ+d+2/yM8zHcqzghLNRVdFW6QPWFmWtm
	R880+WTsvellyqJrHc0t2WFBmo/av1bvlnzYKXc66FDW/L2tD0q0nk85sNxObIW3M+f2SC3d
	OPkNSyzPTmQ9KymoxFKckWioxVxUnAgAHGB2TlgDAAA=
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

Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Tested-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4876d35..1c3a397 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -958,6 +958,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	if (lv2ent_small(ent)) {
 		*ent = 0;
 		size = SPAGE_SIZE;
+		pgtable_flush(ent, ent + 1);
 		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
 	}
@@ -966,6 +967,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	BUG_ON(size < LPAGE_SIZE);
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
 	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
-- 
1.7.2.5

