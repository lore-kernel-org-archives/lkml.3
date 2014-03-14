Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaCNFJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:09:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11364 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaCNFJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:09:53 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-77-53228f1f5eb2
Date: Fri, 14 Mar 2014 14:09:51 +0900
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 15/27] iommu/exynos: use convenient macro to handle gate
 clocks
Message-id: <20140314140951.3d443a3096e80297c9fecef0@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zA135fqVggx9XrCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpYs3YTc8F92Yqvt+6wNTB+k+hi5OSQEDCRmP/4MDOE
	LSZx4d56NhBbSGAZo8SSl2IwNdOuzGLqYuQCii9ilDiy/yaUM5lJov/uQrAOFgFViaXProLZ
	bAJaEqvnHmcEKRIRaGOS+Np4iAXEYRaYyyzx8dscsCphgVCJa/PWs4DYvAKOEtt2PmeE2Gch
	caGpgx0iLijxY/I9sBpmoKmbtzWxQtjyEpvXvGUGGSoh0Mkh8XLPOlaIMwQkvk0G2cYBlJCV
	2HQA6jdJiYMrbrBMYBSZhWTsLCRjZyEZu4CReRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZG
	SPz27mC8fcD6EGMy0MqJzFKiyfnA+M8riTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBsbdVRczP+3ub7pdtbO6Re53meWrN5su+r0OFZu69ojbseWX
	9lzqNyh48XL7RcdjmZMvvsrz4HPSEYh8yh0W1+WjlXSt9W7Fme0f6i7VnFFh7H6SbnsgPcvm
	jrXwjgfZhbfipj/Zf+n3/u6e0L1PIjYnXay0V1+Zn9B9vagnWLCI7WiYhOuE6WxKLMUZiYZa
	zEXFiQBltj4A9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAV35fqVgg51nTC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWbtJuaC+7IV
	X2/dYWtg/CbRxcjJISFgIjHtyiwmCFtM4sK99WxdjFwcQgKLGCWO7L/JBOFMZpLov7uQDaSK
	RUBVYumzq2A2m4CWxOq5xxlBikQE2pgkvjYeYgFxmAXmMkt8/DYHrEpYIFTi2rz1LCA2r4Cj
	xLadzxkh9llIXGjqYIeIC0r8mHwPrIYZaOrmbU2sELa8xOY1b5knMPLNQlI2C0nZLCRlCxiZ
	VzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp4dn0jsYVzVYHGIU4GBU4uGdcVQxWIg1say4
	MvcQowQHs5IIb1WEUrAQb0piZVVqUX58UWlOavEhxmSgvycyS4km5wNTV15JvKGxiZmRpZGZ
	hZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MDIIH4n4xy7Mv9YsKF2md+P2qLUX
	jUR0v61abMmndEPtrEv7yrMTbC0614sulKucorltp9g3ts6Nbvtia9Xl/7+cUX5AfAHjBPYJ
	5btNmBy4p324tEvFifFPZsa+W/E/blp94I7f9WdnodU2Td95SaXmkkzVQayxGRbqGXGBJSwi
	H3OfxH+/qcRSnJFoqMVcVJwIANAYaSBTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos-iommu driver must care about master H/W's gate clock as well as
System MMU's gate clock. To enhance readability of the source code,
macros to gate/ungate those clocks are defined.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 71e77f1..cef62d0 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -101,6 +101,16 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+#define __clk_gate_ctrl(data, clk, en)	do {		\
+		if (data->clk)				\
+			clk_##en##able(data->clk);	\
+	} while (0)
+
+#define __sysmmu_clk_enable(data)	__clk_gate_ctrl(data, clk, en)
+#define __sysmmu_clk_disable(data)	__clk_gate_ctrl(data, clk, dis)
+#define __master_clk_enable(data)	__clk_gate_ctrl(data, clk_master, en)
+#define __master_clk_disable(data)	__clk_gate_ctrl(data, clk_master, dis)
+
 static struct kmem_cache *lv2table_kmem_cache;
 
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
@@ -302,7 +312,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	WARN_ON(!is_sysmmu_active(data));
 
-	clk_enable(data->clk_master);
+	__master_clk_enable(data);
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -329,7 +339,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbase);
 
-	clk_disable(data->clk_master);
+	__master_clk_disable(data);
 
 	read_unlock(&data->lock);
 
@@ -346,12 +356,12 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	if (!set_sysmmu_inactive(data))
 		goto finish;
 
-	clk_enable(data->clk_master);
+	__master_clk_enable(data);
 
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
-	clk_disable(data->clk);
-	clk_disable(data->clk_master);
+	__sysmmu_clk_disable(data);
+	__master_clk_disable(data);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -396,14 +406,14 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	data->pgtable = pgtable;
 
-	clk_enable(data->clk_master);
-	clk_enable(data->clk);
+	__master_clk_enable(data);
+	__sysmmu_clk_enable(data);
 
 	__sysmmu_set_ptbase(data->sfrbase, pgtable);
 
 	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
 
-	clk_disable(data->clk_master);
+	__master_clk_disable(data);
 
 	data->domain = domain;
 
@@ -462,7 +472,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		unsigned int maj;
 		unsigned int num_inv = 1;
 
-		clk_enable(data->clk_master);
+		__master_clk_enable(data);
 
 		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
 		/*
@@ -483,7 +493,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 							num_inv);
 			sysmmu_unblock(data->sfrbase);
 		}
-		clk_disable(data->clk_master);
+		__master_clk_disable(data);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -499,12 +509,12 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
-		clk_enable(data->clk_master);
+		__master_clk_enable(data);
 		if (sysmmu_block(data->sfrbase)) {
 			__sysmmu_tlb_invalidate(data->sfrbase);
 			sysmmu_unblock(data->sfrbase);
 		}
-		clk_disable(data->clk_master);
+		__master_clk_disable(data);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
-- 
1.7.9.5

