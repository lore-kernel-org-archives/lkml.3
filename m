Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab3GPW6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:58:19 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50751 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab3GPW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:58:17 -0400
From: Alban Browaeys <alban.browaeys@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: [PATCH 1/4] [media] em28xx: fix assignment of the eeprom data.
Date: Wed, 17 Jul 2013 00:57:53 +0200
Message-Id: <1374015476-26197-1-git-send-email-prahal@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the config structure pointer to the eeprom data pointer (data,
here eedata dereferenced) not the pointer to the pointer to
the eeprom data (eedata itself).

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 4851cc2..c4ff973 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -726,7 +726,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
 
 	*eedata = data;
 	*eedata_len = len;
-	dev_config = (void *)eedata;
+	dev_config = (void *)*eedata;
 
 	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
 	case 0:
-- 
1.8.3.2

