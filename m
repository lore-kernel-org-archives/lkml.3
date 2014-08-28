Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936052AbaH1BrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:47:00 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34351 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaH1Bq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:46:59 -0400
From: Fred Chou <fred.chou.nd@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, fred.chou.nd@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vme: remove redundant else condition
Date: Thu, 28 Aug 2014 09:50:56 +0800
Message-Id: <1409190656-17762-1-git-send-email-fred.chou.nd@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The else condition is redundant after a return. Remove these redundant else conditions.

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
 drivers/staging/vme/devices/vme_pio2_gpio.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
index f00af07..d8a118d 100644
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -58,14 +58,14 @@ static int pio2_gpio_get(struct gpio_chip *chip, unsigned int offset)
 	if (reg & PIO2_CHANNEL_BIT[offset]) {
 		if (card->bank[PIO2_CHANNEL_BANK[offset]].config != BOTH)
 			return 0;
-		else
-			return 1;
-	} else {
-		if (card->bank[PIO2_CHANNEL_BANK[offset]].config != BOTH)
-			return 1;
-		else
-			return 0;
+
+		return 1;
 	}
+
+	if (card->bank[PIO2_CHANNEL_BANK[offset]].config != BOTH)
+		return 1;
+
+	return 0;
 }
 
 static void pio2_gpio_set(struct gpio_chip *chip, unsigned int offset,
-- 
1.7.9.5

