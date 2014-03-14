Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaCNFCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:02:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaCNFCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:02:35 -0400
X-AuditID: cbfee690-b7f266d00000287c-7f-53228d6a2ac4
Date: Fri, 14 Mar 2014 14:02:34 +0900
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
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v11 02/27] iommu/exynos: add missing cache flush for removed
 page table entries
Message-id: <20140314140234.c972b52a96a4fe39acd09fe0@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zI92sXqVgg2O3TSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpYNus5e8FOzoq+zyfYGhg/sHcxcnJICJhI/GuaCWWL
	SVy4t56ti5GLQ0hgGaPEkoNHWWGKpn44wAKRmM4ocbvpEVTVZCaJJYsOMYJUsQioSizb3QQ2
	ik1AS2L13OOMIEUiAm1MEl8bD4G1MwvMZZZ4tvYp2FxhgUSJo18aWEBsXgFHiXf/XrBA7LOQ
	uNDUwQ4RF5T4MfkeWJwZaOrmbU2sELa8xOY1b5lBhkoIdHJIPNk5lxXiDAGJb5NBtnEAJWQl
	Nh1ghpgpKXFwxQ2WCYwis5CMnYVk7CwkYxcwMq9iFE0tSC4oTkovMtErTswtLs1L10vOz93E
	CIngCTsY7x2wPsSYDLRyIrOUaHI+MAHklcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAPjCmMV53XrWlKs/5hPMpisEFD2TOnxOYP5jr9TTqxVe8My
	Y4lp6UqWhKfXHcRKHoWdPNFpueJG+ppk95mvLEKnn/1zRa987cZdVaVSHUe75tYrmL5e75Ct
	aCe8eEf166DzQR1Tf3Vd7jQ1OnTD/JLe460qE9kT/Q2M9PuFt6ZPCeKUk9W7XBmjxFKckWio
	xVxUnAgAAOI2pvYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQd2sXqVgg28d+hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWDbrOXvBTs6K
	vs8n2BoYP7B3MXJySAiYSEz9cIAFwhaTuHBvPVsXIxeHkMB0RonbTY+gnMlMEksWHWIEqWIR
	UJVYtrsJrJtNQEti9dzjjCBFIgJtTBJfGw+xgDjMAnOZJZ6tfcoKUiUskChx9EsD2A5eAUeJ
	d/9eQO2zkLjQ1MEOEReU+DH5HlicGWjq5m1NrBC2vMTmNW+ZJzDyzUJSNgtJ2SwkZQsYmVcx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeHZ9I7GFc1WBxiFOBgVOLhnXFUMViINbGsuDL3
	EKMEB7OSCG9VhFKwEG9KYmVValF+fFFpTmrxIcZkoL8nMkuJJucDU1deSbyhsYmZkaWRmYWR
	ibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCKJvofk7G6v4AlKPOYrd/JtX5WX/nf
	3VWcyJT7e57PzxaLzJW17xffXaEQ4dquFHVXJF056NOhq8/8+HXCPv0XzzZI7vgwJ0suNtqv
	VIxr1oflJySzN3xz0L1wu6bW6GH51s/7Go+6bu5QeuUnZr9Hqm26cVq89lyn803HJx/y6ZH4
	qvJzt4wSS3FGoqEWc1FxIgBg3jW4UwMAAA==
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
 1 file changed, 2 insertions(+)

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
1.7.9.5

