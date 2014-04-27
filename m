Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaD0Hki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8562 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaD0Hiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:38:54 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-b4-535cb40c2bb7
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
Subject: [PATCH v12 02/31] iommu/exynos: add missing cache flush for removed
 page table entries
Date: Sun, 27 Apr 2014 13:07:34 +0530
Message-id: <1398584283-22846-3-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkRpd3S0ywwTUhizt3z7FazD8CJF4d
	+cFksWC/tUXn7A3sFt93fWG36F1wlc1i0+NrrBaXd81hs5hxfh+TxYUVG9kt/vUeZLSYsugw
	q8XhN+2sFif/9DJatFzvZbJYP+M1i8WqXX8YLWbeWsPiIOzx5OA8Jo/ZDRdZPP4d7mfy2Dnr
	LrvHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8l5XDl6himAK4rLJiU1J7MstUjfLoEr49y7uILn
	nBXPPk9hbWCcztHFyMkhIWAisWnDAzYIW0ziwr31QDYXh5DAUkaJv1cXs8IUrd86CyqxiFFi
	0YG9TBDOBCaJTwePg1WxCRhKbL93hRUkISKwmlGi7+IZdhCHWeAuk8ScVe8YQaqEBRIlbrR1
	AyU4OFgEVCW61+mBhHkF3CU272hhBAlLCChIzJlkAxLmFPCQeHJnDwuILQRU8vbUF7D5EgIz
	OSSeXlzNBJJgERCQ+Db5EAtEr6zEpgPMEFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UUmesWJ
	ucWleel6yfm5mxiBsXj637MJOxjvHbA+xJgMNG4is5Rocj4wlvNK4g2NzYwsTE1MjY3MLc1I
	E1YS51V7lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdGVvyXnkccuvlnhxy45O285kewr
	/HcVk3Slv5bxIocPhx3zY3IL+UomCspylDRd+zFjp8xzyceM6nV8UmI534qkfHYXmG5Zkvp9
	+nPRi5eaXLQWyEw/tPd/tMfmPafO1tx6Wyz2qiL5wDWGqffntxwy+j1n160705Mv2S2bcpx7
	497UjzoBHWuVWIozEg21mIuKEwFq90l32wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV2eLTHBBq8WGVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzzr2LK3jOWfHs8xTWBsbpHF2MnBwSAiYS67fOYoOwxSQu3FsP
	ZHNxCAksYpRYdGAvE4QzgUni08HjrCBVbAKGEtvvXWEFSYgIrGaU6Lt4hh3EYRa4yyQxZ9U7
	RpAqYYFEiRtt3UAJDg4WAVWJ7nV6IGFeAXeJzTtaGEHCEgIKEnMm2YCEOQU8JJ7c2cMCYgsB
	lbw99YV1AiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBsf5MagfjygaLQ4wCHIxK
	PLwLJGOChVgTy4orcw8xSnAwK4nwck4HCvGmJFZWpRblxxeV5qQWH2JMBrppIrOUaHI+MA3l
	lcQbGpuYmxqbWppYmJhZkiasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjuT++dwN+xax5
	3vLgdqcQh3DyU2kRad+JW6Pma4j3nVknlzh/zWlVJY+qANuu7xHmnBL7vXf+V9B26z00Uemm
	3GY7ISer2YqSvq7Hy9K+X3hqdyXnx/krG85civ90enWJwJbwnnOeq8Q4s0LC2C7qGWxwmRC+
	4P7KO81MprxNIR+zr6Qsu8OhxFKckWioxVxUnAgAEA9eEjkDAAA=
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
---
 drivers/iommu/exynos-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 46f0ca1..34e4273 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -957,6 +957,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	if (lv2ent_small(ent)) {
 		*ent = 0;
 		size = SPAGE_SIZE;
+		pgtable_flush(ent, ent + 1);
 		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
 	}
@@ -965,6 +966,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	BUG_ON(size < LPAGE_SIZE);
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
 	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
-- 
1.7.9.5

