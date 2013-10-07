Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3JGB6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:58:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13996 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3JGB6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:58:46 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-4c-5252155525a1
Date: Mon, 07 Oct 2013 10:58:44 +0900
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
Subject: [PATCH v10 20/20] iommu/exynos: add devices attached to the System MMU
 to an IOMMU group
Message-id: <20131007105844.a260f37a9a941bed894adca3@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zI91Q0aAgg3/XJSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlfF1TxNLQRdfxd/X11gbGB9ydzFyckgImEic
	mb2eHcIWk7hwbz0biC0ksIxRYvoUaZianr/HWboYuYDi0xkldv7fywjhTGKSaPy6ghmkikVA
	VWL54UesIDabgJbE6rnHwYpEBNqYJL42HgJrZxY4zSyxajdEh7BAssTVt6+YQGxeAUeJiRMe
	sELss5C40NTBDhEXlPgx+R4LiM0MNHXztiZWCFteYvOat8wQ9b0cEutn8EFcISDxbTLIMg6g
	uKzEpgNQJZISB1fcYJnAKDILydRZSKbOQjJ1ASPzKkbR1ILkguKk9CITveLE3OLSvHS95Pzc
	TYyQOJ6wg/HeAetDjMlAKycyS4km5wPTQF5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGLUcxI7x9OQt7TM4m91x9nDQ1RcLsz5ENvCG1Vr09OyK
	8jdddPSTSOx/PhOT7+/tp//r7uTNfiQfK1OuUti2rawz0nbHi+O3TPdu3+7xKEBboSmJV1P4
	8x2OaqW9KY99n3S842p59LbQouTIm5sxuz2z+W+mbd9t2PN7j/aeJIcCpcXT9sSWK7EUZyQa
	ajEXFScCADfpi435AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd1Q0aAgg18zhS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj654m
	loIuvoq/r6+xNjA+5O5i5OSQEDCR6Pl7nAXCFpO4cG89WxcjF4eQwHRGiZ3/9zJCOJOYJBq/
	rmAGqWIRUJVYfvgRK4jNJqAlsXrucbAiEYE2JomvjYdYQBxmgdPMEqt2Q3QICyRLXH37ignE
	5hVwlJg44QErxD4LiQtNHewQcUGJH5Pvgd3BDDR187YmVghbXmLzmrfMExj5ZiEpm4WkbBaS
	sgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxghPFM+kdjKsaLA4xCnAwKvHw7rgfGCTE
	mlhWXJl7iFGCg1lJhPdSHVCINyWxsiq1KD++qDQntfgQYzLQ3xOZpUST84FJLK8k3tDYxMzI
	0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGNNfX40oPmk916nv/teDyWK/
	d0kfz5n63Z5D/9+89wGh83XdjRMO9C/gYkws7BHvUJtkb/+h3zjzx4bs9DDm4/dLuy9dcZzM
	9mXRmzsri/+0HbF6Vb/d7k6niqnSz0iPlYITrj+vnhNkJtFhqxtlbGbgNcnp6c08tccr0yOi
	Nv88tPLrDodZUUosxRmJhlrMRcWJAIaYYdhYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch written by Antonios Motakis <a.motakis@virtualopensystems.com>:

IOMMU groups are expected by certain users of the IOMMU API,
e.g. VFIO. Since each device is behind its own System MMU, we
can allocate a new IOMMU group for each device.

Reviewd-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/exynos-iommu.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 5025338..24505a0 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1028,6 +1028,32 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
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
@@ -1036,6 +1062,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.map = &exynos_iommu_map,
 	.unmap = &exynos_iommu_unmap,
 	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.add_device = &exynos_iommu_add_device,
+	.remove_device = &exynos_iommu_remove_device,
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
-- 
1.7.2.5

