Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab3GPXGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:06:41 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64584 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab3GPXGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:06:39 -0400
From: Alban Browaeys <alban.browaeys@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: [PATCH 3/4] [media] em28xx: usb power config is in the low byte.
Date: Wed, 17 Jul 2013 01:06:23 +0200
Message-Id: <1374015983-27615-1-git-send-email-prahal@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the em2860 datasheet, eeprom byte 08H is Chip
Configuration Low Byte and 09H is High Byte.
Usb power configuration is in the Low byte (same as the usb audio
 class config).

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index c4ff973..6ff7415 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -743,13 +743,13 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 		break;
 	}
 
-	if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
+	if (le16_to_cpu(dev_config->chip_conf) >> 4 & 1 << 3)
 		em28xx_info("\tUSB Remote wakeup capable\n");
 
-	if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
+	if (le16_to_cpu(dev_config->chip_conf) >> 4 & 1 << 2)
 		em28xx_info("\tUSB Self power capable\n");
 
-	switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
+	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
 	case 0:
 		em28xx_info("\t500mA max power\n");
 		break;
-- 
1.8.3.2

