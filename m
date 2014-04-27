Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaD0HkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31120 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaD0HjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:08 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-03-535cb41be86d
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
Subject: [PATCH v12 07/31] iommu/exynos: always enable runtime PM
Date: Sun, 27 Apr 2014 13:07:39 +0530
Message-id: <1398584283-22846-8-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkVld6S0ywwcnLvBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8byjl3s
	BR/YKxauu8vSwHiKrYuRk0NCwETi4+NbULaYxIV768FsIYGljBKnHofB1MzfP5mxi5ELKL6I
	UaLtSBszhDOBSeLCgomMIFVsAoYS2+9dYQVJiAisZpTou3iGHcRhFrjLJDFn1TuwKmEBR4mv
	834C2RwcLAKqEievi4GEeQXcJfp7bjGDhCUEFCTmTLIBCXMKeEg8ubOHBeIid4m3p76AzZcQ
	mMkh8fbXBiaQBIuAgMS3yYdYIHplJTYdYIa4WlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtUr
	TswtLs1L10vOz93ECIzG0/+eTdzBeP+A9SHGZKBxE5mlRJPzgdGcVxJvaGxmZGFqYmpsZG5p
	Rpqwkjhv+qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MLT+el/CyfGS0S5m75nbH/iXs
	J7e4i0hOeBuubGF38kruh7uVfcm63lIajZ4rhZ0FY5U+nOhyfd539Mv+15NUVIo8QgKvBP3Y
	EBW+5oqf0JWr9icv3P4rdK0xTm1ON4d+rViUS5VHRsL7xP6Fjy5sUU1tf/7ek3eS9NOmpn1/
	JHf4XudTFTFTYinOSDTUYi4qTgQA8TfzmtwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3pLTHBBjtuM1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzlnfsYi/4wF6xcN1dlgbGU2xdjJwcEgImEvP3T2aEsMUkLtxb
	DxTn4hASWMQo0XakjRnCmcAkcWHBRLAqNgFDie33rrCCJEQEVjNK9F08ww7iMAvcZZKYs+od
	WJWwgKPE13k/gWwODhYBVYmT18VAwrwC7hL9PbeYQcISAgoScybZgIQ5BTwkntzZwwJiCwGV
	vD31hXUCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR/kx6B+OqBotDjAIcjEo8
	vD+kY4KFWBPLiitzDzFKcDArifByTgcK8aYkVlalFuXHF5XmpBYfYkwGumkis5Rocj4wEeWV
	xBsam5ibGptamliYmFmSJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2Pj2nvdLtyHrqmK
	CfzuuuFiVH//u8Of/eXXVum4SvPdv7/7wxVV4SpeO+U3j9b77GBrUfm68Eb7iUWhU79t9nyw
	gmcFi/800TNPVjSs2jZntkTppg/SMVLan9v5jkrLOub/XrvJNC21bfc1PpXnUYsV9DniDJes
	9BFuEtrIt+jPxA1Wv8W+CGxUYinOSDTUYi4qTgQAYpBmPjoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Checking if the probing device has a parent device was just to discover
if the probing device is involved in a power domain when the power
domain controlled by Samsung's custom implementation.
Since generic IO power domain is applied, it is required to remove
the condition to see if the probing device has a parent device.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c7f831c..d466076 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -631,8 +631,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	__set_fault_handler(data, &default_fault_handler);
 
-	if (dev->parent)
-		pm_runtime_enable(dev);
+	pm_runtime_enable(dev);
 
 	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
 	return 0;
-- 
1.7.9.5

