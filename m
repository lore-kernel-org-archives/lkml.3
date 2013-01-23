Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3AWIfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:35:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36507 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab3AWIfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:35:20 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] leds: leds-pwm: make it depend on PWM and not HAVE_PWM
Date: Wed, 23 Jan 2013 09:35:04 +0100
Message-ID: <1358930104-6681-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct dependency for the leds-pwm is PWM and not HAVE_PWM
since PWM drivers now have their own subsystem.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/leds/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 4469b44..c32d934 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -310,7 +310,7 @@ config LEDS_DAC124S085
 config LEDS_PWM
 	tristate "PWM driven LED Support"
 	depends on LEDS_CLASS
-	depends on HAVE_PWM
+	depends on PWM
 	help
 	  This option enables support for pwm driven LEDs
 
-- 
1.8.1.1

