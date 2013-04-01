Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3DAHla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:41:30 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52698 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3DAHl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:41:29 -0400
Message-ID: <1364802082.6252.1.camel@phoenix>
Subject: [PATCH] pwm: pxa: Remove PWM_ID_BASE macro
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 15:41:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM_ID_BASE() is not used after convert to PWM framework, remove it.
Also update driver_data field of struct platform_device_id accordingly.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
This is v2 of [PATCH] pwm: pxa: Use driver_data field to store pwm_nr.
I change the subject line to meet the change in v2.

 drivers/pwm/pwm-pxa.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index b789882..dee6ab55 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -23,14 +23,13 @@
 #include <asm/div64.h>
 
 #define HAS_SECONDARY_PWM	0x10
-#define PWM_ID_BASE(d)		((d) & 0xf)
 
 static const struct platform_device_id pwm_id_table[] = {
 	/*   PWM    has_secondary_pwm? */
 	{ "pxa25x-pwm", 0 },
-	{ "pxa27x-pwm", 0 | HAS_SECONDARY_PWM },
-	{ "pxa168-pwm", 1 },
-	{ "pxa910-pwm", 1 },
+	{ "pxa27x-pwm", HAS_SECONDARY_PWM },
+	{ "pxa168-pwm", 0 },
+	{ "pxa910-pwm", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, pwm_id_table);
-- 
1.7.10.4



