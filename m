Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaHEKtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:49:20 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44638 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaHEKtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:15 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f2-53e0b6a9c642
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
Subject: [PATCH 28/29] iommu: exynos: remove excessive includes and sort others
 alphabetically
Date: Tue, 05 Aug 2014 12:47:56 +0200
Message-id: <1407235677-26324-29-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7ortz0INmjZyW/xd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgyjg/eylLwWfOipsTFjI1MF7g6GLk5JAQMJHY
	/WEOC4QtJnHh3no2EFtIYCmjxLkjCl2MXEB2H5PEg2+9jCAJNgFDia63XWwgCRGBXkaJ/qYf
	TCAOs8A6Von9vdfBRgkLJEi0dt4Cs1kEVCU69pxlBbF5BTwlFvfPYIVYJyfx/+UKJhCbEyh+
	+OYBVojVHhI/N6xhn8DIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSOR82cG4+JjV
	IUYBDkYlHl6D03eDhVgTy4orcw8xSnAwK4nwSqx5ECzEm5JYWZValB9fVJqTWnyIkYmDU6qB
	MYz5eFC7wKOwV0snpSW//+xi3FbCJPhE1a63IOOp+f22zdFp25gvHEoo/taiuX6DlOaxqzMD
	n4TLJfBbL2qx9dS9E+NSH/b95Xp2pQWTmGzLbwS7/Gn5dr4wcc3ks/OCE2pXb2q1vXd/ne7U
	dUdX1rw9xXvmpLzHhwvvey5eaE+aarA9dPniiUosxRmJhlrMRcWJAB8BScx6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed following unused includes: <linux/mm.h>, <linux/errno.h>,
<linux/memblock.h> and <linux/export.h>.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 78ce618..1bbb100 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -12,23 +12,19 @@
 #define DEBUG
 #endif
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/io.h>
+#include <linux/iommu.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/pm_runtime.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/mm.h>
+#include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
-#include <linux/iommu.h>
-#include <linux/errno.h>
-#include <linux/list.h>
-#include <linux/memblock.h>
-#include <linux/export.h>
+#include <linux/platform_device.h>
 #include <linux/pm_domain.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include <asm/cacheflush.h>
 #include <asm/dma-iommu.h>
-- 
1.9.2

