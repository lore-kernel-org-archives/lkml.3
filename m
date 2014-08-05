Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaHEKw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:52:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18343 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbaHEKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:06 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a6-53e0b6a08bd6
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
Subject: [PATCH 18/29] iommu: exynos: remove unused functions
Date: Tue, 05 Aug 2014 12:47:46 +0200
Message-id: <1407235677-26324-19-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xq7oLtj0INjj7S9Pi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlTH54FWmgil8FQ8mOTYw/uHuYuTgkBAwkTjz
	26mLkRPIFJO4cG89WxcjF4eQwFJGiTs/T7CBJIQE+pgkPr62ALHZBAwlut52gRWJCPQySvQ3
	/WACcZgF1rFK7O+9zgJSJSxgKzGv6zQTiM0ioCrxtW8WmM0r4Cmx6+kyNoh1chL/X64Ai3MC
	xQ/fPMAKsc1D4ueGNewTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJmq87GJce
	szrEKMDBqMTDq7D3brAQa2JZcWXuIUYJDmYlEV6JNQ+ChXhTEiurUovy44tKc1KLDzEycXBK
	NTAWOyWYLHtoGqB6Y/fmC9FX16zfl7QgrMPofVS5eNGsaVnFL90OWyv8nOzB2svYueTBmefX
	xeVET1d0uDQ26+icOXHgjmzbNGcds6CVs5/fcTCePu2CvbGGLe/OK/+uH47QSt/y8D9fyN/b
	vm84l6hKxNkvWDbnQ8Pnb8zGMfXBrNdUP6g4cx9VYinOSDTUYi4qTgQA2DnQ63gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two unneeded functions, which are not a part of
generic IOMMU API and were never used by any other driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 8927923..ec3c882 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -491,13 +491,6 @@ static int __exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable,
 	return ret;
 }
 
-int exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable)
-{
-	BUG_ON(!memblock_is_memory(pgtable));
-
-	return __exynos_sysmmu_enable(dev, pgtable, NULL);
-}
-
 static bool exynos_sysmmu_disable(struct device *dev)
 {
 	unsigned long flags;
@@ -589,30 +582,6 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-void exynos_sysmmu_tlb_invalidate(struct device *dev)
-{
-	struct exynos_iommu_owner *owner = dev->archdata.iommu;
-	unsigned long flags;
-	struct sysmmu_drvdata *data;
-
-	data = dev_get_drvdata(owner->sysmmu);
-
-	spin_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
-		if (!IS_ERR(data->clk_master))
-			clk_enable(data->clk_master);
-		if (sysmmu_block(data->sfrbase)) {
-			__sysmmu_tlb_invalidate(data->sfrbase);
-			sysmmu_unblock(data->sfrbase);
-		}
-		if (!IS_ERR(data->clk_master))
-			clk_disable(data->clk_master);
-	} else {
-		dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
-	}
-	spin_unlock_irqrestore(&data->lock, flags);
-}
-
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
-- 
1.9.2

