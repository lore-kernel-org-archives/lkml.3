Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3CNKeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:34:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54624 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab3CNKeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:34:04 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 3/3] pwm: pwm-tiehrpwm: Add device tree binding support for da850 SOC
Date: Thu, 14 Mar 2013 16:02:38 +0530
Message-ID: <1363257158-11615-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
References: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHRPWM IP is used in da850 SOC's also. Hence adds EHRPWM device tree
binding support for da850.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
:100644 100644 4fc7079... 0442d65... M	Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
:100644 100644 8b4c86f... 6561ec2... M	drivers/pwm/pwm-tiehrpwm.c
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |    2 +-
 drivers/pwm/pwm-tiehrpwm.c                         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
index 4fc7079..0442d65 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
@@ -1,7 +1,7 @@
 TI SOC EHRPWM based PWM controller
 
 Required properties:
-- compatible : Must be "ti,am33xx-ehrpwm"
+- compatible : Must be "ti,am33xx-ehrpwm" or "ti,da850-ehrpwm"
 - #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
   First cell specifies the per-chip index of the PWM to use, the second
   cell is the period in nanoseconds and bit 0 in the third cell is used to
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 8b4c86f..6561ec2 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -428,6 +428,7 @@ static const struct pwm_ops ehrpwm_pwm_ops = {
 
 static const struct of_device_id ehrpwm_of_match[] = {
 	{ .compatible	= "ti,am33xx-ehrpwm" },
+	{ .compatible	= "ti,da850-ehrpwm" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
-- 
1.7.9.5

