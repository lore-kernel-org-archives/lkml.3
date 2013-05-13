Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3EMXnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:43:32 -0400
Received: from mail-gg0-f196.google.com ([209.85.161.196]:39274 "EHLO
	mail-gg0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3EMXnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:43:31 -0400
X-Greylist: delayed 3492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 19:43:31 EDT
From: Dylan Socolobsky <dsocolobsky@gmail.com>
To: marek.belisko@gmail.com, devendra.aaru@gmail.com,
        gregkh@linuxfoundation.org, dsocolobsky@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: ft1000: fix brace coding style in ft1000_dnld.c
Date: Mon, 13 May 2013 19:42:28 -0300
Message-Id: <1368484948-8797-1-git-send-email-dsocolobsky@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch fixes a brace warning raised by checkpatch.pl in ft1000_dnld.c

Signed-off-by: Dylan Socolobsky <dsocolobsky@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 47cc365..18a8751 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -133,9 +133,9 @@ void card_bootload(struct net_device *dev)
 	size = sizeof(bootimage);
 
 	// check for odd word
-	if (size & 0x0003) {
+	if (size & 0x0003)
 		size += 4;
-	}
+
 	// Provide mutual exclusive access while reading ASIC registers.
 	spin_lock_irqsave(&info->dpram_lock, flags);
 
@@ -345,11 +345,10 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 
 			handshake = get_handshake(dev, HANDSHAKE_DSP_BL_READY);
 
-			if (handshake == HANDSHAKE_DSP_BL_READY) {
+			if (handshake == HANDSHAKE_DSP_BL_READY)
 				put_handshake(dev, HANDSHAKE_DRIVER_READY);
-			} else {
+			else
 				Status = FAILURE;
-			}
 
 			uiState = STATE_BOOT_DWNLD;
 
@@ -538,9 +537,9 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						outw(DWNLD_MAG_PS_HDR_LOC,
 							 dev->base_addr +
 							 FT1000_REG_DPRAM_ADDR);
-						if (word_length & 0x01) {
+						if (word_length & 0x01)
 							word_length++;
-						}
+
 						word_length = word_length / 2;
 
 						for (; word_length > 0; word_length--) {	/* In words */
-- 
1.8.1.4

