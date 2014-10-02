Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJBInP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:43:15 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47381 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaJBIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:37 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/7] pinctrl: nomadik: force-convert to generic config bindings
Date: Thu,  2 Oct 2014 10:40:16 +0200
Message-Id: <1412239220-22495-4-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the Nomadik pin controller and all associated device
trees to use the standard, generic config bindings for pin controllers.
There are no such device trees deployed in the wild so this is
safe to do to set a good example.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi     |  36 +++---
 arch/arm/boot/dts/ste-href-family-pinctrl.dtsi | 150 ++++++++++++-------------
 arch/arm/boot/dts/ste-href-stuib.dtsi          |   4 +-
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi     |  12 +-
 arch/arm/boot/dts/ste-hrefprev60.dtsi          |   8 +-
 arch/arm/boot/dts/ste-hrefv60plus.dtsi         |  38 +++----
 arch/arm/boot/dts/ste-nomadik-s8815.dts        |   8 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi     |  12 +-
 arch/arm/boot/dts/ste-snowball.dts             |  24 ++--
 drivers/pinctrl/nomadik/pinctrl-nomadik.c      |   4 +-
 10 files changed, 148 insertions(+), 148 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi b/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
index 08a7365cb929..52dba2e39c71 100644
--- a/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
+++ b/arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
@@ -23,24 +23,24 @@
 
 				uart0_default_mode: uart0_default {
 					default_cfg1 {
-						ste,pins = "GPIO0", "GPIO2";
+						pins = "GPIO0", "GPIO2";
 						ste,config = <&in_pu>;
 					};
 
 					default_cfg2 {
-						ste,pins = "GPIO1", "GPIO3";
+						pins = "GPIO1", "GPIO3";
 						ste,config = <&out_hi>;
 					};
 				};
 
 				uart0_sleep_mode: uart0_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO0", "GPIO2";
+						pins = "GPIO0", "GPIO2";
 						ste,config = <&slpm_in_pu>;
 					};
 
 					sleep_cfg2 {
-						ste,pins = "GPIO1", "GPIO3";
+						pins = "GPIO1", "GPIO3";
 						ste,config = <&slpm_out_hi>;
 					};
 				};
@@ -54,24 +54,24 @@
 					};
 
 					default_cfg1 {
-						ste,pins = "GPIO120";
+						pins = "GPIO120";
 						ste,config = <&in_pu>;
 					};
 
 					default_cfg2 {
-						ste,pins = "GPIO121";
+						pins = "GPIO121";
 						ste,config = <&out_hi>;
 					};
 				};
 
 				uart2_sleep_mode: uart2_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO120";
+						pins = "GPIO120";
 						ste,config = <&slpm_in_pu>;
 					};
 
 					sleep_cfg2 {
-						ste,pins = "GPIO121";
+						pins = "GPIO121";
 						ste,config = <&slpm_out_hi>;
 					};
 				};
@@ -87,14 +87,14 @@
 
 				i2c0_default_mode: i2c_default {
 					default_cfg1 {
-						ste,pins = "GPIO147", "GPIO148";
+						pins = "GPIO147", "GPIO148";
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c0_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO147", "GPIO148";
+						pins = "GPIO147", "GPIO148";
 						ste,config = <&slpm_in_pu>;
 					};
 				};
@@ -110,14 +110,14 @@
 
 				i2c1_default_mode: i2c_default {
 					default_cfg1 {
-						ste,pins = "GPIO16", "GPIO17";
+						pins = "GPIO16", "GPIO17";
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c1_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO16", "GPIO17";
+						pins = "GPIO16", "GPIO17";
 						ste,config = <&slpm_in_pu>;
 					};
 				};
@@ -133,14 +133,14 @@
 
 				i2c2_default_mode: i2c_default {
 					default_cfg1 {
-						ste,pins = "GPIO10", "GPIO11";
+						pins = "GPIO10", "GPIO11";
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c2_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO11", "GPIO11";
+						pins = "GPIO11", "GPIO11";
 						ste,config = <&slpm_in_pu>;
 					};
 				};
@@ -156,14 +156,14 @@
 
 				i2c4_default_mode: i2c_default {
 					default_cfg1 {
-						ste,pins = "GPIO122", "GPIO123";
+						pins = "GPIO122", "GPIO123";
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c4_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO122", "GPIO123";
+						pins = "GPIO122", "GPIO123";
 						ste,config = <&slpm_in_pu>;
 					};
 				};
@@ -179,14 +179,14 @@
 
 				i2c5_default_mode: i2c_default {
 					default_cfg1 {
-						ste,pins = "GPIO118", "GPIO119";
+						pins = "GPIO118", "GPIO119";
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c5_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO118", "GPIO119";
+						pins = "GPIO118", "GPIO119";
 						ste,config = <&slpm_in_pu>;
 					};
 				};
diff --git a/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi b/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
index 61aa87138927..5c5cea232743 100644
--- a/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
+++ b/arch/arm/boot/dts/ste-href-family-pinctrl.dtsi
@@ -22,29 +22,29 @@
 						groups = "u0_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO0_AJ5", "GPIO2_AH4"; /* CTS+RXD */
+						pins = "GPIO0_AJ5", "GPIO2_AH4"; /* CTS+RXD */
 						ste,config = <&in_pu>;
 					};
 
 					default_cfg2 {
-						ste,pins = "GPIO1_AJ3", "GPIO3_AH3"; /* RTS+TXD */
+						pins = "GPIO1_AJ3", "GPIO3_AH3"; /* RTS+TXD */
 						ste,config = <&out_hi>;
 					};
 				};
 
 				uart0_sleep_mode: uart0_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO0_AJ5", "GPIO2_AH4"; /* CTS+RXD */
+						pins = "GPIO0_AJ5", "GPIO2_AH4"; /* CTS+RXD */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 
 					sleep_cfg2 {
-						ste,pins = "GPIO1_AJ3"; /* RTS */
+						pins = "GPIO1_AJ3"; /* RTS */
 						ste,config = <&slpm_out_hi_wkup_pdis>;
 					};
 
 					sleep_cfg3 {
-						ste,pins = "GPIO3_AH3"; /* TXD */
+						pins = "GPIO3_AH3"; /* TXD */
 						ste,config = <&slpm_out_wkup_pdis>;
 					};
 				};
@@ -57,24 +57,24 @@
 						groups = "u1rxtx_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO4_AH6"; /* RXD */
+						pins = "GPIO4_AH6"; /* RXD */
 						ste,config = <&in_pu>;
 					};
 
 					default_cfg2 {
-						ste,pins = "GPIO5_AG6"; /* TXD */
+						pins = "GPIO5_AG6"; /* TXD */
 						ste,config = <&out_hi>;
 					};
 				};
 
 				uart1_sleep_mode: uart1_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO4_AH6"; /* RXD */
+						pins = "GPIO4_AH6"; /* RXD */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 
 					sleep_cfg2 {
-						ste,pins = "GPIO5_AG6"; /* TXD */
+						pins = "GPIO5_AG6"; /* TXD */
 						ste,config = <&slpm_out_wkup_pdis>;
 					};
 				};
@@ -87,24 +87,24 @@
 						groups = "u2rxtx_c_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO29_W2"; /* RXD */
+						pins = "GPIO29_W2"; /* RXD */
 						ste,config = <&in_pu>;
 					};
 
 					default_cfg2 {
-						ste,pins = "GPIO30_W3"; /* TXD */
+						pins = "GPIO30_W3"; /* TXD */
 						ste,config = <&out_hi>;
 					};
 				};
 
 				uart2_sleep_mode: uart2_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO29_W2"; /* RXD */
+						pins = "GPIO29_W2"; /* RXD */
 						ste,config = <&in_wkup_pdis>;
 					};
 
 					sleep_cfg2 {
-						ste,pins = "GPIO30_W3"; /* TXD */
+						pins = "GPIO30_W3"; /* TXD */
 						ste,config = <&out_wkup_pdis>;
 					};
 				};
@@ -118,14 +118,14 @@
 						groups = "i2c0_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO147_C15", "GPIO148_B16"; /* SDA/SCL */
+						pins = "GPIO147_C15", "GPIO148_B16"; /* SDA/SCL */
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c0_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO147_C15", "GPIO148_B16"; /* SDA/SCL */
+						pins = "GPIO147_C15", "GPIO148_B16"; /* SDA/SCL */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 				};
@@ -138,14 +138,14 @@
 						groups = "i2c1_b_2";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO16_AD3", "GPIO17_AD4"; /* SDA/SCL */
+						pins = "GPIO16_AD3", "GPIO17_AD4"; /* SDA/SCL */
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c1_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO16_AD3", "GPIO17_AD4"; /* SDA/SCL */
+						pins = "GPIO16_AD3", "GPIO17_AD4"; /* SDA/SCL */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 				};
@@ -158,14 +158,14 @@
 						groups = "i2c2_b_2";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO10_AF5", "GPIO11_AG4"; /* SDA/SCL */
+						pins = "GPIO10_AF5", "GPIO11_AG4"; /* SDA/SCL */
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c2_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO10_AF5", "GPIO11_AG4"; /* SDA/SCL */
+						pins = "GPIO10_AF5", "GPIO11_AG4"; /* SDA/SCL */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 				};
@@ -178,14 +178,14 @@
 						groups = "i2c3_c_2";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO229_AG7", "GPIO230_AF7"; /* SDA/SCL */
+						pins = "GPIO229_AG7", "GPIO230_AF7"; /* SDA/SCL */
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c3_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO229_AG7", "GPIO230_AF7"; /* SDA/SCL */
+						pins = "GPIO229_AG7", "GPIO230_AF7"; /* SDA/SCL */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 				};
@@ -202,14 +202,14 @@
 						groups = "i2c4_b_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO4_AH6", "GPIO5_AG6"; /* SDA/SCL */
+						pins = "GPIO4_AH6", "GPIO5_AG6"; /* SDA/SCL */
 						ste,config = <&in_pu>;
 					};
 				};
 
 				i2c4_sleep_mode: i2c_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO4_AH6", "GPIO5_AG6"; /* SDA/SCL */
+						pins = "GPIO4_AH6", "GPIO5_AG6"; /* SDA/SCL */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 				};
@@ -223,15 +223,15 @@
 						groups = "spi2_oc1_2";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO216_AG12"; /* FRM */
+						pins = "GPIO216_AG12"; /* FRM */
 						ste,config = <&gpio_out_hi>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO218_AH11"; /* RXD */
+						pins = "GPIO218_AH11"; /* RXD */
 						ste,config = <&in_pd>;
 					};
 					default_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO215_AH13", /* TXD */
 						"GPIO217_AH12"; /* CLK */
 						ste,config = <&out_lo>;
@@ -245,32 +245,32 @@
 					 * as we do not state any muxing.
 					 */
 					idle_cfg1 {
-						ste,pins = "GPIO218_AH11"; /* RXD */
+						pins = "GPIO218_AH11"; /* RXD */
 						ste,config = <&slpm_in_pdis>;
 					};
 					idle_cfg2 {
-						ste,pins = "GPIO215_AH13"; /* TXD */
+						pins = "GPIO215_AH13"; /* TXD */
 						ste,config = <&slpm_out_lo_pdis>;
 					};
 					idle_cfg3 {
-						ste,pins = "GPIO217_AH12"; /* CLK */
+						pins = "GPIO217_AH12"; /* CLK */
 						ste,config = <&slpm_pdis>;
 					};
 				};
 
 				spi2_sleep_mode: spi_sleep {
 					sleep_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO216_AG12", /* FRM */
 						"GPIO218_AH11"; /* RXD */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 					sleep_cfg2 {
-						ste,pins = "GPIO215_AH13"; /* TXD */
+						pins = "GPIO215_AH13"; /* TXD */
 						ste,config = <&slpm_out_lo_wkup_pdis>;
 					};
 					sleep_cfg3 {
-						ste,pins = "GPIO217_AH12"; /* CLK */
+						pins = "GPIO217_AH12"; /* CLK */
 						ste,config = <&slpm_wkup_pdis>;
 					};
 				};
@@ -285,22 +285,22 @@
 						groups = "mc0_a_1";
 					};
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO18_AC2", /* CMDDIR */
 						"GPIO19_AC1", /* DAT0DIR */
 						"GPIO20_AB4"; /* DAT2DIR */
 						ste,config = <&out_hi>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO22_AA3"; /* FBCLK */
+						pins = "GPIO22_AA3"; /* FBCLK */
 						ste,config = <&in_nopull>;
 					};
 					default_cfg3 {
-						ste,pins = "GPIO23_AA4"; /* CLK */
+						pins = "GPIO23_AA4"; /* CLK */
 						ste,config = <&out_lo>;
 					};
 					default_cfg4 {
-						ste,pins =
+						pins =
 						"GPIO24_AB2", /* CMD */
 						"GPIO25_Y4", /* DAT0 */
 						"GPIO26_Y2", /* DAT1 */
@@ -312,14 +312,14 @@
 
 				sdi0_sleep_mode: sdi0_sleep {
 					sleep_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO18_AC2", /* CMDDIR */
 						"GPIO19_AC1", /* DAT0DIR */
 						"GPIO20_AB4"; /* DAT2DIR */
 						ste,config = <&slpm_out_hi_wkup_pdis>;
 					};
 					sleep_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO22_AA3", /* FBCLK */
 						"GPIO24_AB2", /* CMD */
 						"GPIO25_Y4", /* DAT0 */
@@ -329,7 +329,7 @@
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 					sleep_cfg3 {
-						ste,pins = "GPIO23_AA4"; /* CLK */
+						pins = "GPIO23_AA4"; /* CLK */
 						ste,config = <&slpm_out_lo_wkup_pdis>;
 					};
 				};
@@ -343,15 +343,15 @@
 						groups = "mc1_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO208_AH16"; /* CLK */
+						pins = "GPIO208_AH16"; /* CLK */
 						ste,config = <&out_lo>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO209_AG15"; /* FBCLK */
+						pins = "GPIO209_AG15"; /* FBCLK */
 						ste,config = <&in_nopull>;
 					};
 					default_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO210_AJ15", /* CMD */
 						"GPIO211_AG14", /* DAT0 */
 						"GPIO212_AF13", /* DAT1 */
@@ -363,11 +363,11 @@
 
 				sdi1_sleep_mode: sdi1_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO208_AH16"; /* CLK */
+						pins = "GPIO208_AH16"; /* CLK */
 						ste,config = <&slpm_out_lo_wkup_pdis>;
 					};
 					sleep_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO209_AG15", /* FBCLK */
 						"GPIO210_AJ15", /* CMD */
 						"GPIO211_AG14", /* DAT0 */
@@ -387,15 +387,15 @@
 						groups = "mc2_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO128_A5"; /* CLK */
+						pins = "GPIO128_A5"; /* CLK */
 						ste,config = <&out_lo>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO130_C8"; /* FBCLK */
+						pins = "GPIO130_C8"; /* FBCLK */
 						ste,config = <&in_nopull>;
 					};
 					default_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO129_B4", /* CMD */
 						"GPIO131_A12", /* DAT0 */
 						"GPIO132_C10", /* DAT1 */
@@ -411,17 +411,17 @@
 
 				sdi2_sleep_mode: sdi2_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO128_A5"; /* CLK */
+						pins = "GPIO128_A5"; /* CLK */
 						ste,config = <&out_lo_wkup_pdis>;
 					};
 					sleep_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO130_C8", /* FBCLK */
 						"GPIO129_B4"; /* CMD */
 						ste,config = <&in_wkup_pdis_en>;
 					};
 					sleep_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO131_A12", /* DAT0 */
 						"GPIO132_C10", /* DAT1 */
 						"GPIO133_B10", /* DAT2 */
@@ -443,15 +443,15 @@
 						groups = "mc4_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO203_AE23"; /* CLK */
+						pins = "GPIO203_AE23"; /* CLK */
 						ste,config = <&out_lo>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO202_AF25"; /* FBCLK */
+						pins = "GPIO202_AF25"; /* FBCLK */
 						ste,config = <&in_nopull>;
 					};
 					default_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO201_AF24", /* CMD */
 						"GPIO200_AH26", /* DAT0 */
 						"GPIO199_AH23", /* DAT1 */
@@ -467,11 +467,11 @@
 
 				sdi4_sleep_mode: sdi4_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO203_AE23"; /* CLK */
+						pins = "GPIO203_AE23"; /* CLK */
 						ste,config = <&out_lo_wkup_pdis>;
 					};
 					sleep_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO202_AF25", /* FBCLK */
 						"GPIO201_AF24", /* CMD */
 						"GPIO200_AH26", /* DAT0 */
@@ -498,7 +498,7 @@
 						groups = "msp0txrx_a_1", "msp0tfstck_a_1";
 					};
 					default_msp0_cfg {
-						ste,pins =
+						pins =
 						"GPIO12_AC4", /* TXD */
 						"GPIO15_AC3", /* RXD */
 						"GPIO13_AF3", /* TFS */
@@ -515,11 +515,11 @@
 						groups = "msp1txrx_a_1", "msp1_a_1";
 					};
 					default_cfg1 {
-						ste,pins = "GPIO33_AF2";
+						pins = "GPIO33_AF2";
 						ste,config = <&out_lo>;
 					};
 					default_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO34_AE1",
 						"GPIO35_AE2",
 						"GPIO36_AG2";
@@ -537,14 +537,14 @@
 						groups = "msp2_a_1";
 					};
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO193_AH27", /* TXD */
 						"GPIO194_AF27", /* TCK */
 						"GPIO195_AG28"; /* TFS */
 						ste,config = <&in_pd>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO196_AG26"; /* RXD */
+						pins = "GPIO196_AG26"; /* RXD */
 						ste,config = <&out_lo>;
 					};
 				};
@@ -558,7 +558,7 @@
 						groups = "usb_a_1";
 					};
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO256_AF28", /* NXT */
 						"GPIO258_AD29", /* XCLK */
 						"GPIO259_AC29", /* DIR */
@@ -573,25 +573,25 @@
 						ste,config = <&in_nopull>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO257_AE29"; /* STP */
+						pins = "GPIO257_AE29"; /* STP */
 						ste,config = <&out_hi>;
 					};
 				};
 
 				musb_sleep_mode: musb_sleep {
 					sleep_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO256_AF28", /* NXT */
 						"GPIO258_AD29", /* XCLK */
 						"GPIO259_AC29"; /* DIR */
 						ste,config = <&slpm_wkup_pdis_en>;
 					};
 					sleep_cfg2 {
-						ste,pins = "GPIO257_AE29"; /* STP */
+						pins = "GPIO257_AE29"; /* STP */
 						ste,config = <&slpm_out_hi_wkup_pdis>;
 					};
 					sleep_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO260_AD28", /* DAT7 */
 						"GPIO261_AD26", /* DAT6 */
 						"GPIO262_AE26", /* DAT5 */
@@ -618,7 +618,7 @@
 						"lcdvsi1_a_1"; /* VSI1 for HDMI */
 					};
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO68_E1", /* VSI0 */
 						"GPIO69_E2"; /* VSI1 */
 						ste,config = <&in_pu>;
@@ -626,7 +626,7 @@
 				};
 				lcd_sleep_mode: lcd_sleep {
 					sleep_cfg1 {
-						ste,pins = "GPIO69_E2"; /* VSI1 */
+						pins = "GPIO69_E2"; /* VSI1 */
 						ste,config = <&slpm_in_wkup_pdis>;
 					};
 				};
@@ -640,7 +640,7 @@
 						groups = "kp_a_2";
 					};
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO153_B17", /* I7 */
 						"GPIO154_C16", /* I6 */
 						"GPIO155_C19", /* I5 */
@@ -652,7 +652,7 @@
 						ste,config = <&in_pd>;
 					};
 					default_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO157_A18", /* O7 */
 						"GPIO158_C18", /* O6 */
 						"GPIO159_B19", /* O5 */
@@ -666,7 +666,7 @@
 				};
 				ske_kpa2_sleep_mode: ske_kpa2_sleep {
 					sleep_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO153_B17", /* I7 */
 						"GPIO154_C16", /* I6 */
 						"GPIO155_C19", /* I5 */
@@ -678,7 +678,7 @@
 						ste,config = <&slpm_in_pu_wkup_pdis_en>;
 					};
 					sleep_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO157_A18", /* O7 */
 						"GPIO158_C18", /* O6 */
 						"GPIO159_B19", /* O5 */
@@ -700,7 +700,7 @@
 						groups = "kp_a_1", "kp_oc1_1";
 					};
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO91_B6", /* KP_O0 */
 						"GPIO90_A3", /* KP_O1 */
 						"GPIO87_B3", /* KP_O2 */
@@ -710,7 +710,7 @@
 						ste,config = <&out_lo>;
 					};
 					default_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO93_B7", /* KP_I0 */
 						"GPIO92_D6", /* KP_I1 */
 						"GPIO89_E6", /* KP_I2 */
@@ -729,13 +729,13 @@
 					 * These are plain GPIO pins used by WLAN
 					 */
 					default_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO226_AF8", /* WLAN_PMU_EN */
 						"GPIO85_D5"; /* WLAN_ENA */
 						ste,config = <&gpio_out_lo>;
 					};
 					default_cfg2 {
-						ste,pins = "GPIO4_AH6"; /* WLAN_IRQ on UART1 */
+						pins = "GPIO4_AH6"; /* WLAN_IRQ on UART1 */
 						ste,config = <&gpio_in_pu>;
 					};
 				};
diff --git a/arch/arm/boot/dts/ste-href-stuib.dtsi b/arch/arm/boot/dts/ste-href-stuib.dtsi
index 84d7c5d883f2..7d4f8184c522 100644
--- a/arch/arm/boot/dts/ste-href-stuib.dtsi
+++ b/arch/arm/boot/dts/ste-href-stuib.dtsi
@@ -103,7 +103,7 @@
 			prox {
 				prox_stuib_mode: prox_stuib {
 					stuib_cfg {
-						ste,pins = "GPIO217_AH12";
+						pins = "GPIO217_AH12";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -111,7 +111,7 @@
 			hall {
 				hall_stuib_mode: stuib_tvk {
 					stuib_cfg {
-						ste,pins = "GPIO145_C13";
+						pins = "GPIO145_C13";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
diff --git a/arch/arm/boot/dts/ste-href-tvk1281618.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
index 18b65d1b14f2..062c6aae3afa 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618.dtsi
@@ -130,7 +130,7 @@
 			tc35893 {
 				tc35893_tvk_mode: tc35893_tvk {
 					tvk_cfg {
-						ste,pins = "GPIO218_AH11";
+						pins = "GPIO218_AH11";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -138,7 +138,7 @@
 			prox {
 				prox_tvk_mode: prox_tvk {
 					tvk_cfg {
-						ste,pins = "GPIO217_AH12";
+						pins = "GPIO217_AH12";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -146,7 +146,7 @@
 			hall {
 				hall_tvk_mode: hall_tvk {
 					tvk_cfg {
-						ste,pins = "GPIO145_C13";
+						pins = "GPIO145_C13";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -155,7 +155,7 @@
 				accel_tvk_mode: accel_tvk {
 					/* Accelerometer interrupt lines 1 & 2 */
 					tvk_cfg {
-						ste,pins = "GPIO82_C1", "GPIO83_D3";
+						pins = "GPIO82_C1", "GPIO83_D3";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -164,11 +164,11 @@
 				magneto_tvk_mode: magneto_tvk {
 					/* Magnetometer uses GPIO 31 and 32, pull these up/down respectively */
 					tvk_cfg1 {
-						ste,pins = "GPIO31_V3";
+						pins = "GPIO31_V3";
 						ste,config = <&gpio_in_pu>;
 					};
 					tvk_cfg2 {
-						ste,pins = "GPIO32_V2";
+						pins = "GPIO32_V2";
 						ste,config = <&gpio_in_pd>;
 					};
 				};
diff --git a/arch/arm/boot/dts/ste-hrefprev60.dtsi b/arch/arm/boot/dts/ste-hrefprev60.dtsi
index 5d8b7f8ced1b..7f3975b58d16 100644
--- a/arch/arm/boot/dts/ste-hrefprev60.dtsi
+++ b/arch/arm/boot/dts/ste-hrefprev60.dtsi
@@ -83,7 +83,7 @@
 						groups = "ssp0_a_1";
 					};
 					hrefprev60_cfg1 {
-						ste,pins = "GPIO145_C13"; /* RXD */
+						pins = "GPIO145_C13"; /* RXD */
 						ste,config = <&in_pd>;
 					};
 
@@ -97,7 +97,7 @@
 						groups = "mc0dat31dir_a_1";
 					};
 					hrefprev60_cfg1 {
-						ste,pins = "GPIO21_AB3"; /* DAT31DIR */
+						pins = "GPIO21_AB3"; /* DAT31DIR */
 						ste,config = <&out_hi>;
 					};
 
@@ -106,7 +106,7 @@
 			tc35892 {
 				tc35892_hrefprev60_mode: tc35892_hrefprev60 {
 					hrefprev60_cfg {
-						ste,pins = "GPIO217_AH12";
+						pins = "GPIO217_AH12";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -118,7 +118,7 @@
 						groups = "ipgpio0_c_1", "ipgpio1_c_1";
 					};
 					hrefprev60_cfg1 {
-						ste,pins = "GPIO6_AF6", "GPIO7_AG5";
+						pins = "GPIO6_AF6", "GPIO7_AG5";
 						ste,config = <&in_pu>;
 					};
 				 };
diff --git a/arch/arm/boot/dts/ste-hrefv60plus.dtsi b/arch/arm/boot/dts/ste-hrefv60plus.dtsi
index 2b4104ef07de..a4bc9e77d640 100644
--- a/arch/arm/boot/dts/ste-hrefv60plus.dtsi
+++ b/arch/arm/boot/dts/ste-hrefv60plus.dtsi
@@ -49,7 +49,7 @@
 				/* SD card detect GPIO pin, extend default state */
 				sdi0_default_mode: sdi0_default {
 					default_hrefv60_cfg1 {
-						ste,pins = "GPIO95_E8";
+						pins = "GPIO95_E8";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -68,15 +68,15 @@
 						groups = "ipgpio0_c_1", "ipgpio1_c_1", "ipgpio4_c_1";
 					};
 					hrefv60_cfg1 {
-						ste,pins = "GPIO6_AF6", "GPIO7_AG5";
+						pins = "GPIO6_AF6", "GPIO7_AG5";
 						ste,config = <&in_pu>;
 					};
 					hrefv60_cfg2 {
-						ste,pins = "GPIO21_AB3";
+						pins = "GPIO21_AB3";
 						ste,config = <&gpio_out_lo>;
 					};
 					hrefv60_cfg3 {
-						ste,pins = "GPIO64_F3";
+						pins = "GPIO64_F3";
 						ste,config = <&out_lo>;
 					};
 				};
@@ -89,7 +89,7 @@
 				 */
 				etm_hrefv60_mode: etm_hrefv60 {
 					hrefv60_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO70_G5",
 						"GPIO71_G4",
 						"GPIO72_H4",
@@ -103,11 +103,11 @@
 				nahj_hrefv60_mode: nahj_hrefv60 {
 					/* NAHJ CTRL on GPIO76 to low, CTRL_INV on GPIO216 to high */
 					hrefv60_cfg1 {
-						ste,pins = "GPIO76_J2";
+						pins = "GPIO76_J2";
 						ste,config = <&gpio_out_lo>;
 					};
 					hrefv60_cfg2 {
-						ste,pins = "GPIO216_AG12";
+						pins = "GPIO216_AG12";
 						ste,config = <&gpio_out_hi>;
 					};
 				 };
@@ -116,13 +116,13 @@
 				nfc_hrefv60_mode: nfc_hrefv60 {
 					/* NFC ENA and RESET to low, pulldown IRQ line */
 					hrefv60_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO77_H1", /* NFC_ENA */
 						"GPIO142_C11"; /* NFC_RESET */
 						ste,config = <&gpio_out_lo>;
 					};
 					hrefv60_cfg2 {
-						ste,pins = "GPIO144_B13"; /* NFC_IRQ */
+						pins = "GPIO144_B13"; /* NFC_IRQ */
 						ste,config = <&gpio_in_pd>;
 					};
 				 };
@@ -130,11 +130,11 @@
 			force {
 				force_hrefv60_mode: force_hrefv60 {
 					hrefv60_cfg1 {
-						ste,pins = "GPIO91_B6"; /* FORCE_SENSING_INT */
+						pins = "GPIO91_B6"; /* FORCE_SENSING_INT */
 						ste,config = <&gpio_in_pu>;
 					};
 					hrefv60_cfg2 {
-						ste,pins =
+						pins =
 						"GPIO92_D6", /* FORCE_SENSING_RST */
 						"GPIO97_D9"; /* FORCE_SENSING_WU */
 						ste,config = <&gpio_out_lo>;
@@ -144,7 +144,7 @@
 			dipro {
 				dipro_hrefv60_mode: dipro_hrefv60 {
 					hrefv60_cfg1 {
-						ste,pins = "GPIO139_C9"; /* DIPRO_INT */
+						pins = "GPIO139_C9"; /* DIPRO_INT */
 						ste,config = <&gpio_in_pu>;
 					};
 				 };
@@ -153,7 +153,7 @@
 				vaudio_hf_hrefv60_mode: vaudio_hf_hrefv60 {
 					/* Audio Amplifier HF enable GPIO */
 					hrefv60_cfg1 {
-						ste,pins = "GPIO149_B14"; /* VAUDIO_HF_EN, enable MAX8968 */
+						pins = "GPIO149_B14"; /* VAUDIO_HF_EN, enable MAX8968 */
 						ste,config = <&gpio_out_hi>;
 					};
 				 };
@@ -165,7 +165,7 @@
 					 * pull low to reset state
 					 */
 					hrefv60_cfg1 {
-						ste,pins = "GPIO171_D23"; /* GBF_ENA_RESET */
+						pins = "GPIO171_D23"; /* GBF_ENA_RESET */
 						ste,config = <&gpio_out_lo>;
 					};
 				 };
@@ -174,7 +174,7 @@
 				hdtv_hrefv60_mode: hdtv_hrefv60 {
 					/* MSP : HDTV INTERFACE GPIO line */
 					hrefv60_cfg1 {
-						ste,pins = "GPIO192_AJ27";
+						pins = "GPIO192_AJ27";
 						ste,config = <&gpio_in_pd>;
 					};
 				 };
@@ -187,11 +187,11 @@
 					 * reset signals low.
 					 */
 					hrefv60_cfg1 {
-						ste,pins = "GPIO143_D12", "GPIO146_D13";
+						pins = "GPIO143_D12", "GPIO146_D13";
 						ste,config = <&gpio_out_lo>;
 					};
 					hrefv60_cfg2 {
-						ste,pins = "GPIO67_G2";
+						pins = "GPIO67_G2";
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -204,11 +204,11 @@
 					 * Drive DISP1 reset high (not reset), driver DISP2 reset low (reset)
 					 */
 					hrefv60_cfg1 {
-						ste,pins ="GPIO65_F1";
+						pins ="GPIO65_F1";
 						ste,config = <&gpio_out_hi>;
 					};
 					hrefv60_cfg2 {
-						ste,pins ="GPIO66_G3";
+						pins ="GPIO66_G3";
 						ste,config = <&gpio_out_lo>;
 					};
 				};
diff --git a/arch/arm/boot/dts/ste-nomadik-s8815.dts b/arch/arm/boot/dts/ste-nomadik-s8815.dts
index 90d8b6c7a205..cc81ae7450a9 100644
--- a/arch/arm/boot/dts/ste-nomadik-s8815.dts
+++ b/arch/arm/boot/dts/ste-nomadik-s8815.dts
@@ -37,12 +37,12 @@
 			cd_default_mode: cd_default {
 				cd_default_cfg1 {
 					/* CD input GPIO */
-					ste,pins = "GPIO111_H21";
+					pins = "GPIO111_H21";
 					ste,input = <0>;
 				};
 				cd_default_cfg2 {
 					/* CD GPIO biasing */
-					ste,pins = "GPIO112_J21";
+					pins = "GPIO112_J21";
 					ste,output = <0>;
 				};
 			};
@@ -50,7 +50,7 @@
 		user-led {
 			user_led_default_mode: user_led_default {
 				user_led_default_cfg {
-					ste,pins = "GPIO2_C5";
+					pins = "GPIO2_C5";
 					ste,output = <1>;
 				};
 			};
@@ -58,7 +58,7 @@
 		user-button {
 			user_button_default_mode: user_button_default {
 				user_button_default_cfg {
-					ste,pins = "GPIO3_A4";
+					pins = "GPIO3_A4";
 					ste,input = <0>;
 				};
 			};
diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index 7cedb5aba9a9..c8b4a93180f8 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -123,18 +123,18 @@
 			mmcsd_default_mode: mmcsd_default {
 				mmcsd_default_cfg1 {
 					/* MCCLK */
-					ste,pins = "GPIO8_B10";
+					pins = "GPIO8_B10";
 					ste,output = <0>;
 				};
 				mmcsd_default_cfg2 {
 					/* MCCMDDIR, MCDAT0DIR, MCDAT31DIR */
-					ste,pins = "GPIO10_C11", "GPIO15_A12",
+					pins = "GPIO10_C11", "GPIO15_A12",
 					"GPIO16_C13";
 					ste,output = <1>;
 				};
 				mmcsd_default_cfg3 {
 					/* MCCMD, MCDAT3-0, MCMSFBCLK */
-					ste,pins = "GPIO9_A10", "GPIO11_B11",
+					pins = "GPIO9_A10", "GPIO11_B11",
 					"GPIO12_A11", "GPIO13_C12",
 					"GPIO14_B12", "GPIO24_C15";
 					ste,input = <1>;
@@ -150,7 +150,7 @@
 			};
 			i2c0_default_mode: i2c0_default {
 				i2c0_default_cfg {
-					ste,pins = "GPIO62_D3", "GPIO63_D2";
+					pins = "GPIO62_D3", "GPIO63_D2";
 					ste,input = <0>;
 				};
 			};
@@ -164,7 +164,7 @@
 			};
 			i2c1_default_mode: i2c1_default {
 				i2c1_default_cfg {
-					ste,pins = "GPIO53_L4", "GPIO54_L3";
+					pins = "GPIO53_L4", "GPIO54_L3";
 					ste,input = <0>;
 				};
 			};
@@ -172,7 +172,7 @@
 		i2c2 {
 			i2c2_default_mode: i2c2_default {
 				i2c2_default_cfg {
-					ste,pins = "GPIO73_C21", "GPIO74_C20";
+					pins = "GPIO73_C21", "GPIO74_C20";
 					ste,input = <0>;
 				};
 			};
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index e628258c6b1a..68045fa8bf2d 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -410,12 +410,12 @@
 					};
 					/* LAN IRQ pin */
 					snowball_cfg1 {
-						ste,pins = "GPIO140_B11";
+						pins = "GPIO140_B11";
 						ste,config = <&in_nopull>;
 					};
 					/* LAN reset pin */
 					snowball_cfg2 {
-						ste,pins = "GPIO141_C12";
+						pins = "GPIO141_C12";
 						ste,config = <&gpio_out_hi>;
 					};
 
@@ -428,7 +428,7 @@
 						groups = "mc0dat31dir_a_1";
 					};
 					snowball_cfg1 {
-						ste,pins = "GPIO21_AB3"; /* DAT31DIR */
+						pins = "GPIO21_AB3"; /* DAT31DIR */
 						ste,config = <&out_hi>;
 					};
 
@@ -441,15 +441,15 @@
 						groups = "ssp0_a_1";
 					};
 					snowball_cfg1 {
-						ste,pins = "GPIO144_B13"; /* FRM */
+						pins = "GPIO144_B13"; /* FRM */
 						ste,config = <&gpio_out_hi>;
 					};
 					snowball_cfg2 {
-						ste,pins = "GPIO145_C13"; /* RXD */
+						pins = "GPIO145_C13"; /* RXD */
 						ste,config = <&in_pd>;
 					};
 					snowball_cfg3 {
-						ste,pins =
+						pins =
 						"GPIO146_D13", /* TXD */
 						"GPIO143_D12"; /* CLK */
 						ste,config = <&out_lo>;
@@ -460,7 +460,7 @@
 			gpio_led {
 				gpioled_snowball_mode: gpioled_default {
 					snowball_cfg1 {
-						ste,pins = "GPIO142_C11";
+						pins = "GPIO142_C11";
 						ste,config = <&gpio_out_hi>;
 					};
 
@@ -470,7 +470,7 @@
 				accel_snowball_mode: accel_snowball {
 					/* Accelerometer lines */
 					snowball_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO163_C20", /* ACCEL_IRQ1 */
 						"GPIO164_B21"; /* ACCEL_IRQ2 */
 						ste,config = <&gpio_in_pu>;
@@ -480,7 +480,7 @@
 			magnetometer {
 				magneto_snowball_mode: magneto_snowball {
 					snowball_cfg1 {
-						ste,pins = "GPIO165_C21"; /* MAG_DRDY */
+						pins = "GPIO165_C21"; /* MAG_DRDY */
 						ste,config = <&gpio_in_pu>;
 					};
 				};
@@ -492,7 +492,7 @@
 					 * pull low to reset state
 					 */
 					snowball_cfg1 {
-						ste,pins = "GPIO171_D23"; /* GBF_ENA_RESET */
+						pins = "GPIO171_D23"; /* GBF_ENA_RESET */
 						ste,config = <&gpio_out_lo>;
 					};
 				 };
@@ -504,13 +504,13 @@
 					 * These are plain GPIO pins used by WLAN
 					 */
 					snowball_cfg1 {
-						ste,pins =
+						pins =
 						"GPIO161_D21", /* WLAN_PMU_EN */
 						"GPIO215_AH13"; /* WLAN_ENA */
 						ste,config = <&gpio_out_lo>;
 					};
 					snowball_cfg2 {
-						ste,pins = "GPIO216_AG12"; /* WLAN_IRQ */
+						pins = "GPIO216_AG12"; /* WLAN_IRQ */
 						ste,config = <&gpio_in_pu>;
 					};
 				};
diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index f7f29bd6c0ce..3b7c733de489 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1552,7 +1552,7 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		const char *gpio_name;
 		const char *pin;
 
-		ret = of_property_count_strings(np, "ste,pins");
+		ret = of_property_count_strings(np, "pins");
 		if (ret < 0)
 			goto exit;
 		ret = pinctrl_utils_reserve_map(pctldev, map,
@@ -1561,7 +1561,7 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (ret < 0)
 			goto exit;
 
-		of_property_for_each_string(np, "ste,pins", prop, pin) {
+		of_property_for_each_string(np, "pins", prop, pin) {
 			gpio_name = nmk_find_pin_name(pctldev, pin);
 
 			ret = nmk_dt_add_map_configs(map, reserved_maps,
-- 
1.9.3

