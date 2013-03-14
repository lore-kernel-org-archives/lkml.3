Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3CNKdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:33:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52195 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab3CNKdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:33:45 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 2/3] pwm: pwm-tiecap: Add device-tree binding support for da850 SOC
Date: Thu, 14 Mar 2013 16:02:37 +0530
Message-ID: <1363257158-11615-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ECAP IP is used in da850 SOC's also. Hence adds ECAP device tree binding
support for da850.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
:100644 100644 131e8c1... fcbd3c1... M	Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
:100644 100644 22e96e2... e0d96c8... M	drivers/pwm/pwm-tiecap.c
 .../devicetree/bindings/pwm/pwm-tiecap.txt         |    2 +-
 drivers/pwm/pwm-tiecap.c                           |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
index 131e8c1..fcbd3c1 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
@@ -1,7 +1,7 @@
 TI SOC ECAP based APWM controller
 
 Required properties:
-- compatible: Must be "ti,am33xx-ecap"
+- compatible: Must be "ti,am33xx-ecap" or "ti,da850-ecap"
 - #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
   First cell specifies the per-chip index of the PWM to use, the second
   cell is the period in nanoseconds and bit 0 in the third cell is used to
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 22e96e2..e0d96c8 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -197,6 +197,7 @@ static const struct pwm_ops ecap_pwm_ops = {
 
 static const struct of_device_id ecap_of_match[] = {
 	{ .compatible	= "ti,am33xx-ecap" },
+	{ .compatible	= "ti,da850-ecap" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ecap_of_match);
-- 
1.7.9.5

