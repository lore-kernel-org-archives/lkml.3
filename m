Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3LRMxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:53:19 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16717 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3LRMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:53:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Dec 2013 04:55:25 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <mark.rutland@arm.com>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: fix missing pincontrol configuration for Venice2
Date: Wed, 18 Dec 2013 18:22:58 +0530
Message-ID: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compare the initial population of default pinmux configuration of Venice2
with the chrome branch and add/fix the missing configurations.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra124-venice2.dts |  308 +++++++++++++++++++++++++++-----
 1 file changed, 260 insertions(+), 48 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index d6bb25c..6bc4e07 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -23,34 +23,40 @@
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			dap1_din_pn1 {
-				nvidia,pins = "dap1_din_pn1",
-					      "dap1_dout_pn2",
+				nvidia,pins = "dap1_din_pn1";
+				nvidia,function = "i2s0";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+			};
+			dap1_dout_pn2 {
+				nvidia,pins = "dap1_dout_pn2",
 					      "dap1_fs_pn0",
 					      "dap1_sclk_pn3";
 				nvidia,function = "i2s0";
-				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			dap2_din_pa4 {
-				nvidia,pins = "dap2_din_pa4",
-					      "dap2_dout_pa5",
-					      "dap2_fs_pa2",
-					      "dap2_sclk_pa3";
+				nvidia,pins = "dap2_din_pa4";
 				nvidia,function = "i2s1";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
-			dvfs_pwm_px0 {
-				nvidia,pins = "dvfs_pwm_px0";
-				nvidia,function = "cldvfs";
+			dap2_dout_pa5 {
+				nvidia,pins = "dap2_dout_pa5",
+					      "dap2_fs_pa2",
+					      "dap2_sclk_pa3";
+				nvidia,function = "i2s1";
 				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
-				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
-			dvfs_clk_px2 {
-				nvidia,pins = "dvfs_clk_px2";
+			dvfs_pwm_px0 {
+				nvidia,pins = "dvfs_pwm_px0",
+					      "dvfs_clk_px2";
 				nvidia,function = "cldvfs";
 				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
@@ -58,12 +64,18 @@
 			};
 			ulpi_clk_py0 {
 				nvidia,pins = "ulpi_clk_py0",
-					      "ulpi_dir_py1",
 					      "ulpi_nxt_py2",
 					      "ulpi_stp_py3";
 				nvidia,function = "spi1";
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
+			ulpi_dir_py1 {
+				nvidia,pins = "ulpi_dir_py1";
+				nvidia,function = "spi1";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
-				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			cam_i2c_scl_pbb1 {
@@ -90,19 +102,18 @@
 				nvidia,pins = "pg4",
 					      "pg5",
 					      "pg6",
-					      "pg7",
 					      "pi3";
 				nvidia,function = "spi4";
 				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
-			ph0 {
-				nvidia,pins = "ph0";
-				nvidia,function = "pwm0";
+			pg7 {
+				nvidia,pins = "pg7";
+				nvidia,function = "spi4";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
-				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
-				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			ph1 {
 				nvidia,pins = "ph1";
@@ -111,12 +122,14 @@
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
-			ph2 {
-				nvidia,pins = "ph2";
-				nvidia,function = "gmi";
-				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+			pk0 {
+				nvidia,pins = "pk0",
+					      "kb_row15_ps7",
+					      "clk_32k_out_pa0";
+				nvidia,function = "soc";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
-				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			sdmmc1_clk_pz0 {
 				nvidia,pins = "sdmmc1_clk_pz0",
@@ -130,6 +143,17 @@
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
+			sdmmc1_cmd_pz1 {
+				nvidia,pins = "sdmmc1_cmd_pz1",
+					      "sdmmc1_dat0_py7",
+					      "sdmmc1_dat1_py6",
+					      "sdmmc1_dat2_py5",
+					      "sdmmc1_dat3_py4";
+				nvidia,function = "sdmmc1";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
 			sdmmc3_clk_pa6 {
 				nvidia,pins = "sdmmc3_clk_pa6";
 				nvidia,function = "sdmmc3";
@@ -179,6 +203,7 @@
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
 				nvidia,open-drain = <TEGRA_PIN_ENABLE>;
 			};
 			jtag_rtck {
@@ -231,12 +256,18 @@
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			dap4_din_pp5 {
-				nvidia,pins = "dap4_din_pp5",
-					      "dap4_dout_pp6",
+				nvidia,pins = "dap4_din_pp5";
+				nvidia,function = "i2s3";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+			};
+			dap4_dout_pp6 {
+				nvidia,pins = "dap4_dout_pp6",
 					      "dap4_fs_pp4",
 					      "dap4_sclk_pp7";
 				nvidia,function = "i2s3";
-				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
@@ -248,51 +279,67 @@
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 				nvidia,lock = <TEGRA_PIN_DISABLE>;
-				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_ENABLE>;
 			};
-			pu0 {
-				nvidia,pins = "pu0",
-					      "pu1",
-					      "pu2",
-					      "pu3";
-				nvidia,function = "uarta";
+			uart2_cts_n_pj5 {
+				nvidia,pins = "uart2_cts_n_pj5";
+				nvidia,function = "uartb";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
-			uart2_cts_n_pj5 {
-				nvidia,pins = "uart2_cts_n_pj5",
-					      "uart2_rts_n_pj6";
+			uart2_rts_n_pj6 {
+				nvidia,pins = "uart2_rts_n_pj6";
 				nvidia,function = "uartb";
-				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			uart2_rxd_pc3 {
-				nvidia,pins = "uart2_rxd_pc3",
-					      "uart2_txd_pc2";
+				nvidia,pins = "uart2_rxd_pc3";
 				nvidia,function = "irda";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
+			uart2_txd_pc2 {
+				nvidia,pins = "uart2_txd_pc2";
+				nvidia,function = "irda";
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
 			uart3_cts_n_pa1 {
 				nvidia,pins = "uart3_cts_n_pa1",
-					      "uart3_rts_n_pc0",
-					      "uart3_rxd_pw7",
-					      "uart3_txd_pw6";
+					      "uart3_rxd_pw7";
 				nvidia,function = "uartc";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
+			uart3_rts_n_pc0 {
+				nvidia,pins = "uart3_rts_n_pc0",
+					      "uart3_txd_pw6";
+				nvidia,function = "uartc";
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
 			hdmi_cec_pee3 {
 				nvidia,pins = "hdmi_cec_pee3";
 				nvidia,function = "cec";
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
-				nvidia,open-drain = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
+			};
+			hdmi_int_pn7 {
+				nvidia,pins = "hdmi_int_pn7";
+				nvidia,function = "rsvd1";
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			ddc_scl_pv4 {
 				nvidia,pins = "ddc_scl_pv4",
@@ -301,6 +348,52 @@
 				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,rcv-sel = <TEGRA_PIN_ENABLE>;
+			};
+			pj7 {
+				nvidia,pins = "pj7",
+					      "pk7";
+				nvidia,function = "uartd";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			pb0 {
+				nvidia,pins = "pb0",
+					      "pb1";
+				nvidia,function = "uartd";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			ph0 {
+				nvidia,pins = "ph0";
+				nvidia,function = "pwm0";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			kb_row10_ps2 {
+				nvidia,pins = "kb_row10_ps2";
+				nvidia,function = "uarta";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			kb_row9_ps1 {
+				nvidia,pins = "kb_row9_ps1";
+				nvidia,function = "uarta";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			kb_row6_pr6 {
+				nvidia,pins = "kb_row6_pr6";
+				nvidia,function = "displaya_alt";
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			usb_vbus_en0_pn4 {
 				nvidia,pins = "usb_vbus_en0_pn4";
@@ -309,7 +402,7 @@
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 				nvidia,lock = <TEGRA_PIN_DISABLE>;
-				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_ENABLE>;
 			};
 			usb_vbus_en1_pn5 {
 				nvidia,pins = "usb_vbus_en1_pn5";
@@ -318,7 +411,7 @@
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 				nvidia,lock = <TEGRA_PIN_DISABLE>;
-				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_ENABLE>;
 			};
 			drive_sdio1 {
 				nvidia,pins = "drive_sdio1";
@@ -351,6 +444,125 @@
 				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_FASTEST>;
 				nvidia,drive-type = <1>;
 			};
+			als_irq_l {
+				nvidia,pins = "gpio_x3_aud_px3";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			codec_irq_l {
+				nvidia,pins = "ph4";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			lcd_bl_en {
+				nvidia,pins = "ph2";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			touch_irq_l {
+				nvidia,pins = "gpio_w3_aud_pw3";
+				nvidia,function = "spi6";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			tpm_davint_l {
+				nvidia,pins = "ph6";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			ts_irq_l {
+				nvidia,pins = "pk2";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			ts_reset_l {
+				nvidia,pins = "pk4";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			ts_shdn_l {
+				nvidia,pins = "pk1";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			ph7 {
+				nvidia,pins = "ph7";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			kb_col0_ap {
+				nvidia,pins = "kb_col0_pq0";
+				nvidia,function = "rsvd4";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			lid_open {
+				nvidia,pins = "kb_row4_pr4";
+				nvidia,function = "rsvd3";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			en_vdd_sd {
+				nvidia,pins = "kb_row0_pr0";
+				nvidia,function = "rsvd4";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			ac_ok {
+				nvidia,pins = "pj0";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			sensor_irq_l {
+				nvidia,pins = "pi6";
+				nvidia,function = "gmi";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			wifi_en {
+				nvidia,pins = "gpio_x7_aud_px7";
+				nvidia,function = "rsvd4";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			wifi_rst_l {
+				nvidia,pins = "clk2_req_pcc5";
+				nvidia,function = "dap";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
+			hp_det_l {
+				nvidia,pins = "ulpi_data1_po2";
+				nvidia,function = "spi3";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+			};
 		};
 	};
 
-- 
1.7.9.5

