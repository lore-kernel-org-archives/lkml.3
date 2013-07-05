Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab3GEM3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36100 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883Ab3GEM31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:27 -0400
X-AuditID: cbfee68e-b7f276d000002279-a1-51d6bc267ac9
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
Date: Fri, 05 Jul 2013 21:29:26 +0900
Message-id: <002d01ce797b$49c441a0$dd4cc4e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d7SaVQM9RTz9RVCjnECx0AGuYg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zQ121PdcCDbZu17F4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZdz+
	+oq5YIdqRderN0wNjMvluxg5OSQETCQ+Nh5hhbDFJC7cW8/WxcjFISSwjFGi7f5HFpiiS/M6
	2CES0xkllrTeYYVw/jJKHHg4jR2kik1AS2L13OOMILaIwF1GiZfneUCKmAVuMEls+NQGNkpY
	wF5i0bldTCA2i4CqxMWPLWBxXgFLiS3nOtggbEGJH5PvgcWZgYau33mcCcKWl9i85i0zxEkK
	EjvOvoZapicxYeIhqBoRiX0v3jGCLJYQ+Msu8W/pTWaIZQIS3yYfAhrKAZSQldh0AGqOpMTB
	FTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCFR3beD
	8eYB60OMyUDrJzJLiSbnA5NCXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYGRczRczwarwd80RGdOvOR6VP9r6tzC9/U5o6LX+C5pkv8kzTjgp0
	snmzxd3Zr7tHPnX+y78adStVZqY6XnIr1l/1y8G8stxjWp5q7plz76NzFwgxyGbrT/ObLSKy
	vpopw/LImoVNF3L6ZnDvklmiIMN0+PaqlTe5ltXELAr4ZsWW/XyZSm2kEktxRqKhFnNRcSIA
	E9MOCgADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV21PdcCDeZ/Ubd4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8y4/fUVc8EO1YquV2+YGhiXy3cxcnJICJhIXJrXwQ5hi0lc
	uLeerYuRi0NIYDqjxJLWO6wQzl9GiQMPp4FVsQloSayee5wRxBYRuMso8fI8D0gRs8ANJokN
	n9pYQBLCAvYSi87tYgKxWQRUJS5+bAGL8wpYSmw518EGYQtK/Jh8DyzODDR0/c7jTBC2vMTm
	NW+ZIU5SkNhx9jXUMj2JCRMPQdWISOx78Y5xAqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECE4Zz6R3MK5qsDjEKMDBqMTD+6D+aqAQa2JZcWXuIUYJDmYl
	EV77hGuBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTGd5JfGGxiZmRpZGZhZGJubmpAkr
	ifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAoI6VoM/lDo2WgXKD7LiGnnHlXeAqn/M94+O7U
	Jatnvx7L6nh8t3mjqHhRew/nR82us84s6i/ZLPUma2umrmNqzvmnKONvp5E3TbhYYoLgfMeD
	TG/3BezgtEjpt558QF5BW8w6oWmx7h0+IX32ohRWtg063x8u7SztrP5rETLP+HxA6os9y5VY
	ijMSDbWYi4oTARCRpmJdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 390f8b7..6793661 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -175,7 +175,7 @@ struct sysmmu_drvdata {
 	void __iomem **sfrbases;
 	struct clk *clk[2];
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
@@ -259,7 +259,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	BUG_ON((base0 + size0) <= base0);
 	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (!is_sysmmu_active(data))
 		goto finish;
 
@@ -289,7 +289,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 		}
 	}
 finish:
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void __set_fault_handler(struct sysmmu_drvdata *data,
@@ -297,9 +297,9 @@ static void __set_fault_handler(struct sysmmu_drvdata *data,
 {
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	data->fault_handler = handler;
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_set_fault_handler(struct device *dev,
@@ -347,7 +347,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	int i, ret = -ENOSYS;
 
-	read_lock(&data->lock);
+	spin_lock(&data->lock);
 
 	WARN_ON(!is_sysmmu_active(data));
 
@@ -391,7 +391,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbases[i]);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -402,7 +402,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled = false;
 	int i;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_inactive(data))
 		goto finish;
@@ -419,7 +419,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	data->pgtable = 0;
 	data->domain = NULL;
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
 		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
@@ -442,7 +442,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	int i, ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_active(data)) {
 		if (WARN_ON(pgtable != data->pgtable)) {
@@ -481,7 +481,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -528,7 +528,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		int i;
@@ -545,7 +545,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 			data->dbgname);
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
@@ -553,7 +553,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		int i;
@@ -569,7 +569,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 			data->dbgname);
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int exynos_sysmmu_probe(struct platform_device *pdev)
@@ -666,7 +666,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	}
 
 	data->sysmmu = dev;
-	rwlock_init(&data->lock);
+	spin_lock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
 	__set_fault_handler(data, &default_fault_handler);
-- 
1.7.2.5


