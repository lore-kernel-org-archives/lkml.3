Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab3GPXGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:06:07 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50333 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab3GPXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:06:05 -0400
From: Alban Browaeys <alban.browaeys@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: [PATCH 2/4] [media] em28xx: i2s 5 sample rates is a subset of 3 one.
Date: Wed, 17 Jul 2013 01:05:41 +0200
Message-Id: <1374015941-27538-1-git-send-email-prahal@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As:
EM28XX_CHIPCFG_I2S_3_SAMPRATES 0x20
EM28XX_CHIPCFG_I2S_5_SAMPRATES 0x30

the board chipcfg is 0xf0 thus if 3_SAMPRATES is tested
first and matches while it is a 5_SAMPRATES.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index fc157af..3c0c5e9 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -505,13 +505,13 @@ int em28xx_audio_setup(struct em28xx *dev)
 		dev->audio_mode.has_audio = false;
 		return 0;
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
-		   EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
-		em28xx_info("I2S Audio (3 sample rates)\n");
-		dev->audio_mode.i2s_3rates = 1;
-	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
 		   EM28XX_CHIPCFG_I2S_5_SAMPRATES) {
 		em28xx_info("I2S Audio (5 sample rates)\n");
 		dev->audio_mode.i2s_5rates = 1;
+	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
+		   EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
+		em28xx_info("I2S Audio (3 sample rates)\n");
+		dev->audio_mode.i2s_3rates = 1;
 	}
 
 	if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
-- 
1.8.3.2

