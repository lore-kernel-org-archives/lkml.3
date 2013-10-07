Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3JGB6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:58:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14214 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3JGB6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:58:35 -0400
X-AuditID: cbfee68e-b7f756d000004512-c0-5252154a86c2
Date: Mon, 07 Oct 2013 10:58:34 +0900
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
Subject: [PATCH v10 19/20] iommu/exynos: return 0 if iommu_attach_device()
 successes
Message-id: <20131007105834.8373e2d380e309928bdc8e09@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY10v0aAggx2LlCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlXH/9hHWgj7eioXH37M2ML7i6mLk5JAQMJE4
	9mo3K4QtJnHh3nq2LkYuDiGBZYwSJ04cA0pwgBXdXCEPEV/EKLHp5XQmCGcSk8SrfbuYQbpZ
	BFQlrl59wghiswloSayee5wRpEhEoI1J4mvjIRYQh1ngNLPEqt0rwDqEBcIkLlz6DdbBK+Ao
	0dR3hAXiDguJC00d7BBxQYkfk++BxZmBpm7e1sQKYctLbF7zlhlkqITARA6Jx0t6oc4QkPg2
	GWQbyN2yEpsOMEPMlJQ4uOIGywRGkVlIxs5CMnYWkrELGJlXMYqmFiQXFCelFxnpFSfmFpfm
	pesl5+duYoREct8OxpsHrA8xJgOtnMgsJZqcD0wEeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgXLf2hmZn/andYRPXbl54pWjP/q8sX18di7t3
	Rf3e83OTef9vMfLfKxQqsv/3XXO1dxN4rFru+2j3a8fJKM0SVwzN8bdbbxm/1DmHf5mMmuSq
	E2x1P+9wec/XiSlp4tjMvrp6HnvRGT22FSEHT3/5+Gul9oLwTTderVGTvFz8h+2Z468Pvxce
	5lJiKc5INNRiLipOBACclkaF+gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAV0v0aAgg8cdMhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6NFy/VeJov1M16zWMy8tYbFQcDjycF5TB6zGy6yePw73M/kcefaHjaPzUvqPSbfWM7o0bdl
	FaPH501yHleOnmEK4IxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAXpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx//YR
	1oI+3oqFx9+zNjC+4upi5OCQEDCRuLlCvouRE8gUk7hwbz1bFyMXh5DAIkaJTS+nM0E4k5gk
	Xu3bxQxSxSKgKnH16hNGEJtNQEti9dzjjCBFIgJtTBJfGw+xgDjMAqeZJVbtXgHWISwQJnHh
	0m+wDl4BR4mmviMsEPssJC40dbBDxAUlfky+BxZnBpq6eVsTK4QtL7F5zVvmCYx8s5CUzUJS
	NgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWnimdQOxpUNFocYBTgYlXh4d9wP
	DBJiTSwrrsw9xCjBwawkwnupDijEm5JYWZValB9fVJqTWnyIMRno74nMUqLJ+cAUllcSb2hs
	YmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjIXXZnjF1kzp1nD0cvx/
	c3365mJd9bCWjsuzpt5wKlZtjKgQd2cs8eRKkSuQ38b9prN7bt7V28+7ltX2f/RQN5n48CZn
	+PWP9frlcudf9MaHv2g4bDKp9vDBxQv0lYze2e+9dzjhNpPQDDuOWwWOTt4l3n7/YrcvK+LN
	dm3LdNzW975P+8ZDJZbijERDLeai4kQAGvrQlVcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_attach_device() against exynos-iommu positive integer on success
if the caller calls iommu_attach_device() with the same iommu_domain
multiple times without call to iommu_detach_device() to inform the
caller how many calls to iommu_detach_device() to really detach iommu.

However the convention of the return value of success of common API is
zero, this patch makes iommu_attach_device() call against exynos-iommu
always return zero if the given device is successfully attached to
the given iommu_domain even though it is already attached to the same
iommu_domain.

Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 26ba554..5025338 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -759,15 +759,16 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-	else
-		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
-					__func__, __pa(priv->pgtable),
-					(ret == 0) ? "" : ", again");
+		return ret;
+	}
 
-	return ret;
+	dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
+		__func__, __pa(priv->pgtable), (ret == 0) ? "" : ", again");
+
+	return 0;
 }
 
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
-- 
1.7.2.5

