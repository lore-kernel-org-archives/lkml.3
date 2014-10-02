Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaJBIle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:41:34 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63484 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaJBIko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:44 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/7] pinctrl: abx500: update device tree bindings
Date: Thu,  2 Oct 2014 10:40:19 +0200
Message-Id: <1412239220-22495-7-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After force converting the ABx500 bindings in the driver and
device tree sources, also update the binding documentation to
state that we are now using standard bindings.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../devicetree/bindings/pinctrl/ste,abx500.txt     | 184 +++++++++------------
 1 file changed, 75 insertions(+), 109 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt b/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
index e3865e136067..87697420439e 100644
--- a/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
+++ b/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
@@ -8,42 +8,8 @@ Please refer to pinctrl-bindings.txt in this directory for details of the
 common pinctrl bindings used by client devices, including the meaning of the
 phrase "pin configuration node".
 
-ST Ericsson's pin configuration nodes act as a container for an arbitrary number of
-subnodes. Each of these subnodes represents some desired configuration for a
-pin, a group, or a list of pins or groups. This configuration can include the
-mux function to select on those pin(s)/group(s), and various pin configuration
-parameters, such as input, output, pull up, pull down...
-
-The name of each subnode is not important; all subnodes should be enumerated
-and processed purely based on their content.
-
-Required subnode-properties:
-- ste,pins : An array of strings. Each string contains the name of a pin or
-    group.
-
-Optional subnode-properties:
-- ste,function: A string containing the name of the function to mux to the
-  pin or group.
-
-- generic pin configuration option to use. Example :
-
-	default_cfg {
-		ste,pins = "GPIO1";
-		bias-disable;
-	};
-
-- ste,config: Handle of pin configuration node containing the generic
-  pinconfig options to use, as described in pinctrl-bindings.txt in
-  this directory. Example :
-
-	pcfg_bias_disable: pcfg_bias_disable {
-		bias-disable;
-	};
-
-	default_cfg {
-		ste,pins = "GPIO1";
-		ste.config = <&pcfg_bias_disable>;
-	};
+ST Ericsson's pin configuration nodes use the generic pin multiplexing
+and pin configuration bindings, see pinctrl-bindings.txt
 
 Example board file extract:
 
@@ -54,11 +20,11 @@ Example board file extract:
 	sysclkreq2 {
 		sysclkreq2_default_mode: sysclkreq2_default {
 			default_mux {
-				ste,function = "sysclkreq";
-				ste,pins = "sysclkreq2_d_1";
+				function = "sysclkreq";
+				groups = "sysclkreq2_d_1";
 			};
 			default_cfg {
-				ste,pins = "GPIO1";
+				pins = "GPIO1";
 				bias-disable;
 			};
 		};
@@ -66,11 +32,11 @@ Example board file extract:
 	sysclkreq3 {
 		sysclkreq3_default_mode: sysclkreq3_default {
 			default_mux {
-				ste,function = "sysclkreq";
-				ste,pins = "sysclkreq3_d_1";
+				function = "sysclkreq";
+				groups = "sysclkreq3_d_1";
 			};
 			default_cfg {
-				ste,pins = "GPIO2";
+				pins = "GPIO2";
 				output-low;
 			};
 		};
@@ -78,11 +44,11 @@ Example board file extract:
 	gpio3 {
 		gpio3_default_mode: gpio3_default {
 			default_mux {
-				ste,function = "gpio";
-				ste,pins = "gpio3_a_1";
+				function = "gpio";
+				groups = "gpio3_a_1";
 			};
 			default_cfg {
-				ste,pins = "GPIO3";
+				pins = "GPIO3";
 				output-low;
 			};
 		};
@@ -90,11 +56,11 @@ Example board file extract:
 	sysclkreq6 {
 		sysclkreq6_default_mode: sysclkreq6_default {
 			default_mux {
-				ste,function = "sysclkreq";
-				ste,pins = "sysclkreq6_d_1";
+				function = "sysclkreq";
+				groups = "sysclkreq6_d_1";
 			};
 			default_cfg {
-				ste,pins = "GPIO4";
+				pins = "GPIO4";
 				bias-disable;
 			};
 		};
@@ -102,11 +68,11 @@ Example board file extract:
 	pwmout1 {
 		pwmout1_default_mode: pwmout1_default {
 			default_mux {
-				ste,function = "pwmout";
-				ste,pins = "pwmout1_d_1";
+				function = "pwmout";
+				groups = "pwmout1_d_1";
 			};
 			default_cfg {
-				ste,pins = "GPIO14";
+				pins = "GPIO14";
 				output-low;
 			};
 		};
@@ -114,11 +80,11 @@ Example board file extract:
 	pwmout2 {
 		pwmout2_default_mode: pwmout2_default {
 			pwmout2_default_mux {
-				ste,function = "pwmout";
-				ste,pins = "pwmout2_d_1";
+				function = "pwmout";
+				groups = "pwmout2_d_1";
 			};
 			pwmout2_default_cfg {
-				ste,pins = "GPIO15";
+				pins = "GPIO15";
 				output-low;
 			};
 		};
@@ -126,11 +92,11 @@ Example board file extract:
 	pwmout3 {
 		pwmout3_default_mode: pwmout3_default {
 			pwmout3_default_mux {
-				ste,function = "pwmout";
-				ste,pins = "pwmout3_d_1";
+				function = "pwmout";
+				groups = "pwmout3_d_1";
 			};
 			pwmout3_default_cfg {
-				ste,pins = "GPIO16";
+				pins = "GPIO16";
 				output-low;
 			};
 		};
@@ -139,15 +105,15 @@ Example board file extract:
 
 		adi1_default_mode: adi1_default {
 			adi1_default_mux {
-				ste,function = "adi1";
-				ste,pins = "adi1_d_1";
+				function = "adi1";
+				groups = "adi1_d_1";
 			};
 			adi1_default_cfg1 {
-				ste,pins = "GPIO17","GPIO19","GPIO20";
+				pins = "GPIO17","GPIO19","GPIO20";
 				bias-disable;
 			};
 			adi1_default_cfg2 {
-				ste,pins = "GPIO18";
+				pins = "GPIO18";
 				output-low;
 			};
 		};
@@ -155,15 +121,15 @@ Example board file extract:
 	dmic12 {
 		dmic12_default_mode: dmic12_default {
 			dmic12_default_mux {
-				ste,function = "dmic";
-				ste,pins = "dmic12_d_1";
+				function = "dmic";
+				groups = "dmic12_d_1";
 			};
 			dmic12_default_cfg1 {
-				ste,pins = "GPIO27";
+				pins = "GPIO27";
 				output-low;
 			};
 			dmic12_default_cfg2 {
-				ste,pins = "GPIO28";
+				pins = "GPIO28";
 				bias-disable;
 			};
 		};
@@ -171,15 +137,15 @@ Example board file extract:
 	dmic34 {
 		dmic34_default_mode: dmic34_default {
 			dmic34_default_mux {
-				ste,function = "dmic";
-				ste,pins = "dmic34_d_1";
+				function = "dmic";
+				groups = "dmic34_d_1";
 			};
 			dmic34_default_cfg1 {
-				ste,pins = "GPIO29";
+				pins = "GPIO29";
 				output-low;
 			};
 			dmic34_default_cfg2 {
-				ste,pins = "GPIO30";
+				pins = "GPIO30";
 				bias-disable;{
 
 			};
@@ -188,15 +154,15 @@ Example board file extract:
 	dmic56 {
 		dmic56_default_mode: dmic56_default {
 			dmic56_default_mux {
-				ste,function = "dmic";
-				ste,pins = "dmic56_d_1";
+				function = "dmic";
+				groups = "dmic56_d_1";
 			};
 			dmic56_default_cfg1 {
-				ste,pins = "GPIO31";
+				pins = "GPIO31";
 				output-low;
 			};
 			dmic56_default_cfg2 {
-				ste,pins = "GPIO32";
+				pins = "GPIO32";
 				bias-disable;
 			};
 		};
@@ -204,11 +170,11 @@ Example board file extract:
 	sysclkreq5 {
 		sysclkreq5_default_mode: sysclkreq5_default {
 			sysclkreq5_default_mux {
-				ste,function = "sysclkreq";
-				ste,pins = "sysclkreq5_d_1";
+				function = "sysclkreq";
+				groups = "sysclkreq5_d_1";
 			};
 			sysclkreq5_default_cfg {
-				ste,pins = "GPIO42";
+				pins = "GPIO42";
 				output-low;
 			};
 		};
@@ -216,11 +182,11 @@ Example board file extract:
 	batremn {
 		batremn_default_mode: batremn_default {
 			batremn_default_mux {
-				ste,function = "batremn";
-				ste,pins = "batremn_d_1";
+				function = "batremn";
+				groups = "batremn_d_1";
 			};
 			batremn_default_cfg {
-				ste,pins = "GPIO43";
+				pins = "GPIO43";
 				bias-disable;
 			};
 		};
@@ -228,11 +194,11 @@ Example board file extract:
 	service {
 		service_default_mode: service_default {
 			service_default_mux {
-				ste,function = "service";
-				ste,pins = "service_d_1";
+				function = "service";
+				groups = "service_d_1";
 			};
 			service_default_cfg {
-				ste,pins = "GPIO44";
+				pins = "GPIO44";
 				bias-disable;
 			};
 		};
@@ -240,13 +206,13 @@ Example board file extract:
 	pwrctrl0 {
 		pwrctrl0_default_mux: pwrctrl0_mux {
 			pwrctrl0_default_mux {
-				ste,function = "pwrctrl";
-				ste,pins = "pwrctrl0_d_1";
+				function = "pwrctrl";
+				groups = "pwrctrl0_d_1";
 			};
 		};
 		pwrctrl0_default_mode: pwrctrl0_default {
 			pwrctrl0_default_cfg {
-				ste,pins = "GPIO45";
+				pins = "GPIO45";
 				bias-disable;
 			};
 		};
@@ -254,13 +220,13 @@ Example board file extract:
 	pwrctrl1 {
 		pwrctrl1_default_mux: pwrctrl1_mux {
 			pwrctrl1_default_mux {
-				ste,function = "pwrctrl";
-				ste,pins = "pwrctrl1_d_1";
+				function = "pwrctrl";
+				groups = "pwrctrl1_d_1";
 			};
 		};
 		pwrctrl1_default_mode: pwrctrl1_default {
 			pwrctrl1_default_cfg {
-				ste,pins = "GPIO46";
+				pins = "GPIO46";
 				bias-disable;
 			};
 		};
@@ -268,11 +234,11 @@ Example board file extract:
 	pwmextvibra1 {
 		pwmextvibra1_default_mode: pwmextvibra1_default {
 			pwmextvibra1_default_mux {
-				ste,function = "pwmextvibra";
-				ste,pins = "pwmextvibra1_d_1";
+				function = "pwmextvibra";
+				groups = "pwmextvibra1_d_1";
 			};
 			pwmextvibra1_default_cfg {
-				ste,pins = "GPIO47";
+				pins = "GPIO47";
 				bias-disable;
 			};
 		};
@@ -280,11 +246,11 @@ Example board file extract:
 	pwmextvibra2 {
 		pwmextvibra2_default_mode: pwmextvibra2_default {
 			pwmextvibra2_default_mux {
-				ste,function = "pwmextvibra";
-				ste,pins = "pwmextvibra2_d_1";
+				function = "pwmextvibra";
+				groups = "pwmextvibra2_d_1";
 			};
 			pwmextvibra1_default_cfg {
-				ste,pins = "GPIO48";
+				pins = "GPIO48";
 				bias-disable;
 			};
 		};
@@ -292,11 +258,11 @@ Example board file extract:
 	gpio51 {
 		gpio51_default_mode: gpio51_default {
 				gpio51_default_mux {
-				ste,function = "gpio";
-				ste,pins = "gpio51_a_1";
+				function = "gpio";
+				groups = "gpio51_a_1";
 			};
 			gpio51_default_cfg {
-				ste,pins = "GPIO51";
+				pins = "GPIO51";
 				output-low;
 			};
 		};
@@ -304,11 +270,11 @@ Example board file extract:
 	gpio52 {
 		gpio52_default_mode: gpio52_default {
 			gpio52_default_mux {
-				ste,function = "gpio";
-				ste,pins = "gpio52_a_1";
+				function = "gpio";
+				groups = "gpio52_a_1";
 			};
 			gpio52_default_cfg {
-				ste,pins = "GPIO52";
+				pins = "GPIO52";
 				bias-pull-down;
 			};
 		};
@@ -316,11 +282,11 @@ Example board file extract:
 	gpio53 {
 		gpio53_default_mode: gpio53_default {
 			gpio53_default_mux {
-				ste,function = "gpio";
-				ste,pins = "gpio53_a_1";
+				function = "gpio";
+				groups = "gpio53_a_1";
 			};
 			gpio53_default_cfg {
-				ste,pins = "GPIO53";
+				pins = "GPIO53";
 				bias-pull-down;
 			};
 		};
@@ -328,11 +294,11 @@ Example board file extract:
 	gpio54 {
 		gpio54_default_mode: gpio54_default {
 			gpio54_default_mux {
-				ste,function = "gpio";
-				ste,pins = "gpio54_a_1";
+				function = "gpio";
+				groups = "gpio54_a_1";
 			};
 			gpio54_default_cfg {
-				ste,pins = "GPIO54";
+				pins = "GPIO54";
 				output-low;
 			};
 		};
@@ -340,11 +306,11 @@ Example board file extract:
 	pdmclkdat {
 		pdmclkdat_default_mode: pdmclkdat_default {
 			pdmclkdat_default_mux {
-				ste,function = "pdm";
-				ste,pins = "pdmclkdat_d_1";
+				function = "pdm";
+				groups = "pdmclkdat_d_1";
 			};
 			pdmclkdat_default_cfg {
-				ste,pins = "GPIO55", "GPIO56";
+				pins = "GPIO55", "GPIO56";
 				bias-disable;
 			};
 		};
-- 
1.9.3

