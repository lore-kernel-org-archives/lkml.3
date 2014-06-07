Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaFGUrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 16:47:10 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58997 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaFGUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 16:47:08 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Cc: Lothar Felten <l-felten@ti.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] hwmon: (ina2xx) Change register cache to signed
Date: Sat,  7 Jun 2014 21:47:01 +0100
Message-Id: <1402174021-25857-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All devices supported by the ina2xx driver are bidirectional and reports
the measured value as a signed 16 bit, but the current driver
implementation caches the number as an u16, leading to an incorrect sign
extension when reporting to the userspace in ina2xx_get_value().

This patch fixes the problem by using a s16 instead, and has been tested
on an INA219.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/hwmon/ina2xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 93d26e8..d994280 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -86,7 +86,7 @@ struct ina2xx_data {
 	unsigned long last_updated;
 
 	int kind;
-	u16 regs[INA2XX_MAX_REGISTERS];
+	s16 regs[INA2XX_MAX_REGISTERS];
 };
 
 static const struct ina2xx_config ina2xx_config[] = {
-- 
1.8.4

