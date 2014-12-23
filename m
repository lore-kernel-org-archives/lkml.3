Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaLWHkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:40:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37973 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaLWHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:40:28 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-d5-54991c6a960d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, inki.dae@samsung.com,
        cw00.choi@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/3] clk: samsung: Changes the return value of
 samsung_cmu_register_one()
Date: Tue, 23 Dec 2014 16:40:21 +0900
Message-id: <1419320423-19228-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
References: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkWDdLZmaIweMObYvrX56zWky6P4HF
	onfBVTaLs01v2C0u75rDZjHj/D4mi6cTLrJZHH7TzmqxatcfRgdOj52z7rJ73Lm2h82jb8sq
	Ro/Pm+QCWKK4bFJSczLLUov07RK4MrZO72UsuCBUce3QFLYGxhP8XYycHBICJhJP1/9khLDF
	JC7cW8/WxcjFISSwlFFi+uE7zDBFz3pnMUMkFjFKHJnXwAKSEBJoYpJ4/kQVxGYT0JLY/+IG
	UDcHh4iAocTNQ0og9cwC5xgl1i7rZwOpERaIlnh6fQXYUBYBVYn1c48xgdi8Aq4Sbc9eM0Es
	U5BYtnwmK4jNKeAm8XPmR6hdrhI7P89lBxkqIbCMXeJB705GiEECEt8mH2IBWSwhICux6QDU
	0ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmDAn/73bMIOxnsHrA8x
	CnAwKvHwLjwzI0SINbGsuDL3EKMp0IaJzFKiyfnAuMoriTc0NjOyMDUxNTYytzRTEud9LfUz
	WEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjHs/b85OPOFzXSrksZLdYMUHZKS+jKtZqS2bo
	wgzrZw9y47JeCsu9nnW4ZL3MTX+ZFU+mTq0MaroTeWrR1vhlXv13eGLC3VVERUr5NhqkfvPf
	fu15mqXiN47Dj35pnExbxh+hs0Xls836lyUbj01oW22ySCX+Y8TBaQLF+897z+2/XaHW/zlQ
	iaU4I9FQi7moOBEAOBJsE3MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAd0smZkhBnu3KVtc//Kc1WLS/Qks
	Fr0LrrJZnG16w25xedccNosZ5/cxWTydcJHN4vCbdlaLVbv+MDpweuycdZfd4861PWwefVtW
	MXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj6/RexoILQhXX
	Dk1ha2A8wd/FyMkhIWAi8ax3FjOELSZx4d56ti5GLg4hgUWMEkfmNbCAJIQEmpgknj9RBbHZ
	BLQk9r+4AVTEwSEiYChx85ASSD2zwDlGibXL+tlAaoQFoiWeXl8BNpRFQFVi/dxjTCA2r4Cr
	RNuz10wQyxQkli2fyQpicwq4Sfyc+RFql6vEzs9z2Scw8i5gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERxPz6R2MK5ssDjEKMDBqMTDu+DMjBAh1sSy4srcQ4wSHMxKIrwvxWeGCPGm
	JFZWpRblxxeV5qQWH2I0BbpqIrOUaHI+MNbzSuINjU3MjCyNzA0tjIzNlcR5lezbQoQE0hNL
	UrNTUwtSi2D6mDg4pRoY+Zbfd/FX359xSd7ScVlWFG+AAGPoSpc76lyqzawi2zkMyzx+5nw1
	8X5rrmISev+Rm45/29r6v1xRbLkle78tjH4v4HxpyovWWH2XzwLXl074t2lV/UQdybw9k46+
	MH/aVy3jEawg73eac9cndaXnJjLRT7XXX1LkeLRoc31ykLmErWGigpESS3FGoqEWc1FxIgCC
	r534vQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the return value of samsung_cmu_register_one()
from 'void type' to 'samsung_clk_provider structure' pointer type because
samsung_clk_provider may be used in each clock driver.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/clk/samsung/clk.c | 13 ++++++++++---
 drivers/clk/samsung/clk.h |  3 ++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 4bda540..980c5da 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -374,19 +374,24 @@ static void samsung_clk_sleep_init(void __iomem *reg_base,
  * Common function which registers plls, muxes, dividers and gates
  * for each CMU. It also add CMU register list to register cache.
  */
-void __init samsung_cmu_register_one(struct device_node *np,
+struct samsung_clk_provider* __init samsung_cmu_register_one(
+			struct device_node *np,
 			struct samsung_cmu_info *cmu)
 {
 	void __iomem *reg_base;
 	struct samsung_clk_provider *ctx;
 
 	reg_base = of_iomap(np, 0);
-	if (!reg_base)
+	if (!reg_base) {
 		panic("%s: failed to map registers\n", __func__);
+		return NULL;
+	}
 
 	ctx = samsung_clk_init(np, reg_base, cmu->nr_clk_ids);
-	if (!ctx)
+	if (!ctx) {
 		panic("%s: unable to alllocate ctx\n", __func__);
+		return ctx;
+	}
 
 	if (cmu->pll_clks)
 		samsung_clk_register_pll(ctx, cmu->pll_clks, cmu->nr_pll_clks,
@@ -410,4 +415,6 @@ void __init samsung_cmu_register_one(struct device_node *np,
 			cmu->nr_clk_regs);
 
 	samsung_clk_of_add_provider(np, ctx);
+
+	return ctx;
 }
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index 8acabe1..e4c7538 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -392,7 +392,8 @@ extern void __init samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 			struct samsung_pll_clock *pll_list,
 			unsigned int nr_clk, void __iomem *base);
 
-extern void __init samsung_cmu_register_one(struct device_node *,
+extern struct samsung_clk_provider __init *samsung_cmu_register_one(
+			struct device_node *,
 			struct samsung_cmu_info *);
 
 extern unsigned long _get_rate(const char *clk_name);
-- 
1.8.5.5

