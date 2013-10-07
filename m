Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3JGBzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:55:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13266 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3JGBzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:55:05 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-f9-525214783c5d
Date: Mon, 07 Oct 2013 10:55:04 +0900
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
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 08/20] iommu/exynos: remove dbgname from drvdata of a
 System MMU
Message-id: <20131007105504.9c27caf2fb0885d1dae8312d@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zY90KkaAgg/tHNSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbHkXCtbwWaFii0buBoY90p1MXJySAiYSKxc
	tIcNwhaTuHBvPZDNxSEksIxR4s39qywwRXs2PGSFSExnlGjbe5gRwpnEJLG0Zy1YO4uAqsTn
	FXvZQWw2AS2J1XOPgxWJCLQxSXxtPMQC4jALnGaWWLV7BXMXIweHsECYxKyeQpAGXgFHifan
	kxkh1llIXGjqYIeIC0r8mHwP7AxmoKGbtzWxQtjyEpvXvGUGmSkhMJFD4t+FV6wQVwhIfJsM
	sowDKCErsekAM8RMSYmDK26wTGAUmYVk7CwkY2chGbuAkXkVo2hqQXJBcVJ6kYlecWJucWle
	ul5yfu4mRkgcT9jBeO+A9SHGZKCVE5mlRJPzgWkgryTe0NjMyMLUxNTYyNzSjDRhJXFe9Rbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MFnGPHVNmPk//PvvoW7tT12Kmn/+St/zJKQYD
	oZ88QlYfEkWaGETO5q3p/7Z3ekPFKq74vugPtzbnnI7hzDv/yZ+F16l2m69dSsehBbkqs511
	Rb3CSvOyC+3azVldy8MnLb355+O+KWI5B1Uny1oWGOzuSFg+se5Fw8PDf1nbPgk2p6SrP/6r
	xFKckWioxVxUnAgAicnN6fkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQd0KkaAggyu7lSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFjyblW
	toLNChVbNnA1MO6V6mLk5JAQMJHYs+EhK4QtJnHh3nq2LkYuDiGB6YwSbXsPM0I4k5gklvas
	ZQOpYhFQlfi8Yi87iM0moCWxeu5xsCIRgTYmia+Nh1hAHGaB08wSq3avYO5i5OAQFgiTmNVT
	CNLAK+Ao0f50MiPEOguJC00d7BBxQYkfk++xgNjMQEM3b2tihbDlJTavecs8gZFvFpKyWUjK
	ZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOEk8k97BuKrB4hCjAAejEg/vjvuB
	QUKsiWXFlbmHGCU4mJVEeC/VAYV4UxIrq1KL8uOLSnNSiw8xJgO9PZFZSjQ5H5jA8kriDY1N
	zIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBccaa6aHtvoGGzdIPbsmp
	9mkejOwLbLHhuDt7Qd73reaXF9+ujDqp+iem/8Oek3nhcxr3xyxfdDxQ58BbH8Glu3Z3PZpV
	fzprsvf5Fzmlx3+KvRE+9HaDiFiOZEOixsGFwtOFC569ZpOwvmL5wyp10u6X2zT8fojkrDZs
	LWNYs6KxJfqm7R1HDiWW4oxEQy3mouJEAKdghC9WAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dbgname member from sysmmu_drvdata structure.
Kernel message for debugging already has the name of a single
System MMU node.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   34 +++++++++++++---------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0092359..735d75e 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -170,7 +170,6 @@ struct sysmmu_drvdata {
 	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *dev;	/* Owner of system MMU */
-	char *dbgname;
 	void __iomem *sfrbase;
 	struct clk *clk;
 	int activations;
@@ -328,8 +327,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
 		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
 	else
-		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
-				data->dbgname, sysmmu_fault_name[itype]);
+		dev_dbg(data->sysmmu, "%s is not handled.\n",
+				sysmmu_fault_name[itype]);
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbase);
@@ -362,10 +361,10 @@ finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
-		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled\n");
 	else
-		dev_dbg(data->sysmmu, "(%s) %d times left to be disabled\n",
-					data->dbgname, data->activations);
+		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
+					data->activations);
 
 	return disabled;
 }
@@ -392,7 +391,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 			ret = 1;
 		}
 
-		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Already enabled\n");
 		goto finish;
 	}
 
@@ -414,7 +413,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	data->domain = domain;
 
-	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
+	dev_dbg(data->sysmmu, "Enabled\n");
 finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
@@ -430,16 +429,15 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 
 	ret = pm_runtime_get_sync(data->sysmmu);
 	if (ret < 0) {
-		dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Failed to enable\n");
 		return ret;
 	}
 
 	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
 	if (WARN_ON(ret < 0)) {
 		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu,
-			"(%s) Already enabled with page table %#lx\n",
-			data->dbgname, data->pgtable);
+		dev_err(data->sysmmu, "Already enabled with page table %#lx\n",
+			data->pgtable);
 	} else {
 		data->dev = dev;
 	}
@@ -485,9 +483,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -506,9 +502,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -563,8 +557,6 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 			data->clk = NULL;
 			dev_dbg(dev, "No clock descriptor registered\n");
 		}
-
-		data->dbgname = platdata->dbgname;
 	}
 
 	data->sysmmu = dev;
@@ -577,7 +569,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
+	dev_dbg(dev, "Initialized\n");
 	return 0;
 err_irq:
 	free_irq(platform_get_irq(pdev, 0), data);
-- 
1.7.2.5

