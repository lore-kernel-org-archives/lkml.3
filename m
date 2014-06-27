Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaF0N0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:26:41 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34309 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbaF0N0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:34 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 02/14] drivers: clk: st: use static const for stm_fs tables
Date: Fri, 27 Jun 2014 15:24:59 +0200
Message-Id: <1403875511-7710-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

converts stm_fs tables into static const
---
 drivers/clk/st/clkgen-fsyn.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 4f53ee0..a7e5db4 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -41,7 +41,7 @@ struct stm_fs {
 	unsigned long nsdiv;
 };
 
-static struct stm_fs fs216c65_rtbl[] = {
+static const struct stm_fs fs216c65_rtbl[] = {
 	{ .mdiv = 0x1f, .pe = 0x0,	.sdiv = 0x7,	.nsdiv = 0 },	/* 312.5 Khz */
 	{ .mdiv = 0x17, .pe = 0x25ed,	.sdiv = 0x1,	.nsdiv = 0 },	/* 27    MHz */
 	{ .mdiv = 0x1a, .pe = 0x7b36,	.sdiv = 0x2,	.nsdiv = 1 },	/* 36.87 MHz */
@@ -49,13 +49,13 @@ static struct stm_fs fs216c65_rtbl[] = {
 	{ .mdiv = 0x11, .pe = 0x1c72,	.sdiv = 0x1,	.nsdiv = 1 },	/* 108   MHz */
 };
 
-static struct stm_fs fs432c65_rtbl[] = {
+static const struct stm_fs fs432c65_rtbl[] = {
 	{ .mdiv = 0x1f, .pe = 0x0,	.sdiv = 0x7,	.nsdiv = 0 },	/* 625   Khz */
 	{ .mdiv = 0x11, .pe = 0x1c72,	.sdiv = 0x2,	.nsdiv = 1 },	/* 108   MHz */
 	{ .mdiv = 0x19, .pe = 0x121a,	.sdiv = 0x0,	.nsdiv = 1 },	/* 297   MHz */
 };
 
-static struct stm_fs fs660c32_rtbl[] = {
+static const struct stm_fs fs660c32_rtbl[] = {
 	{ .mdiv = 0x01, .pe = 0x2aaa,	.sdiv = 0x8,	.nsdiv = 0 },	/* 600   KHz */
 	{ .mdiv = 0x02, .pe = 0x3d33,	.sdiv = 0x0,	.nsdiv = 0 },	/* 148.5 Mhz */
 	{ .mdiv = 0x13, .pe = 0x5bcc,	.sdiv = 0x0,	.nsdiv = 1 },	/* 297   Mhz */
@@ -82,9 +82,9 @@ struct clkgen_quadfs_data {
 	struct clkgen_field nsdiv[QUADFS_MAX_CHAN];
 
 	const struct clk_ops *pll_ops;
-	struct stm_fs *rtbl;
+	const struct stm_fs *rtbl;
 	u8 rtbl_cnt;
-	int  (*get_rate)(unsigned long , struct stm_fs *,
+	int  (*get_rate)(unsigned long , const struct stm_fs *,
 			unsigned long *);
 };
 
@@ -94,11 +94,11 @@ static const struct clk_ops st_quadfs_fs216c65_ops;
 static const struct clk_ops st_quadfs_fs432c65_ops;
 static const struct clk_ops st_quadfs_fs660c32_ops;
 
-static int clk_fs216c65_get_rate(unsigned long, struct stm_fs *,
+static int clk_fs216c65_get_rate(unsigned long, const struct stm_fs *,
 		unsigned long *);
-static int clk_fs432c65_get_rate(unsigned long, struct stm_fs *,
+static int clk_fs432c65_get_rate(unsigned long, const struct stm_fs *,
 		unsigned long *);
-static int clk_fs660c32_dig_get_rate(unsigned long, struct stm_fs *,
+static int clk_fs660c32_dig_get_rate(unsigned long, const struct stm_fs *,
 		unsigned long *);
 /*
  * Values for all of the standalone instances of this clock
@@ -106,7 +106,7 @@ static int clk_fs660c32_dig_get_rate(unsigned long, struct stm_fs *,
  * that the individual channel standby control bits (nsb) are in the
  * first register along with the PLL control bits.
  */
-static struct clkgen_quadfs_data st_fs216c65_416 = {
+static const struct clkgen_quadfs_data st_fs216c65_416 = {
 	/* 416 specific */
 	.npda	= CLKGEN_FIELD(0x0, 0x1, 14),
 	.nsb	= { CLKGEN_FIELD(0x0, 0x1, 10),
@@ -143,7 +143,7 @@ static struct clkgen_quadfs_data st_fs216c65_416 = {
 	.get_rate	= clk_fs216c65_get_rate,
 };
 
-static struct clkgen_quadfs_data st_fs432c65_416 = {
+static const struct clkgen_quadfs_data st_fs432c65_416 = {
 	.npda	= CLKGEN_FIELD(0x0, 0x1, 14),
 	.nsb	= { CLKGEN_FIELD(0x0, 0x1, 10),
 		    CLKGEN_FIELD(0x0, 0x1, 11),
@@ -179,7 +179,7 @@ static struct clkgen_quadfs_data st_fs432c65_416 = {
 	.get_rate	= clk_fs432c65_get_rate,
 };
 
-static struct clkgen_quadfs_data st_fs660c32_E_416 = {
+static const struct clkgen_quadfs_data st_fs660c32_E_416 = {
 	.npda	= CLKGEN_FIELD(0x0, 0x1, 14),
 	.nsb	= { CLKGEN_FIELD(0x0, 0x1, 10),
 		    CLKGEN_FIELD(0x0, 0x1, 11),
@@ -215,7 +215,7 @@ static struct clkgen_quadfs_data st_fs660c32_E_416 = {
 	.get_rate	= clk_fs660c32_dig_get_rate,
 };
 
-static struct clkgen_quadfs_data st_fs660c32_F_416 = {
+static const struct clkgen_quadfs_data st_fs660c32_F_416 = {
 	.npda	= CLKGEN_FIELD(0x0, 0x1, 14),
 	.nsb	= { CLKGEN_FIELD(0x0, 0x1, 10),
 		    CLKGEN_FIELD(0x0, 0x1, 11),
@@ -650,7 +650,7 @@ static int quadfs_fsynth_is_enabled(struct clk_hw *hw)
 
 #define P15			(uint64_t)(1 << 15)
 
-static int clk_fs216c65_get_rate(unsigned long input, struct stm_fs *fs,
+static int clk_fs216c65_get_rate(unsigned long input, const struct stm_fs *fs,
 		unsigned long *rate)
 {
 	uint64_t res;
@@ -670,7 +670,7 @@ static int clk_fs216c65_get_rate(unsigned long input, struct stm_fs *fs,
 	return 0;
 }
 
-static int clk_fs432c65_get_rate(unsigned long input, struct stm_fs *fs,
+static int clk_fs432c65_get_rate(unsigned long input, const struct stm_fs *fs,
 		unsigned long *rate)
 {
 	uint64_t res;
@@ -693,7 +693,7 @@ static int clk_fs432c65_get_rate(unsigned long input, struct stm_fs *fs,
 #define P20		(uint64_t)(1 << 20)
 
 static int clk_fs660c32_dig_get_rate(unsigned long input,
-				struct stm_fs *fs, unsigned long *rate)
+				const struct stm_fs *fs, unsigned long *rate)
 {
 	unsigned long s = (1 << fs->sdiv);
 	unsigned long ns;
@@ -749,7 +749,7 @@ static long quadfs_find_best_rate(struct clk_hw *hw, unsigned long drate,
 {
 	struct st_clk_quadfs_fsynth *fs = to_quadfs_fsynth(hw);
 	int (*clk_fs_get_rate)(unsigned long ,
-				struct stm_fs *, unsigned long *);
+				const struct stm_fs *, unsigned long *);
 	struct stm_fs prev_params;
 	unsigned long prev_rate, rate = 0;
 	unsigned long diff_rate, prev_diff_rate = ~0;
@@ -793,7 +793,7 @@ static unsigned long quadfs_recalc_rate(struct clk_hw *hw,
 	unsigned long rate = 0;
 	struct stm_fs params;
 	int (*clk_fs_get_rate)(unsigned long ,
-				struct stm_fs *, unsigned long *);
+				const struct stm_fs *, unsigned long *);
 
 	clk_fs_get_rate = fs->data->get_rate;
 
-- 
1.9.1

