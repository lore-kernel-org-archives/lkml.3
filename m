Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3HFRKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:10:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39487 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3HFRKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:10:40 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/2] pinctrl: add generic pins and functions properties
Date: Tue,  6 Aug 2013 11:10:32 -0600
Message-Id: <1375809032-21477-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375809032-21477-1-git-send-email-swarren@wwwdotorg.org>
References: <1375809032-21477-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

pinctrl bindings can benefit from generic property names that define
which pins a "pin configuration node" affects, and which mux function
to select onto those pins. Document new properties for this purpose so
that other bindings may refer to them.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Define the arguments that the pins and functions properties take.
---
 .../devicetree/bindings/pinctrl/pinctrl-bindings.txt     | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 31b0cb9..1958ca9 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -138,6 +138,9 @@ structure of the DT nodes that contain these properties.
 
 Supported generic properties are:
 
+pins			- the list of pins that properties in the node
+			  apply to
+function		- the mux function to select
 bias-disable		- disable any pin bias
 bias-high-impedance	- high impedance mode ("third-state", "floating")
 bias-bus-hold		- latch weakly
@@ -159,6 +162,19 @@ output-high		- set the pin to output mode with high level
 Some of the generic properties take arguments. For those that do, the
 arguments are described below.
 
+- pins takes a list of pin names or IDs as a required argument. The specific
+  binding for the hardware defines:
+  - Whether the entries are integers or strings, and their meaning.
+
+- function takes a list of function names/IDs as a required argument. The
+  specific binding for the hardware defines:
+  - Whether the entries are integers or strings, and their meaning.
+  - Whether only a single entry is allowed (which is applied to all entries
+    in the pins property), or whether there may alternatively be one entry per
+    entry in the pins property, in which case the list lengths must match, and
+    for each list index i, the function at list index i is applied to the pin
+    at list index i.
+
 - bias-pull-up, -down and -pin-default take as optional argument on hardware
   supporting it the pull strength in Ohm. bias-disable will disable the pull.
 
-- 
1.8.1.5

