Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaD0HlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaD0Hjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:44 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-f0-535cb43f9b93
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
Subject: [PATCH v12 20/31] iommu/exynos: add devices attached to the System MMU
 to an IOMMU group
Date: Sun, 27 Apr 2014 13:07:52 +0530
Message-id: <1398584283-22846-21-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkWtd+S0ywwYSbshZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8atWcfZ
	CrbxVVybe4GpgbGDp4uRk0NCwETi29rTTBC2mMSFe+vZuhi5OIQEljJKbPjayAhT1LOgiQUi
	sYhRoq29jxnCmcAk8fbCNbB2NgFDie33rrCCJEQEVjNK9F08ww7iMAvcZZKYs+od2CxhgWSJ
	CVcms4DYLAKqEmsPPmIFsXkFPCTeXp4G1MABtE9BYs4kG5AwJ1D4yZ09YOVCAu4Sb099AVsg
	ITCTQ2LJ+ylQcwQkvk0+xALRKyux6QAzxNmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGhXnFi
	bnFpXrpecn7uJkZgRJ7+96x3B+PtA9aHGJOBxk1klhJNzgdGdF5JvKGxmZGFqYmpsZG5pRlp
	wkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MLoEGcgs53WquJ8z32mTgnbjSu9t
	sh85jl+9rt707fG2irBr07lX2aiE/F2mfX1r8brPGkZPV1dZ+IRMf3jg+VaeT1s3HNMQkHSf
	vnGnTM/rvdKMN56cin3QO9umTSyu97j30pqOXffZG5es+fqqMEnjj2bDXcGFl3LZbiz0XPsp
	b/P0uWuKfz1WYinOSDTUYi4qTgQAxLu/T94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV37LTHBBjPuClvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzbs06zlawja/i2twLTA2MHTxdjJwcEgImEj0LmlggbDGJC/fW
	s3UxcnEICSxilGhr72OGcCYwSby9cI0JpIpNwFBi+70rrCAJEYHVjBJ9F8+wgzjMAneZJOas
	escIUiUskCwx4cpksLksAqoSaw8+YgWxeQU8JN5engbUwAG0T0FiziQbkDAnUPjJnT1g5UIC
	7hJvT31hncDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcLw/k97BuKrB4hCjAAej
	Eg/vD+mYYCHWxLLiytxDjBIczEoivJzTgUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD0xF
	eSXxhsYm5qbGppYmFiZmlqQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWDO/g2eZYZzR
	JDOdXbebXk+cvi7ZM+iT2JZPzG+3//4Vzryh7lGnR9/rKw3fZqpOLXii+Fkz9OW/araAjYXX
	/R5Pdlioqn857M7RhbrS9h4FHRGPpkd+dTA/z897bdH1PY/Vn22S/hGgWe4ZyDFr01KBemO/
	YpuSbX8C38qqC2xQq4n/tGzbWyWW4oxEQy3mouJEAIr2HBM7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Patch written by Antonios Motakis <a.motakis@virtualopensystems.com>:

IOMMU groups are expected by certain users of the IOMMU API,
e.g. VFIO. Since each device is behind its own System MMU, we
can allocate a new IOMMU group for each device.

Reviewd-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/exynos-iommu.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c9076e1..5c7f4d2 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1208,6 +1208,32 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
+static int exynos_iommu_add_device(struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(dev);
+
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group)) {
+			dev_err(dev, "Failed to allocate IOMMU group\n");
+			return PTR_ERR(group);
+		}
+	}
+
+	ret = iommu_group_add_device(group, dev);
+	iommu_group_put(group);
+
+	return ret;
+}
+
+static void exynos_iommu_remove_device(struct device *dev)
+{
+	iommu_group_remove_device(dev);
+}
+
 static struct iommu_ops exynos_iommu_ops = {
 	.domain_init = &exynos_iommu_domain_init,
 	.domain_destroy = &exynos_iommu_domain_destroy,
@@ -1216,6 +1242,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.map = &exynos_iommu_map,
 	.unmap = &exynos_iommu_unmap,
 	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.add_device = &exynos_iommu_add_device,
+	.remove_device = &exynos_iommu_remove_device,
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
-- 
1.7.9.5

