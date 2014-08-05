Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaHEK4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:56:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaHEKtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:00 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-91-53e0b69a4be9
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 11/29] DRM: exynos: add DRIVER_HAS_OWN_IOMMU_MANAGER flag to
 all sub-drivers
Date: Tue, 05 Aug 2014 12:47:39 +0200
Message-id: <1407235677-26324-12-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7qztj0INuh5o2Dxd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgyjh29wlTwS7JimlT9rE2MF4X7WLk5JAQMJHY
	OGcSO4QtJnHh3nq2LkYuDiGBpYwSWx7OZoRw+pgktpx8B1bFJmAo0fW2C6xKRKCXUaK/6QcT
	iMMssI5VYn/vdRaQKmGBOInv69ezgtgsAqoSJ+/dZASxeQU8JabcvcAMsU9O4v/LFUwgNidQ
	/PDNA2D1QgIeEj83rGGfwMi7gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZI7Hzdwbj0
	mNUhRgEORiUeXoW9d4OFWBPLiitzDzFKcDArifBKrHkQLMSbklhZlVqUH19UmpNafIiRiYNT
	qoHRU9mS18BnxYvrc2d6beOb0/8nMvxYJNuux1v1WH/snf+Qwyzv4KdY/9O2HBxJv6b8nFIs
	UPHDlVWppdTf6vfHr+clnxad9ju8M7u3Wb7Z9EUa49xNS323Jf4uLbgVKX3pxg9d5ZT31Vd5
	7vIyHWLvjnTZM4d3bm5THufdawc/z3wi8nvTqefzlFiKMxINtZiLihMBgq/ud3sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos DRM drivers do their own management of IO address space of all
controlled devices, so set DRIVER_HAS_OWN_IOMMU_MANAGER flag to instruct
IOMMU subsystem not to create any defaults for them.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 1 +
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    | 1 +
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     | 1 +
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 1 +
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 1 +
 drivers/gpu/drm/exynos/exynos_mixer.c       | 1 +
 6 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 831dde9..fe84215 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1896,6 +1896,7 @@ struct platform_driver fimc_driver = {
 		.name	= "exynos-drm-fimc",
 		.owner	= THIS_MODULE,
 		.pm	= &fimc_pm_ops,
+		.flags	= DRIVER_HAS_OWN_IOMMU_MANAGER,
 	},
 };
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 33161ad..41904df 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -1031,5 +1031,6 @@ struct platform_driver fimd_driver = {
 		.name	= "exynos4-fb",
 		.owner	= THIS_MODULE,
 		.of_match_table = fimd_driver_dt_match,
+		.flags	= DRIVER_HAS_OWN_IOMMU_MANAGER,
 	},
 };
diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 8001587..dddeae3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -1555,5 +1555,6 @@ struct platform_driver g2d_driver = {
 		.owner	= THIS_MODULE,
 		.pm	= &g2d_pm_ops,
 		.of_match_table = exynos_g2d_match,
+		.flags	= DRIVER_HAS_OWN_IOMMU_MANAGER,
 	},
 };
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 9e3ff16..76e8b1e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1797,6 +1797,7 @@ struct platform_driver gsc_driver = {
 		.name	= "exynos-drm-gsc",
 		.owner	= THIS_MODULE,
 		.pm	= &gsc_pm_ops,
+		.flags	= DRIVER_HAS_OWN_IOMMU_MANAGER,
 	},
 };
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_rotator.c b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
index f01fbb6..2da91c4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_rotator.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
@@ -852,5 +852,6 @@ struct platform_driver rotator_driver = {
 		.owner	= THIS_MODULE,
 		.pm	= &rotator_pm_ops,
 		.of_match_table = exynos_rotator_match,
+		.flags	= DRIVER_HAS_OWN_IOMMU_MANAGER,
 	},
 };
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 7529946..79b1309a 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1320,6 +1320,7 @@ struct platform_driver mixer_driver = {
 		.name = "exynos-mixer",
 		.owner = THIS_MODULE,
 		.of_match_table = mixer_match_types,
+		.flags	= DRIVER_HAS_OWN_IOMMU_MANAGER,
 	},
 	.probe = mixer_probe,
 	.remove = mixer_remove,
-- 
1.9.2

