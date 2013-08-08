Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab3HHJhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:37:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54369 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab3HHJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:37:49 -0400
X-AuditID: cbfee68f-b7f436d000000f81-24-520366df687d
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 02/16] iommu/exynos: add missing cache flush for removed
 page table entries
Date: Thu, 08 Aug 2013 18:37:34 +0900
Message-id: <002601ce941a$e987ba50$bc972ef0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF1PC6SL3HdCxRB+a1f/jcy5kvg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zke79NOYgg8U9rBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TA58Hk8OzmPymN1wkcXjzrU9bB7nN61h9ti8pN5j8o3ljB59W1YxenzeJOdx5egZ
	pgDOKC6blNSczLLUIn27BK6MzltP2QsWclZMmHuCtYHxJnsXIweHhICJxKrDZl2MnECmmMSF
	e+vZuhi5OIQEljFK7L//hBUiYSJx5PpKFojEIkaJ3p41TBDOX0aJR1OvMYNUsQloSayee5wR
	JCEi8JtR4tazOawgDrPAfyaJrbeb2EGqhAUSJGZcW8IGYrMIqErsOPidCcTmFbCU2LW7kw3C
	FpT4MfkeC4jNDDR1/c7jTBC2vMTmNW+ZIW5SkNhx9jUjiC0ioCexYN8ENogaEYl9L96BXSEh
	sJBD4kHbOkaIZQIS3yYfYoF4WlZi0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGK
	phYkFxQnpRcZ6xUn5haX5qXrJefnbmKERH//Dsa7B6wPMSYDrZ/ILCWanA9MHnkl8YbGZkYW
	piamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNxkmRAceVfTpuPz
	N6ZfvJvnGdhU2VQ/7b3pejUueCOjyI+I6XUXTyklqV2eFdPe/eTbnfOVU/s2OD68zug9pSk2
	Nr2i/PoeU14Oj/SYlZcimr+ZnY7UnRo1R7CHZdMDu/XVSmIndpzOaMxddPDYgrm+T+afSJvg
	Em61ivMnR/+aA/N3CL+9IaLEUpyRaKjFXFScCACCo0SUFAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAd37acxBBmf9LO7cPcdqMf8IkHh1
	5AeTxYL91hadszewW/QuuMpm8fHUcXaLTY+vsVpc3jWHzWLG+X1MFhdWbGS3mLLoMKvFyT+9
	jBYt13uZHPg8nhycx+Qxu+Eii8eda3vYPM5vWsPssXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNM
	AZxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUC3
	KymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzOm89ZS9YyFkxYe4J1gbG
	m+xdjJwcEgImEkeur2SBsMUkLtxbz9bFyMUhJLCIUaK3Zw0ThPOXUeLR1GvMIFVsAloSq+ce
	ZwRJiAj8ZpS49WwOK4jDLPCfSWLr7SawucICCRIzri1hA7FZBFQldhz8zgRi8wpYSuza3ckG
	YQtK/Jh8D2w3M9DU9TuPM0HY8hKb17xlhrhJQWLH2deMILaIgJ7Egn0T2CBqRCT2vXjHOIFR
	YBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnlmfSOxhXNVgc
	YhTgYFTi4V3oxhwkxJpYVlyZe4hRgoNZSYT3YjFTkBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJL
	iSbnA9NeXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwruC8
	W3ksrmPKfNEJLYLydlvEpM4UL90XPSXBzEf+m+C6+0WLLnbcv/bz2bSAEMcnPS91K/LzNSMn
	FEzff0v8+Sefy+r/GflDv5b12dVejrzZu9z62dQl1etfO92YFXSbvTzcxrv4zrMVAXlMp8P0
	9TgqJFZIx9b3LRC7kCBwIPG1sckntt9mSizFGYmGWsxFxYkAjvTXL3EDAAA=
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

Tested-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 233f382..d545a25 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	if (lv2ent_small(ent)) {
 		*ent = 0;
 		size = SPAGE_SIZE;
+		pgtable_flush(ent, ent + 1);
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


