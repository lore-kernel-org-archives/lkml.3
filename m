Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaELGQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:16:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17646 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbaELGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:39 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-96-537067443093
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
Subject: [PATCH v13 06/19] iommu/exynos: add missing cache flush for removed
 page table entries
Date: Mon, 12 May 2014 11:44:51 +0530
Message-id: <1399875304-19948-7-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkRtclvSDYYNFkeYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6Mn9/2shR0cVWs+LOdqYFxG0cXIyeHhICJxLKTR1khbDGJC/fWs3UxcnEI
	CSxllNh4YDYjTNHurgtMEIlFjBLn2j8yQzgTmCSmPj7BDFLFJmAosf3eFVaQhIjAakaJvotn
	2EEcZoHZzBJHHi0GmyUskChxdFIr2EIWAVWJiU+WsoHYvALuEvu2zAKyOYD2KUjMmWQDEuYU
	8JD4vHoKWIkQUMmxV1fBFkgIbOGQWDPrKCPEHAGJb5MPsUD0ykpsOsAMcbakxMEVN1gmMAov
	YGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREYr6f/PevbwXjzgPUhxmSgcROZpUST84Hx
	nlcSb2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGCWf
	X4tX/6j8TVX9OBPr2cfvoh5/tLrl5fK99YPP7tSTJsmnNm773HIoT3MLp8F0gatrzqXETvGY
	0NGS7qHmlp73atqRIHWRmVsOz9d/x5VkqOzUfa0s2KnPxeySWb3vGW0vnY3WjtNzrkfd2vqv
	hHl9w03Wdqez1zawX3ifXrGDr/qbw+w9L5RYijMSDbWYi4oTASXdVKrtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV2X9IJgg1vLRSzu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZvz8tpeloIurYsWf7UwNjNs4uhg5
	OSQETCR2d11ggrDFJC7cW8/WxcjFISSwiFHiXPtHZghnApPE1McnmEGq2AQMJbbfu8IKkhAR
	WM0o0XfxDDuIwywwm1niyKPFjCBVwgKJEkcntbKC2CwCqhITnyxlA7F5Bdwl9m2ZBWRzAO1T
	kJgzyQYkzCngIfF59RSwEiGgkmOvrrJOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4GTyT3sG4qsHiEKMAB6MSD+8HhoJgIdbEsuLK3EOMEhzMSiK8H/2BQrwpiZVVqUX58UWl
	OanFhxiTgY6ayCwlmpwPTFR5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgt
	gtnCxMEp1cC4YM/fqLpe+c77qmHPt370iWrxnC1/WDb6zbHpVuvMZt7q+mh9jUVxlfBSoclT
	uWdFTOAOennL94OccC3T983zwgPWF+juvND7PzR+nvq60Mc72WcGxRcdWprG72lReGCl0I1A
	13VZMlb9859NW3eh4KHC6wjdUt87nzfUFK2f3eXVxjq5UXKrEktxRqKhFnNRcSIAbf2AB0oD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This commit adds cache flush for removed small and large page entries
in exynos_iommu_unmap(). Missing cache flush of removed page table
entries can cause missing page fault interrupt when a master IP
accesses an unmapped area.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Tested-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4fc31fc..6915235 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -904,6 +904,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	if (lv2ent_small(ent)) {
 		*ent = 0;
 		size = SPAGE_SIZE;
+		pgtable_flush(ent, ent + 1);
 		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
 	}
@@ -915,6 +916,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
 	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
-- 
1.7.9.5

