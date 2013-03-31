Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3CaQMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 12:12:14 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55006 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3CaQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 12:12:12 -0400
Message-ID: <1364746327.12810.1.camel@phoenix>
Subject: [PATCH] pwm: pxa: Use driver_data field to store pwm_nr
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 00:12:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver_data field was used to store information about PWM_ID_BASE and
HAS_SECONDARY_PWM. PWM_ID_BASE is not used now after convert to pwm framework.
This patch stores the pwm_nr in driver_data field to simplify the code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-pxa.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index b789882..019a8e0 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -22,13 +22,10 @@
 
 #include <asm/div64.h>
 
-#define HAS_SECONDARY_PWM	0x10
-#define PWM_ID_BASE(d)		((d) & 0xf)
-
 static const struct platform_device_id pwm_id_table[] = {
-	/*   PWM    has_secondary_pwm? */
-	{ "pxa25x-pwm", 0 },
-	{ "pxa27x-pwm", 0 | HAS_SECONDARY_PWM },
+	/*   PWM    pwm_nr */
+	{ "pxa25x-pwm", 1 },
+	{ "pxa27x-pwm", 2 },
 	{ "pxa168-pwm", 1 },
 	{ "pxa910-pwm", 1 },
 	{ },
@@ -145,7 +142,7 @@ static int pwm_probe(struct platform_device *pdev)
 	pwm->chip.dev = &pdev->dev;
 	pwm->chip.ops = &pxa_pwm_ops;
 	pwm->chip.base = -1;
-	pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
+	pwm->chip.npwm = id->driver_data;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
-- 
1.7.10.4



