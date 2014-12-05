Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaLENr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:47:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22106 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaLENr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:47:56 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-86-5481b78a481f
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] iommu: Fix build of allmod/allyes config on ARMv8 architecture
Date: Fri, 05 Dec 2014 14:47:37 +0100
Message-id: <1417787257-10056-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xq7pd2xtDDP5PUrDYOGM9q8WC/dYW
	nbM3sFu8fmFocbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rI7cHo8OTiPyWPzknqPyTeWM3r0
	bVnF6PF5k1wAaxSXTUpqTmZZapG+XQJXxvp165gLWoQqGq9sZGpgPMrXxcjJISFgIrFs2QJ2
	CFtM4sK99WxdjFwcQgJLGSU+dRxjBUnwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh
	6vuYJCYeu8cEkmATMJbYvHwJ2CARgfWMEguev2QFcZgFjjJKTO99C1YlLOAvcendVhYQm0VA
	VeJeyw8miG3uEq+6JrBCnCQncfLYZNYJjHyzkBwyC+GQWUgOWcDIvIpRNLU0uaA4KT3XSK84
	Mbe4NC9dLzk/dxMjJIi/7mBceszqEKMAB6MSD++PuMYQIdbEsuLK3EOMEhzMSiK8ybOBQrwp
	iZVVqUX58UWlOanFhxiZODilGhjlm5P5fBueZlRmJd250fAz4GuFx4bgyaqPnqzhDJmr/O7C
	hSa9OKH5H8/P+HBJ+oDAUW6r9+eadxQb8v83+OV60of78Kf75X1nG1RWGkxMXscd+2KFuLJx
	nttDy7VSq8OOK84U33Okjf362pssTMcbWKsnXVpwPrpYccWdyiSfLytZc7QS+SWVWIozEg21
	mIuKEwECH8ctQAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the Exynos IOMMU on ARMv8-A architecture so the build won't fail.
The Exynos7 is not supported yet by Exynos IOMMU driver.

This fixes following build errors on ARMv8 (allmodconfig, allyesconfig):

drivers/iommu/exynos-iommu.c: In function ‘pgtable_flush’:
drivers/iommu/exynos-iommu.c:694:2: error: implicit declaration of function ‘dmac_flush_range’ [-Werror=implicit-function-declaration]
  dmac_flush_range(vastart, vaend);
  ^
drivers/iommu/exynos-iommu.c:695:2: error: implicit declaration of function ‘outer_flush_range’ [-Werror=implicit-function-declaration]
  outer_flush_range(virt_to_phys(vastart),
  ^
In file included from include/uapi/linux/stddef.h:1:0,
                 from include/linux/stddef.h:4,
                 from ./include/uapi/linux/posix_types.h:4,
                 from include/uapi/linux/types.h:13,
                 from include/linux/types.h:5,
                 from include/linux/io.h:21,
                 from drivers/iommu/exynos-iommu.c:15:
drivers/iommu/exynos-iommu.c: In function ‘alloc_lv2entry’:
drivers/iommu/exynos-iommu.c:853:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   BUG_ON((unsigned int)pent & (LV2TABLE_SIZE - 1));
          ^
include/linux/compiler.h:160:42: note: in definition of macro ‘unlikely’
 # define unlikely(x) __builtin_expect(!!(x), 0)
                                          ^
drivers/iommu/exynos-iommu.c:853:3: note: in expansion of macro ‘BUG_ON’
   BUG_ON((unsigned int)pent & (LV2TABLE_SIZE - 1));
   ^
cc1: some warnings being treated as errors
make[2]: *** [drivers/iommu/exynos-iommu.o] Error 1
make[1]: *** [drivers/iommu] Error 2
make[1]: *** Waiting for unfinished jobs....

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 30f0e61341c5..dbdcb5be8583 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -187,7 +187,7 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS
+	depends on ARCH_EXYNOS && !ARCH_EXYNOS7
 	select IOMMU_API
 	select ARM_DMA_USE_IOMMU
 	help
-- 
1.9.1

