Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaF0N1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:27:51 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34853 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaF0N0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:38 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Olivier Bideau <olivier.bideau@st.com>
Subject: [PATCH v2 10/14] drivers: clk: st: STiH407: Support for clockgenC0
Date: Fri, 27 Jun 2014 15:25:07 +0200
Message-Id: <1403875511-7710-11-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch added support for DT registration of ClockGenC0
It includes 2 c32 type PLL and a 660 Quadfs.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/clk/st/clkgen-fsyn.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/st/clkgen-pll.c  | 32 ++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index b2b73f4..0e0d5f9 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -255,6 +255,49 @@ static const struct clkgen_quadfs_data st_fs660c32_F_416 = {
 	.get_rate	= clk_fs660c32_dig_get_rate,
 };
 
+static const struct clkgen_quadfs_data st_fs660c32_C_407 = {
+	.nrst_present = true,
+	.nrst	= { CLKGEN_FIELD(0x2f0, 0x1, 0),
+		    CLKGEN_FIELD(0x2f0, 0x1, 1),
+		    CLKGEN_FIELD(0x2f0, 0x1, 2),
+		    CLKGEN_FIELD(0x2f0, 0x1, 3) },
+	.npda	= CLKGEN_FIELD(0x2f0, 0x1, 12),
+	.nsb	= { CLKGEN_FIELD(0x2f0, 0x1, 8),
+		    CLKGEN_FIELD(0x2f0, 0x1, 9),
+		    CLKGEN_FIELD(0x2f0, 0x1, 10),
+		    CLKGEN_FIELD(0x2f0, 0x1, 11) },
+	.nsdiv_present = true,
+	.nsdiv	= { CLKGEN_FIELD(0x304, 0x1, 24),
+		    CLKGEN_FIELD(0x308, 0x1, 24),
+		    CLKGEN_FIELD(0x30c, 0x1, 24),
+		    CLKGEN_FIELD(0x310, 0x1, 24) },
+	.mdiv	= { CLKGEN_FIELD(0x304, 0x1f, 15),
+		    CLKGEN_FIELD(0x308, 0x1f, 15),
+		    CLKGEN_FIELD(0x30c, 0x1f, 15),
+		    CLKGEN_FIELD(0x310, 0x1f, 15) },
+	.en	= { CLKGEN_FIELD(0x2fc, 0x1, 0),
+		    CLKGEN_FIELD(0x2fc, 0x1, 1),
+		    CLKGEN_FIELD(0x2fc, 0x1, 2),
+		    CLKGEN_FIELD(0x2fc, 0x1, 3) },
+	.ndiv	= CLKGEN_FIELD(0x2f4, 0x7, 16),
+	.pe	= { CLKGEN_FIELD(0x304, 0x7fff, 0),
+		    CLKGEN_FIELD(0x308, 0x7fff, 0),
+		    CLKGEN_FIELD(0x30c, 0x7fff, 0),
+		    CLKGEN_FIELD(0x310, 0x7fff, 0) },
+	.sdiv	= { CLKGEN_FIELD(0x304, 0xf, 20),
+		    CLKGEN_FIELD(0x308, 0xf, 20),
+		    CLKGEN_FIELD(0x30c, 0xf, 20),
+		    CLKGEN_FIELD(0x310, 0xf, 20) },
+	.lockstatus_present = true,
+	.lock_status = CLKGEN_FIELD(0x2A0, 0x1, 24),
+	.powerup_polarity = 1,
+	.standby_polarity = 1,
+	.pll_ops	= &st_quadfs_pll_c32_ops,
+	.rtbl		= fs660c32_rtbl,
+	.rtbl_cnt	= ARRAY_SIZE(fs660c32_rtbl),
+	.get_rate	= clk_fs660c32_dig_get_rate,
+};
+
 /**
  * DOC: A Frequency Synthesizer that multiples its input clock by a fixed factor
  *
@@ -938,6 +981,10 @@ static struct of_device_id quadfs_of_match[] = {
 		.compatible = "st,stih416-quadfs660-F",
 		.data = (void *)&st_fs660c32_F_416
 	},
+	{
+		.compatible = "st,stih407-quadfs660-C",
+		.data = (void *)&st_fs660c32_C_407
+	},
 	{}
 };
 
diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index d4ef4f4..5327a74 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -192,6 +192,30 @@ static const struct clkgen_pll_data st_pll3200c32_407_a0 = {
 	.ops		= &stm_pll3200c32_ops,
 };
 
+static const struct clkgen_pll_data st_pll3200c32_407_c0_0 = {
+	/* 407 C0 PLL0 */
+	.pdn_status	= CLKGEN_FIELD(0x2a0,	0x1,			8),
+	.locked_status	= CLKGEN_FIELD(0x2a0,	0x1,			24),
+	.ndiv		= CLKGEN_FIELD(0x2a4,	C32_NDIV_MASK,		16),
+	.idf		= CLKGEN_FIELD(0x2a4,	C32_IDF_MASK,		0x0),
+	.num_odfs = 1,
+	.odf		= { CLKGEN_FIELD(0x2b4, C32_ODF_MASK,		0) },
+	.odf_gate	= { CLKGEN_FIELD(0x2b4, 0x1,			6) },
+	.ops		= &stm_pll3200c32_ops,
+};
+
+static const struct clkgen_pll_data st_pll3200c32_407_c0_1 = {
+	/* 407 C0 PLL1 */
+	.pdn_status	= CLKGEN_FIELD(0x2c8,	0x1,			8),
+	.locked_status	= CLKGEN_FIELD(0x2c8,	0x1,			24),
+	.ndiv		= CLKGEN_FIELD(0x2cc,	C32_NDIV_MASK,		16),
+	.idf		= CLKGEN_FIELD(0x2cc,	C32_IDF_MASK,		0x0),
+	.num_odfs = 1,
+	.odf		= { CLKGEN_FIELD(0x2dc, C32_ODF_MASK,		0) },
+	.odf_gate	= { CLKGEN_FIELD(0x2dc, 0x1,			6) },
+	.ops		= &stm_pll3200c32_ops,
+};
+
 /**
  * DOC: Clock Generated by PLL, rate set and enabled by bootloader
  *
@@ -586,6 +610,14 @@ static struct of_device_id c32_pll_of_match[] = {
 		.compatible = "st,stih407-plls-c32-a0",
 		.data = &st_pll3200c32_407_a0,
 	},
+	{
+		.compatible = "st,stih407-plls-c32-c0_0",
+		.data = &st_pll3200c32_407_c0_0,
+	},
+	{
+		.compatible = "st,stih407-plls-c32-c0_1",
+		.data = &st_pll3200c32_407_c0_1,
+	},
 	{}
 };
 
-- 
1.9.1

