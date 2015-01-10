Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbbAJVOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:14:24 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34325 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbAJVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:14:23 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: fix up device tree bindings
Date: Sat, 10 Jan 2015 22:14:17 +0100
Message-Id: <1420924457-12730-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the Nomadik pin controller was force migrated to generic pin
control bindings, some leftovers in the documentation need to be
cleaned up. The code and device trees are already migrated.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../devicetree/bindings/pinctrl/ste,nomadik.txt    | 35 ++++++++++++----------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
index 6b33b9f18e88..f63fcb3ed352 100644
--- a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
+++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
@@ -16,17 +16,22 @@ mux function to select on those pin(s)/group(s), and various pin configuration
 parameters, such as input, output, pull up, pull down...
 
 The name of each subnode is not important; all subnodes should be enumerated
-and processed purely based on their content.
+and processed purely based on their content. The subnodes use the generic
+pin multiplexing node layout from the standard pin control bindings
+(see pinctrl-bindings.txt):
 
-Required subnode-properties:
-- ste,pins : An array of strings. Each string contains the name of a pin or
-    group.
-
-Optional subnode-properties:
-- ste,function: A string containing the name of the function to mux to the
+Required pin multiplexing subnode properties:
+- function: A string containing the name of the function to mux to the
   pin or group.
+- groups : An array of strings. Each string contains the name of a pin
+  group that will be combined with the function to form a multiplexing
+  set-up.
 
-- ste,config: Handle of pin configuration node (e.g. ste,config = <&slpm_in_wkup_pdis>)
+Required pin configuration subnode properties:
+- pins: A string array describing the pins affected by the configuration
+  in the node.
+- ste,config: Handle of pin configuration node
+  (e.g. ste,config = <&slpm_in_wkup_pdis>)
 
 - ste,input : <0/1/2>
 	0: input with no pull
@@ -97,32 +102,32 @@ Example board file extract:
 		uart0 {
 			uart0_default_mux: uart0_mux {
 				u0_default_mux {
-					ste,function = "u0";
-					ste,pins = "u0_a_1";
+					function = "u0";
+					pins = "u0_a_1";
 				};
 			};
 			uart0_default_mode: uart0_default {
 				uart0_default_cfg1 {
-					ste,pins = "GPIO0", "GPIO2";
+					pins = "GPIO0", "GPIO2";
 					ste,input = <1>;
 				};
 
 				uart0_default_cfg2 {
-					ste,pins = "GPIO1", "GPIO3";
+					pins = "GPIO1", "GPIO3";
 					ste,output = <1>;
 				};
 			};
 			uart0_sleep_mode: uart0_sleep {
 				uart0_sleep_cfg1 {
-					ste,pins = "GPIO0", "GPIO2";
+					pins = "GPIO0", "GPIO2";
 					ste,config = <&slpm_in_wkup_pdis>;
 				};
 				uart0_sleep_cfg2 {
-					ste,pins = "GPIO1";
+					pins = "GPIO1";
 					ste,config = <&slpm_out_hi_wkup_pdis>;
 				};
 				uart0_sleep_cfg3 {
-					ste,pins = "GPIO3";
+					pins = "GPIO3";
 					ste,config = <&slpm_out_wkup_pdis>;
 				};
 			};
-- 
1.9.3

