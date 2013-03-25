Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3CYHEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:04:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39516 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab3CYHEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:04:45 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <jacmet@sunsite.dk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <prakash.pm@ti.com>, Philip Avinash <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 1/2] pwm: pwm-tiecap: Update device-tree binding document
Date: Mon, 25 Mar 2013 12:34:52 +0530
Message-ID: <1364195093-1357-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
References: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update binding document of pwm-tiecap to reflect the usage of similar
modules in da850 and am3xx SOCs.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
---
 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
index 131e8c1..43c4e81 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
@@ -1,7 +1,9 @@
 TI SOC ECAP based APWM controller
 
 Required properties:
-- compatible: Must be "ti,am33xx-ecap"
+- compatible: Must be "ti,<soc>-ecap".
+  for am33xx - compatible = "ti,am33xx-ecap";
+  for da850  - compatible = "ti,da850-ecap", "ti,am33xx-ecap";
 - #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
   First cell specifies the per-chip index of the PWM to use, the second
   cell is the period in nanoseconds and bit 0 in the third cell is used to
@@ -15,9 +17,15 @@ Optional properties:
 
 Example:
 
-ecap0: ecap@0 {
+ecap0: ecap@0 {  /* ECAP on am33xx */
 	compatible = "ti,am33xx-ecap";
 	#pwm-cells = <3>;
 	reg = <0x48300100 0x80>;
 	ti,hwmods = "ecap0";
 };
+
+ecap0: ecap@0 { /* ECAP on da850 */
+	compatible = "ti,da850-ecap", "ti,am33xx-ecap";
+	#pwm-cells = <3>;
+	reg = <0x306000 0x80>;
+};
-- 
1.7.9.5

