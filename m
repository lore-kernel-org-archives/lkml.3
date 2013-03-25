Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3CYHE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:04:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53245 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab3CYHE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:04:56 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <jacmet@sunsite.dk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <prakash.pm@ti.com>, Philip Avinash <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 2/2] pwm: pwm-tiehrpwm: Update device-tree binding document
Date: Mon, 25 Mar 2013 12:34:53 +0530
Message-ID: <1364195093-1357-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
References: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update binding document of pwm-tiehrpwm to reflect the usage of similar
modules in da850 and am3xx SOCs.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
---
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
index 4fc7079..9a71369 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
@@ -1,7 +1,9 @@
 TI SOC EHRPWM based PWM controller
 
 Required properties:
-- compatible : Must be "ti,am33xx-ehrpwm"
+- compatible: Must be "ti,<soc>-ehrpwm".
+  for am33xx - compatible = "ti,am33xx-ehrpwm";
+  for da850  - compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
 - #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
   First cell specifies the per-chip index of the PWM to use, the second
   cell is the period in nanoseconds and bit 0 in the third cell is used to
@@ -15,9 +17,15 @@ Optional properties:
 
 Example:
 
-ehrpwm0: ehrpwm@0 {
+ehrpwm0: ehrpwm@0 { /* EHRPWM on am33xx */
 	compatible = "ti,am33xx-ehrpwm";
 	#pwm-cells = <3>;
 	reg = <0x48300200 0x100>;
 	ti,hwmods = "ehrpwm0";
 };
+
+ehrpwm0: ehrpwm@0 { /* EHRPWM on da850 */
+	compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
+	#pwm-cells = <3>;
+	reg = <0x300000 0x2000>;
+};
-- 
1.7.9.5

