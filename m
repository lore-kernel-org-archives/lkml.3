Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaHZEho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:37:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22471 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbaHZEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:41 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/12] clk: mmp: move definiton of mmp_clk_frac to clk.h
Date: Tue, 26 Aug 2014 12:38:16 +0800
Message-ID: <1409027904-21859-5-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_02:2014-08-25,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408260059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Move the definition of structure of mmp_clk_frac to
clk.h.
So device tree support can use this structure.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/clk-frac.c |  8 --------
 drivers/clk/mmp/clk.h      | 32 ++++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 1876d2c..eeba52c 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -23,14 +23,6 @@
  */
 
 #define to_clk_factor(hw) container_of(hw, struct mmp_clk_factor, hw)
-struct mmp_clk_factor {
-	struct clk_hw		hw;
-	void __iomem		*base;
-	struct mmp_clk_factor_masks	*masks;
-	struct mmp_clk_factor_tbl	*ftbl;
-	unsigned int		ftbl_cnt;
-	spinlock_t *lock;
-};
 
 static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
 		unsigned long *prate)
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index b71b717..d267639 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -7,12 +7,14 @@
 #define APBC_NO_BUS_CTRL	BIT(0)
 #define APBC_POWER_CTRL		BIT(1)
 
+
+/* Clock type "factor" */
 struct mmp_clk_factor_masks {
-	unsigned int	factor;
-	unsigned int	num_mask;
-	unsigned int	den_mask;
-	unsigned int	num_shift;
-	unsigned int	den_shift;
+	unsigned int factor;
+	unsigned int num_mask;
+	unsigned int den_mask;
+	unsigned int num_shift;
+	unsigned int den_shift;
 };
 
 struct mmp_clk_factor_tbl {
@@ -20,6 +22,21 @@ struct mmp_clk_factor_tbl {
 	unsigned int den;
 };
 
+struct mmp_clk_factor {
+	struct clk_hw hw;
+	void __iomem *base;
+	struct mmp_clk_factor_masks *masks;
+	struct mmp_clk_factor_tbl *ftbl;
+	unsigned int ftbl_cnt;
+	spinlock_t *lock;
+};
+
+extern struct clk *mmp_clk_register_factor(const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *base, struct mmp_clk_factor_masks *masks,
+		struct mmp_clk_factor_tbl *ftbl, unsigned int ftbl_cnt,
+		spinlock_t *lock);
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
@@ -28,9 +45,4 @@ extern struct clk *mmp_clk_register_apbc(const char *name,
 extern struct clk *mmp_clk_register_apmu(const char *name,
 		const char *parent_name, void __iomem *base, u32 enable_mask,
 		spinlock_t *lock);
-extern struct clk *mmp_clk_register_factor(const char *name,
-		const char *parent_name, unsigned long flags,
-		void __iomem *base, struct mmp_clk_factor_masks *masks,
-		struct mmp_clk_factor_tbl *ftbl, unsigned int ftbl_cnt,
-		spinlock_t *lock);
 #endif
-- 
1.8.3.2

