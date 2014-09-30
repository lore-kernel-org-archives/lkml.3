Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaI3HPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:15:35 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48239 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaI3HPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:15:32 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: alter device tree bindings for functions
Date: Tue, 30 Sep 2014 09:15:28 +0200
Message-Id: <1412061328-20966-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For function and group configuration nodes, use "function"
"groups" string pairs, not "pins" where there should be
"groups".

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          | 39 ++++++++++++++++------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index fa40a177164c..4f5a0c3af8b9 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -127,6 +127,24 @@ whether there is any interaction between the child and intermediate parent
 nodes, is again defined entirely by the binding for the individual pin
 controller device.
 
+== Generic pin multiplexing node content ==
+
+pin multiplexing nodes:
+
+function		- the mux function to select
+groups			- the list of groups to select with this function
+
+Example:
+
+state_0_node_a {
+	function = "uart0";
+	groups = "u0rxtx", "u0rtscts";
+};
+state_1_node_a {
+	function = "spi0";
+	groups = "spi0pins";
+};
+
 == Generic pin configuration node content ==
 
 Many data items that are represented in a pin configuration node are common
@@ -140,7 +158,6 @@ Supported generic properties are:
 
 pins			- the list of pins that properties in the node
 			  apply to
-function		- the mux function to select
 bias-disable		- disable any pin bias
 bias-high-impedance	- high impedance mode ("third-state", "floating")
 bias-bus-hold		- latch weakly
@@ -163,6 +180,17 @@ output-low		- set the pin to output mode with low level
 output-high		- set the pin to output mode with high level
 slew-rate		- set the slew rate
 
+For example:
+
+state_0_node_a {
+	pins = "GPIO0_AJ5", "GPIO2_AH4"; /* CTS+RXD */
+	bias-pull-up;
+};
+state_1_node_a {
+	pins = "GPIO1_AJ3", "GPIO3_AH3"; /* RTS+TXD */
+	output-high;
+};
+
 Some of the generic properties take arguments. For those that do, the
 arguments are described below.
 
@@ -170,15 +198,6 @@ arguments are described below.
   binding for the hardware defines:
   - Whether the entries are integers or strings, and their meaning.
 
-- function takes a list of function names/IDs as a required argument. The
-  specific binding for the hardware defines:
-  - Whether the entries are integers or strings, and their meaning.
-  - Whether only a single entry is allowed (which is applied to all entries
-    in the pins property), or whether there may alternatively be one entry per
-    entry in the pins property, in which case the list lengths must match, and
-    for each list index i, the function at list index i is applied to the pin
-    at list index i.
-
 - bias-pull-up, -down and -pin-default take as optional argument on hardware
   supporting it the pull strength in Ohm. bias-disable will disable the pull.
 
-- 
1.9.3

