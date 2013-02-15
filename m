Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935633Ab3BOIqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:46:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10345 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935450Ab3BOIqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:46:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 15 Feb 2013 00:45:59 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v3 5/6] ARM: tegra114: create a DT header defining CLK IDs
Date: Fri, 15 Feb 2013 10:43:16 +0200
Message-ID: <1360917814-27236-6-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To replace magic number in tegra_car:

-               clocks = <&tegra_car 28>;
+               clocks = <&tegra_car CLK_HOST1X>;

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/tegra114-car.h |  272 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 272 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra114-car.h

diff --git a/arch/arm/boot/dts/tegra114-car.h b/arch/arm/boot/dts/tegra114-car.h
new file mode 100644
index 0000000..1fa425a
--- /dev/null
+++ b/arch/arm/boot/dts/tegra114-car.h
@@ -0,0 +1,272 @@
+/*
+ * This header provides constants for binding nvidia,tegra114-car.
+ *
+ * The first 160 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
+ * registers. These IDs often match those in the CAR's RST_DEVICES registers,
+ * but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
+ * this case, those clocks are assigned IDs above 160 in order to highlight
+ * this issue. Implementations that interpret these clock IDs as bit values
+ * within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
+ * explicitly handle these special cases.
+ *
+ * The balance of the clocks controlled by the CAR are assigned IDs of 160 and
+ * above.
+ */
+
+#ifndef _DT_TEGRA114_CAR_H
+#define _DT_TEGRA114_CAR_H
+
+#define TEGRA114_CLK_CPU 0
+/* 1 */
+/* 2 */
+/* 3 */
+#define TEGRA114_CLK_RTC 4
+#define TEGRA114_CLK_TIMER 5
+#define TEGRA114_CLK_UARTA 6
+/* 7 */ /* register bit affects uartb and vfir */
+/* 8 */
+#define TEGRA114_CLK_SDMMC2 9
+/* 10 */ /* register bit affects spdif_in and spdif_out */
+#define TEGRA114_CLK_I2S1 11
+#define TEGRA114_CLK_I2C1 12
+#define TEGRA114_CLK_NDFLASH 13
+#define TEGRA114_CLK_SDMMC1 14
+#define TEGRA114_CLK_SDMMC4 15
+/* 16 */
+#define TEGRA114_CLK_PWM 17
+#define TEGRA114_CLK_I2S2 18
+#define TEGRA114_CLK_EPP 19
+/* 20 */ /* register bit affects vi and vi_sensor */
+#define TEGRA114_CLK_GR_2D 21
+#define TEGRA114_CLK_USBD 22
+#define TEGRA114_CLK_ISP 23
+#define TEGRA114_CLK_GR_3D 24
+/* 25 */
+#define TEGRA114_CLK_DISP2 26
+#define TEGRA114_CLK_DISP1 27
+#define TEGRA114_CLK_HOST1X 28
+#define TEGRA114_CLK_VCP 29
+#define TEGRA114_CLK_I2S0 30
+/* 31 */
+
+/* 32 */
+/* 33 */
+#define TEGRA114_CLK_APBDMA 34
+/* 35 */
+#define TEGRA114_CLK_KBC 36
+/* 37 */
+/* 38 */
+/* 39 */
+#define TEGRA114_CLK_KFUSE 40
+#define TEGRA114_CLK_SBC1 41
+#define TEGRA114_CLK_NOR 42
+/* 43 */
+#define TEGRA114_CLK_SBC2 44
+/* 45 */
+#define TEGRA114_CLK_SBC3 46
+#define TEGRA114_CLK_I2C5 47
+#define TEGRA114_CLK_DSIA 48
+/* 49 */
+#define TEGRA114_CLK_MIPI 50
+#define TEGRA114_CLK_HDMI 51
+#define TEGRA114_CLK_CSI 52
+/* 53 */
+#define TEGRA114_CLK_I2C2 54
+#define TEGRA114_CLK_UARTC 55
+#define TEGRA114_CLK_MIPI_CAL 56
+/* 57 */
+#define TEGRA114_CLK_USB2 58
+#define TEGRA114_CLK_USB3 59
+/* 60 */
+#define TEGRA114_CLK_VDE 61
+#define TEGRA114_CLK_BSEA 62
+#define TEGRA114_CLK_BSEV 63
+
+/* 64 */
+#define TEGRA114_CLK_UARTD 65
+#define TEGRA114_CLK_UARTE 66
+#define TEGRA114_CLK_I2C3 67
+#define TEGRA114_CLK_SBC4 68
+#define TEGRA114_CLK_SDMMC3 69
+/* 70 */
+#define TEGRA114_CLK_OWR 71
+/* 72 */
+#define TEGRA114_CLK_CSITE 73
+/* 74 */
+/* 75 */
+#define TEGRA114_CLK_LA 76
+#define TEGRA114_CLK_TRACE 77
+#define TEGRA114_CLK_SOC_THERM 78
+#define TEGRA114_CLK_DTV 79
+#define TEGRA114_CLK_NDSPEED 80
+#define TEGRA114_CLK_I2CSLOW 81
+#define TEGRA114_CLK_DSIB 82
+#define TEGRA114_CLK_TSEC 83
+/* 84 */
+/* 85 */
+/* 86 */
+/* 87 */
+/* 88 */
+#define TEGRA114_CLK_XUSB_HOST 89
+/* 90 */
+#define TEGRA114_CLK_MSENC 91
+#define TEGRA114_CLK_CSUS 92
+/* 93 */
+/* 94 */
+/* 95 */ /* bit affects xusb_dev and xusb_dev_src */
+
+/* 96 */
+/* 97 */
+/* 98 */
+#define TEGRA114_CLK_MSELECT 99
+#define TEGRA114_CLK_TSENSOR 100
+#define TEGRA114_CLK_I2S3 101
+#define TEGRA114_CLK_I2S4 102
+#define TEGRA114_CLK_I2C4 103
+#define TEGRA114_CLK_SBC5 104
+#define TEGRA114_CLK_SBC6 105
+#define TEGRA114_CLK_D_AUDIO 106
+#define TEGRA114_CLK_APBIF 107
+#define TEGRA114_CLK_DAM0 108
+#define TEGRA114_CLK_DAM1 109
+#define TEGRA114_CLK_DAM2 110
+#define TEGRA114_CLK_HDA2CODEC_2X 111
+/* 112 */
+#define TEGRA114_CLK_AUDIO0_2X 113
+#define TEGRA114_CLK_AUDIO1_2X 114
+#define TEGRA114_CLK_AUDIO2_2X 115
+#define TEGRA114_CLK_AUDIO3_2X 116
+#define TEGRA114_CLK_AUDIO4_2X 117
+#define TEGRA114_CLK_SPDIF_2X 118
+#define TEGRA114_CLK_ACTMON 119
+#define TEGRA114_CLK_EXTERN1 120
+#define TEGRA114_CLK_EXTERN2 121
+#define TEGRA114_CLK_EXTERN3 122
+/* 123 */
+/* 124 */
+#define TEGRA114_CLK_HDA 125
+/* 126 */
+#define TEGRA114_CLK_SE 127
+
+#define TEGRA114_CLK_HDA2HDMI 128
+/* 129 */
+/* 130 */
+/* 131 */
+/* 132 */
+/* 133 */
+/* 134 */
+/* 135 */
+/* 136 */
+/* 137 */
+/* 138 */
+/* 139 */
+/* 140 */
+/* 141 */
+/* 142 */
+/* 143 */ /* bit affects xusb_falcon_src, xusb_fs_src, xusb_host_src and xusb_ss_src */
+#define TEGRA114_CLK_CILAB 144
+#define TEGRA114_CLK_CILCD 145
+#define TEGRA114_CLK_CILE 146
+#define TEGRA114_CLK_DSIALP 147
+#define TEGRA114_CLK_DSIBLP 148
+/* 149 */
+#define TEGRA114_CLK_DDS 150
+/* 151 */
+#define TEGRA114_CLK_DP2 152
+#define TEGRA114_CLK_AMX 153
+#define TEGRA114_CLK_ADX 154
+/* 155 */
+#define TEGRA114_CLK_XUSB_SS 156
+/* 157 */
+/* 158 */
+/* 159 */
+
+#define TEGRA114_CLK_UARTB 192
+#define TEGRA114_CLK_VFIR 193
+#define TEGRA114_CLK_SPDIF_IN 194
+#define TEGRA114_CLK_SPDIF_OUT 195
+#define TEGRA114_CLK_VI 196
+#define TEGRA114_CLK_VI_SENSOR 197
+#define TEGRA114_CLK_FUSE 198
+#define TEGRA114_CLK_FUSE_BURN 199
+#define TEGRA114_CLK_32K 200
+#define TEGRA114_CLK_M 201
+#define TEGRA114_CLK_M_DIV2 202
+#define TEGRA114_CLK_M_DIV4 203
+#define TEGRA114_CLK_PLL_REF 204
+#define TEGRA114_CLK_PLL_C 205
+#define TEGRA114_CLK_PLL_C_OUT1 206
+#define TEGRA114_CLK_PLL_C2 207
+#define TEGRA114_CLK_PLL_C3 208
+#define TEGRA114_CLK_PLL_M 209
+#define TEGRA114_CLK_PLL_M_OUT1 210
+#define TEGRA114_CLK_PLL_P 211
+#define TEGRA114_CLK_PLL_P_OUT1 212
+#define TEGRA114_CLK_PLL_P_OUT2 213
+#define TEGRA114_CLK_PLL_P_OUT3 214
+#define TEGRA114_CLK_PLL_P_OUT4 215
+#define TEGRA114_CLK_PLL_A 216
+#define TEGRA114_CLK_PLL_A_OUT0 217
+#define TEGRA114_CLK_PLL_D 218
+#define TEGRA114_CLK_PLL_D_OUT0 219
+#define TEGRA114_CLK_PLL_D2 220
+#define TEGRA114_CLK_PLL_D2_OUT0 221
+#define TEGRA114_CLK_PLL_U 222
+#define TEGRA114_CLK_PLL_U_480M 223
+
+#define TEGRA114_CLK_PLL_U_60M 224
+#define TEGRA114_CLK_PLL_U_48M 225
+#define TEGRA114_CLK_PLL_U_12M 226
+#define TEGRA114_CLK_PLL_X 227
+#define TEGRA114_CLK_PLL_X_OUT0 228
+#define TEGRA114_CLK_PLL_RE_VCO 229
+#define TEGRA114_CLK_PLL_RE_OUT 230
+#define TEGRA114_CLK_PLL_E_OUT0 231
+#define TEGRA114_CLK_SPDIF_IN_SYNC 232
+#define TEGRA114_CLK_I2S0_SYNC 233
+#define TEGRA114_CLK_I2S1_SYNC 234
+#define TEGRA114_CLK_I2S2_SYNC 235
+#define TEGRA114_CLK_I2S3_SYNC 236
+#define TEGRA114_CLK_I2S4_SYNC 237
+#define TEGRA114_CLK_VIMCLK_SYNC 238
+#define TEGRA114_CLK_AUDIO0 239
+#define TEGRA114_CLK_AUDIO1 240
+#define TEGRA114_CLK_AUDIO2 241
+#define TEGRA114_CLK_AUDIO3 242
+#define TEGRA114_CLK_AUDIO4 243
+#define TEGRA114_CLK_SPDIF 244
+#define TEGRA114_CLK_OUT_1 245
+#define TEGRA114_CLK_OUT_2 246
+#define TEGRA114_CLK_OUT_3 247
+#define TEGRA114_CLK_BLINK 248
+#define TEGRA114_CLK_MIPI_CAL_FAST 214
+#define TEGRA114_CLK_DSI1_FIXED 214
+#define TEGRA114_CLK_DSI2_FIXED 214
+#define TEGRA114_CLK_XUSB_HOST_SRC 215
+#define TEGRA114_CLK_XUSB_FALCON_SRC 216
+#define TEGRA114_CLK_XUSB_FS_SRC 217
+#define TEGRA114_CLK_XUSB_SS_SRC 218
+#define TEGRA114_CLK_XUSB_DEV_SRC 219
+#define TEGRA114_CLK_XUSB_DEV 220
+#define TEGRA114_CLK_XUSB_HS_SRC 221
+#define TEGRA114_CLK_SCLK 222
+#define TEGRA114_CLK_HCLK 223
+
+#define TEGRA114_CLK_PCLK 224
+#define TEGRA114_CLK_CCLK_G 225
+#define TEGRA114_CLK_CCLK_LP 226
+
+#define TEGRA114_CLK_AUDIO0_MUX 300 /* Mux clocks */
+#define TEGRA114_CLK_AUDIO1_MUX 301
+#define TEGRA114_CLK_AUDIO2_MUX 302
+#define TEGRA114_CLK_AUDIO3_MUX 303
+#define TEGRA114_CLK_AUDIO4_MUX 304
+#define TEGRA114_CLK_SPDIF_MUX 305
+#define TEGRA114_CLK_OUT_1_MUX 306
+#define TEGRA114_CLK_OUT_2_MUX 307
+#define TEGRA114_CLK_OUT_3_MUX 308
+#define TEGRA114_CLK_DSIA_MUX 309
+#define TEGRA114_CLK_DSIB_MUX 310
+#define TEGRA114_CLK_MAX 311
+
+#endif	/* _DT_TEGRA114_CAR_H */
-- 
1.7.9.5

