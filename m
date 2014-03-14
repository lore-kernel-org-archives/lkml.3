Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaCNFDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:03:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9801 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaCNFC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:02:56 -0400
X-AuditID: cbfee68f-b7f156d00000276c-40-53228d7f6223
Date: Fri, 14 Mar 2014 14:02:54 +0900
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
Subject: [PATCH v11 04/27] iommu/exynos: fix L2TLB invalidation
Message-id: <20140314140254.32dbc0cd8cde8f4ffcf71c9f@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY936XqVgg56NfBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGVsWDKZqeCHRMW8x1fYGxh/CHcxcnJICJhIHDk6mQ3C
	FpO4cG89kM3FISSwjFFi7c1PTDBF3193sEMkFjFKvF3dyAjhTGaS+LblHyNIFYuAqsSkFc/Y
	QWw2AS2J1XOPgxWJCLQxSXxtPMQC4jALzGWWeLb2KStIlbCAvcTtvl1g3bwCjhKT+35C7bOQ
	uNDUwQ4RF5T4MfkeC4jNDDR187YmVghbXmLzmrfMEPW9HBJ7ZnJDXCEg8W0yyDIOoLisxKYD
	UCWSEgdX3GCZwCgyC8nUWUimzkIydQEj8ypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkPjt
	38F494D1IcZkoJUTmaVEk/OB8Z9XEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhj35rb47nG+9Ha34ceG6qvvNBrk70ukq+SnHz4vIVTKbb3mgtSx
	rRbLGzVcd7Ek6iZ+tehYYPP3Qvfm2lXTop9F3FnfITzFce73b0+Kfz/1vWjHl3Dy+D3Z3evl
	hB+fWf1OyGxh/qr4uOVPpSar6ZrZfsrROcIhaLcryUDw7A0ncb9Hn3gKVa4osRRnJBpqMRcV
	JwIAtsJ9g/UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd36XqVgg9cdHBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2LBkMlPBD4mK
	eY+vsDcw/hDuYuTkkBAwkfj+uoMdwhaTuHBvPVsXIxeHkMAiRom3qxsZIZzJTBLftvxjBKli
	EVCVmLTiGVgHm4CWxOq5x8GKRATamCS+Nh5iAXGYBeYySzxb+5QVpEpYwF7idt8usG5eAUeJ
	yX0/mSD2WUhcaILYzSsgKPFj8j0WEJsZaOrmbU2sELa8xOY1b5knMPLNQlI2C0nZLCRlCxiZ
	VzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp4dn0jsYVzVYHGIU4GBU4uGdcVQxWIg1say4
	MvcQowQHs5IIb1WEUrAQb0piZVVqUX58UWlOavEhxmSgvycyS4km5wNTV15JvKGxiZmRpZGZ
	hZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MK7YH3NaaM/dS/v5/2n+Xt7xX//D
	LBGPS3LRQotOSn66/+/2DD3x/pjgrPB+6QKBJ9ucUuqOXj/fU2b+lz1P+mxNN9/3b//e/Lo7
	90CPf2WNAZ9xZFXXTP5Vq9xt1iy9rf//mm7Ap3+K/Lphc3SWvFo5/bSaefZ5v8dxnyOCFiTp
	RVk5G+k631ZiKc5INNRiLipOBADeCRjsUwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L2TLB is 8-way set-associative TLB with 512 entries. The number of
sets is 64.
A single 4KB(small page) translation information is cached
only to a set whose index is the same with the lower 6 bits of the page
frame number.
A single 64KB(large page) translation information can be
cached to any 16 sets whose top two bits of their indices are the same
with the bit [5:4] of the page frame number.
A single 1MB(section) or larger translation information can be cached to
any set in the TLB.

It is required to invalidate entire sets that may cache the target
translation information to guarantee that the L2TLB has no stale data.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4a74ed8..0d26aeb 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -225,9 +225,14 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
 }
 
 static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
-						unsigned long iova)
+				unsigned long iova, unsigned int num_inv)
 {
-	__raw_writel((iova & SPAGE_MASK) | 1, sfrbase + REG_MMU_FLUSH_ENTRY);
+	unsigned int i;
+	for (i = 0; i < num_inv; i++) {
+		__raw_writel((iova & SPAGE_MASK) | 1,
+				sfrbase + REG_MMU_FLUSH_ENTRY);
+		iova += SPAGE_SIZE;
+	}
 }
 
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
@@ -477,7 +482,8 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
+static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
+					size_t size)
 {
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
@@ -487,9 +493,24 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	if (is_sysmmu_active(data)) {
 		int i;
 		for (i = 0; i < data->nsfrs; i++) {
+			unsigned int maj;
+			unsigned int num_inv = 1;
+			maj = __raw_readl(data->sfrbases[i] + REG_MMU_VERSION);
+			/*
+			 * L2TLB invalidation required
+			 * 4KB page: 1 invalidation
+			 * 64KB page: 16 invalidation
+			 * 1MB page: 64 invalidation
+			 * because it is set-associative TLB
+			 * with 8-way and 64 sets.
+			 * 1MB page can be cached in one of all sets.
+			 * 64KB page can be one of 16 consecutive sets.
+			 */
+			if ((maj >> 28) == 2) /* major version number */
+				num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
 			if (sysmmu_block(data->sfrbases[i])) {
 				__sysmmu_tlb_invalidate_entry(
-						data->sfrbases[i], iova);
+					data->sfrbases[i], iova, num_inv);
 				sysmmu_unblock(data->sfrbases[i]);
 			}
 		}
@@ -999,7 +1020,7 @@ done:
 
 	spin_lock_irqsave(&priv->lock, flags);
 	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
-- 
1.7.9.5

