Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3HEWFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:05:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34435 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3HEWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:05:16 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] pinctrl: clean up pinconfig-generic documentation
Date: Mon,  5 Aug 2013 15:55:59 -0600
Message-Id: <1375739760-18833-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Reword the section of pinctrl-bindings.txt that describes generic
properties that pinctrl bindings may use. The aim is to make the text
clearer, and more explicitly call out the responsibility of individual
bindings that use the generic properties to define which of the
properties are used, and how.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
LinusW, Laxman, this is the binding doc cleanup I mentioned I was going
to send when reviewing Laxman's Palmas pinctrl driver.

 .../bindings/pinctrl/pinctrl-bindings.txt          | 25 +++++++++-------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index aeb3c99..31b0cb9 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -127,20 +127,16 @@ whether there is any interaction between the child and intermediate parent
 nodes, is again defined entirely by the binding for the individual pin
 controller device.
 
-== Using generic pinconfig options ==
+== Generic pin configuration node content ==
 
-Generic pinconfig parameters can be used by defining a separate node containing
-the applicable parameters (and optional values), like:
+Many data items that are represented in a pin configuration node are common
+and generic. Pin control bindings should use the properties defined below
+where they are applicable; not all of these properties are relevant or useful
+for all hardware or binding structures. Each individual binding document
+should state which of these generic properties, if any, are used, and the
+structure of the DT nodes that contain these properties.
 
-pcfg_pull_up: pcfg_pull_up {
-	bias-pull-up;
-	drive-strength = <20>;
-};
-
-This node should then be referenced in the appropriate pinctrl node as a phandle
-and parsed in the driver using the pinconf_generic_parse_dt_config function.
-
-Supported configuration parameters are:
+Supported generic properties are:
 
 bias-disable		- disable any pin bias
 bias-high-impedance	- high impedance mode ("third-state", "floating")
@@ -160,7 +156,8 @@ low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level
 output-high		- set the pin to output mode with high level
 
-Arguments for parameters:
+Some of the generic properties take arguments. For those that do, the
+arguments are described below.
 
 - bias-pull-up, -down and -pin-default take as optional argument on hardware
   supporting it the pull strength in Ohm. bias-disable will disable the pull.
@@ -170,7 +167,5 @@ Arguments for parameters:
 - input-debounce takes the debounce time in usec as argument
   or 0 to disable debouncing
 
-All parameters not listed here, do not take an argument.
-
 More in-depth documentation on these parameters can be found in
 <include/linux/pinctrl/pinconfig-generic.h>
-- 
1.8.1.5

