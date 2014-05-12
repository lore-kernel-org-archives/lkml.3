Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaELGRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:17:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35570 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaELGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:56 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-5b-537067564f53
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 12/19] iommu/exynos: change rwlock to spinlock
Date: Mon, 12 May 2014 11:44:57 +0530
Message-id: <1399875304-19948-13-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkVjc8vSDYYMZaLos7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6M/9+PMBbsV6xo/bqWqYGxT6aLkYNDQsBEYtOf+i5GTiBTTOLCvfVsILaQ
	wFJGicaTBhBxE4n/n3eydDFyAcUXMUrsWXcXqmgCk8S0/WYgNpuAocT2e1dYQYpEBFYzSvRd
	PMMO4jALzGaWOPJoMSNIlbCAk8SJ7u3sIDaLgKrEzolzwGxeAQ+J/6uWskNcpCAxZ5INSJgT
	KPx59RSoZe4Sx15dBVsgIbCWQ+L9vR4miDkCEt8mH2KB6JWV2HSAGeJqSYmDK26wTGAUXsDI
	sIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMFJP/3vWv4Px7gHrQ4zJQOMmMkuJJucDIz2v
	JN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDa5jw6
	H3DtX9yv4nUiRkuL+QX0vRta1PMUSxcERfMt4dyla13QbWElMu+Nn/YknqRdGZvSraye+E6S
	/emhEejo/nrXhqtuh/QqG9n5g1ndndMlfp7l5jNp5Frxce6qt7mMoWEfDrZWu7KYzTm0yS/i
	qdVRDnPbk2pVAuvr12ts15oiduhZtRJLcUaioRZzUXEiAJAYf0HqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd2w9IJggwlv1C3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZvz/foSxYL9iRevXtUwNjH0yXYyc
	HBICJhL/P+9kgbDFJC7cW8/WxcjFISSwiFFiz7q7bCAJIYEJTBLT9puB2GwChhLb711hBSkS
	EVjNKNF38Qw7iMMsMJtZ4sijxYwgVcICThInurezg9gsAqoSOyfOAbN5BTwk/q9aCmRzAK1T
	kJgzyQYkzAkU/rx6CtQyd4ljr66yTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj
	OBU8k97BuKrB4hCjAAejEg/vB4aCYCHWxLLiytxDjBIczEoivB/9gUK8KYmVValF+fFFpTmp
	xYcYk4GOmsgsJZqcD0xTeSXxhsYm5qbGppYmFiZmlqQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAmF/Fuo7n/iTRd71MRmWCNSGdog4iqjE5DnkxV254fUgxzbv5KG9mm4DTt7Il+Zph
	s3lOlm5rv1wwX+S+lETxkw1b6vwXZpwSW/rI4HTjqSYDY6WjO5Y9mb1m7WmvZSu+/Pb87HYt
	3EXrXUZ5D5tn6wbNwEiprmm3m1OLNV7PEH22buFKZpd0JZbijERDLeai4kQAk+JeLEkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c1be65f..d89ad5f 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -164,7 +164,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	phys_addr_t pgtable;
 };
@@ -263,12 +263,13 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	unsigned long addr = -1;
 	int ret = -ENOSYS;
 
-	read_lock(&data->lock);
-
 	WARN_ON(!is_sysmmu_active(data));
 
+	spin_lock(&data->lock);
+
 	if (!IS_ERR(data->clk_master))
 		clk_enable(data->clk_master);
+
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -302,7 +303,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (!IS_ERR(data->clk_master))
 		clk_disable(data->clk_master);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -312,7 +313,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	unsigned long flags;
 	bool disabled = false;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_inactive(data))
 		goto finish;
@@ -330,7 +331,7 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	data->pgtable = 0;
 	data->domain = NULL;
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
 		dev_dbg(data->sysmmu, "Disabled\n");
@@ -353,7 +354,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	int ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (!set_sysmmu_active(data)) {
 		if (WARN_ON(pgtable != data->pgtable)) {
@@ -384,7 +385,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	dev_dbg(data->sysmmu, "Enabled\n");
 finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -431,7 +432,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		unsigned int maj;
@@ -465,7 +466,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
@@ -473,7 +474,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
 		if (!IS_ERR(data->clk_master))
@@ -488,7 +489,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int exynos_sysmmu_probe(struct platform_device *pdev)
@@ -543,7 +544,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	}
 
 	data->sysmmu = dev;
-	rwlock_init(&data->lock);
+	spin_lock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
 	platform_set_drvdata(pdev, data);
-- 
1.7.9.5

