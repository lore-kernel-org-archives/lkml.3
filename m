Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbaHZEkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:40:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1027 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbaHZEhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:40 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/12] clk: mmp: add prefix "mmp" for structures defined for clk-frac
Date: Tue, 26 Aug 2014 12:38:13 +0800
Message-ID: <1409027904-21859-2-git-send-email-chao.xie@marvell.com>
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

The structures defined for clk-frac will be used out side
of clk-frac.c.
To avoid conflicts, add prefix "mmp" for these structures'
name.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/clk-frac.c   | 23 ++++++++++++-----------
 drivers/clk/mmp/clk-mmp2.c   |  4 ++--
 drivers/clk/mmp/clk-pxa168.c |  4 ++--
 drivers/clk/mmp/clk-pxa910.c |  4 ++--
 drivers/clk/mmp/clk.h        |  8 ++++----
 5 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 23a56f5..3fbc9ca 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -22,19 +22,19 @@
  * numerator/denominator = Fin / (Fout * factor)
  */
 
-#define to_clk_factor(hw) container_of(hw, struct clk_factor, hw)
-struct clk_factor {
+#define to_clk_factor(hw) container_of(hw, struct mmp_clk_factor, hw)
+struct mmp_clk_factor {
 	struct clk_hw		hw;
 	void __iomem		*base;
-	struct clk_factor_masks	*masks;
-	struct clk_factor_tbl	*ftbl;
+	struct mmp_clk_factor_masks	*masks;
+	struct mmp_clk_factor_tbl	*ftbl;
 	unsigned int		ftbl_cnt;
 };
 
 static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
 		unsigned long *prate)
 {
-	struct clk_factor *factor = to_clk_factor(hw);
+	struct mmp_clk_factor *factor = to_clk_factor(hw);
 	unsigned long rate = 0, prev_rate;
 	int i;
 
@@ -58,8 +58,8 @@ static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
 static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
 		unsigned long parent_rate)
 {
-	struct clk_factor *factor = to_clk_factor(hw);
-	struct clk_factor_masks *masks = factor->masks;
+	struct mmp_clk_factor *factor = to_clk_factor(hw);
+	struct mmp_clk_factor_masks *masks = factor->masks;
 	unsigned int val, num, den;
 
 	val = readl_relaxed(factor->base);
@@ -81,8 +81,8 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
 static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 				unsigned long prate)
 {
-	struct clk_factor *factor = to_clk_factor(hw);
-	struct clk_factor_masks *masks = factor->masks;
+	struct mmp_clk_factor *factor = to_clk_factor(hw);
+	struct mmp_clk_factor_masks *masks = factor->masks;
 	int i;
 	unsigned long val;
 	unsigned long prev_rate, rate = 0;
@@ -118,10 +118,11 @@ static struct clk_ops clk_factor_ops = {
 
 struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *base,
-		struct clk_factor_masks *masks, struct clk_factor_tbl *ftbl,
+		struct mmp_clk_factor_masks *masks,
+		struct mmp_clk_factor_tbl *ftbl,
 		unsigned int ftbl_cnt)
 {
-	struct clk_factor *factor;
+	struct mmp_clk_factor *factor;
 	struct clk_init_data init;
 	struct clk *clk;
 
diff --git a/drivers/clk/mmp/clk-mmp2.c b/drivers/clk/mmp/clk-mmp2.c
index b2721ca..7083f12 100644
--- a/drivers/clk/mmp/clk-mmp2.c
+++ b/drivers/clk/mmp/clk-mmp2.c
@@ -54,7 +54,7 @@
 
 static DEFINE_SPINLOCK(clk_lock);
 
-static struct clk_factor_masks uart_factor_masks = {
+static struct mmp_clk_factor_masks uart_factor_masks = {
 	.factor = 2,
 	.num_mask = 0x1fff,
 	.den_mask = 0x1fff,
@@ -62,7 +62,7 @@ static struct clk_factor_masks uart_factor_masks = {
 	.den_shift = 0,
 };
 
-static struct clk_factor_tbl uart_factor_tbl[] = {
+static struct mmp_clk_factor_tbl uart_factor_tbl[] = {
 	{.num = 14634, .den = 2165},	/*14.745MHZ */
 	{.num = 3521, .den = 689},	/*19.23MHZ */
 	{.num = 9679, .den = 5728},	/*58.9824MHZ */
diff --git a/drivers/clk/mmp/clk-pxa168.c b/drivers/clk/mmp/clk-pxa168.c
index 014396b..75266ac 100644
--- a/drivers/clk/mmp/clk-pxa168.c
+++ b/drivers/clk/mmp/clk-pxa168.c
@@ -47,7 +47,7 @@
 
 static DEFINE_SPINLOCK(clk_lock);
 
-static struct clk_factor_masks uart_factor_masks = {
+static struct mmp_clk_factor_masks uart_factor_masks = {
 	.factor = 2,
 	.num_mask = 0x1fff,
 	.den_mask = 0x1fff,
@@ -55,7 +55,7 @@ static struct clk_factor_masks uart_factor_masks = {
 	.den_shift = 0,
 };
 
-static struct clk_factor_tbl uart_factor_tbl[] = {
+static struct mmp_clk_factor_tbl uart_factor_tbl[] = {
 	{.num = 8125, .den = 1536},	/*14.745MHZ */
 };
 
diff --git a/drivers/clk/mmp/clk-pxa910.c b/drivers/clk/mmp/clk-pxa910.c
index 9efc6a4..f817999 100644
--- a/drivers/clk/mmp/clk-pxa910.c
+++ b/drivers/clk/mmp/clk-pxa910.c
@@ -45,7 +45,7 @@
 
 static DEFINE_SPINLOCK(clk_lock);
 
-static struct clk_factor_masks uart_factor_masks = {
+static struct mmp_clk_factor_masks uart_factor_masks = {
 	.factor = 2,
 	.num_mask = 0x1fff,
 	.den_mask = 0x1fff,
@@ -53,7 +53,7 @@ static struct clk_factor_masks uart_factor_masks = {
 	.den_shift = 0,
 };
 
-static struct clk_factor_tbl uart_factor_tbl[] = {
+static struct mmp_clk_factor_tbl uart_factor_tbl[] = {
 	{.num = 8125, .den = 1536},	/*14.745MHZ */
 };
 
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index ab86dd4..3fe92be 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -7,7 +7,7 @@
 #define APBC_NO_BUS_CTRL	BIT(0)
 #define APBC_POWER_CTRL		BIT(1)
 
-struct clk_factor_masks {
+struct mmp_clk_factor_masks {
 	unsigned int	factor;
 	unsigned int	num_mask;
 	unsigned int	den_mask;
@@ -15,7 +15,7 @@ struct clk_factor_masks {
 	unsigned int	den_shift;
 };
 
-struct clk_factor_tbl {
+struct mmp_clk_factor_tbl {
 	unsigned int num;
 	unsigned int den;
 };
@@ -30,6 +30,6 @@ extern struct clk *mmp_clk_register_apmu(const char *name,
 		spinlock_t *lock);
 extern struct clk *mmp_clk_register_factor(const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *base, struct clk_factor_masks *masks,
-		struct clk_factor_tbl *ftbl, unsigned int ftbl_cnt);
+		void __iomem *base, struct mmp_clk_factor_masks *masks,
+		struct mmp_clk_factor_tbl *ftbl, unsigned int ftbl_cnt);
 #endif
-- 
1.8.3.2

