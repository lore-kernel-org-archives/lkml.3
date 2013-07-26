Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3GZLar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:30:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26770 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3GZLao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:30:44 -0400
X-AuditID: cbfee68f-b7f436d000000f81-52-51f25de36d9b
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
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v8 11/12] iommu/exynos: change rwlock to spinlock
Date: Fri, 26 Jul 2013 20:30:42 +0900
Message-id: <004101ce89f3$90200980$b0601c80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8c9j+DoxFsw0QBKxKjfGTa9SJQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zge7j2E+BBttOclncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujBUvtjAXXNSsmHL4KFsD4xGlLkZODgkBE4kF3x8z
	QdhiEhfurWfrYuTiEBJYxijxbdlzVpiia39mM0IkFjFKtE6ZB+X8ZZTY3vCYHaSKTUBLYvXc
	44wgtojAXUaJl+d5QIqYBW4zS0z7+QosISzgKHF0xjGwsSwCqhJnVqwGa+YVsJRYtvAYC4Qt
	KPFj8j0wmxlo6Pqdx5kgbHmJzWveMkOcpCCx4+xrqGV6Eo3rNzJD1IhI7HvxDuw6CYGlHBKP
	Zk5jg1gmIPFt8iGgoRxACVmJTQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQ
	XFCclF5krFecmFtcmpeul5yfu4kRkgb6dzDePWB9iDEZaP1EZinR5HxgGskriTc0NjOyMDUx
	NTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PLI42/W6Yo/Dgp0Tgj
	tuzLyi9xNTM2+e+5bDl9s273+6ZL+at2boq4ddz9/CobK7lHl5ozO9pbHr5gl3fbl9IsH9R5
	8fy+jxE2TPLMNz3O7Lq3qvKg54SVlVzLYlhUG7QfqgQqTvgiUb3SZ03Ro1bfpY8d1fhnptvO
	3q3J1LZFwULYqGtvVa0SS3FGoqEWc1FxIgAuvXflGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd3HsZ8CDeZtZbG4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNWvNjCXHBR
	s2LK4aNsDYxHlLoYOTkkBEwkrv2ZzQhhi0lcuLeerYuRi0NIYBGjROuUeYwQzl9Gie0Nj9lB
	qtgEtCRWzz0O1iEicJdR4uV5HpAiZoHbzBLTfr4CSwgLOEocnXGMFcRmEVCVOLNiNVgzr4Cl
	xLKFx1ggbEGJH5PvgdnMQEPX7zzOBGHLS2xe85YZ4iQFiR1nX0Mt05NoXL+RGaJGRGLfi3eM
	ExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCSeSa9g3FV
	g8UhRgEORiUeXgWnj4FCrIllxZW5hxglOJiVRHive38KFOJNSaysSi3Kjy8qzUktPsSYDPTp
	RGYp0eR8YALMK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG
	9Y8teQ03rNCy9NpoUbVkU8C1efO40nWyPKTFPdw3vDD94cZ9973uZ0f237N2iqmtWDX9dPXC
	jH9mCdG+K54IbdLa65wUFHmFOf7b9sYZTj2HXRVf/N2+sm3Dm7ntVu2ZfAf7Hv70eTn3gtM6
	16rPvZKbJ3MF5rGG1piYd4q7iCv+KZ/CdlpKiaU4I9FQi7moOBEAd5z5t3YDAAA=
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
 drivers/iommu/exynos-iommu.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c62c244..51e5b35 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -187,7 +187,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	bool runtime_active;
 	unsigned long pgtable;
@@ -287,7 +287,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	BUG_ON((base0 + size0) <= base0);
 	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (!is_sysmmu_active(data))
 		goto finish;
 
@@ -319,7 +319,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	}
 	clk_disable(data->clk_master);
 finish:
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void show_fault_information(const char *name,
@@ -371,7 +371,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	if (client)
 		spin_lock(&client->lock);
-	read_lock(&data->lock);
+	spin_lock(&data->lock);
 
 	if (i == data->nsfrs) {
 		itype = SYSMMU_FAULT_UNKNOWN;
@@ -402,7 +402,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbases[i]);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 	if (client)
 		spin_unlock(&client->lock);
 
@@ -429,7 +429,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	disabled = set_sysmmu_inactive(data);
 
@@ -446,7 +446,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 					data->activations);
 	}
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
@@ -493,7 +493,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	int ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (set_sysmmu_active(data)) {
 		data->pgtable = pgtable;
 		data->domain = domain;
@@ -511,7 +511,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	if (WARN_ON(ret < 0))
 		set_sysmmu_inactive(data); /* decrement count */
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -602,7 +602,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 
 		data = dev_get_drvdata(client->sysmmu[i]);
 
-		read_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (is_sysmmu_active(data) && data->runtime_active) {
 			int i;
 			clk_enable(data->clk_master);
@@ -615,7 +615,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 				"disabled. Skipping TLB invalidation @ %#lx\n",
 				iova);
 		}
-		read_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 }
 
@@ -630,7 +630,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 		data = dev_get_drvdata(client->sysmmu[i]);
 
-		read_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (is_sysmmu_active(data) &&
 				data->runtime_active) {
 			int i;
@@ -646,7 +646,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		} else {
 			dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 		}
-		read_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 }
 
@@ -735,7 +735,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	data->runtime_active = !pm_runtime_enabled(dev);
 
-	rwlock_init(&data->lock);
+	spin_lock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
 	platform_set_drvdata(pdev, data);
@@ -749,11 +749,11 @@ static int sysmmu_suspend(struct device *dev)
 {
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
 	unsigned long flags;
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data) &&
 		(!pm_runtime_enabled(dev) || data->runtime_active))
 		__sysmmu_disable_nocount(data);
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
 
@@ -761,11 +761,11 @@ static int sysmmu_resume(struct device *dev)
 {
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
 	unsigned long flags;
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data) &&
 		(!pm_runtime_enabled(dev) || data->runtime_active))
 		__sysmmu_enable_nocount(data);
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
 #endif
-- 
1.7.2.5


