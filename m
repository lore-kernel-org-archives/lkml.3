Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbbAMVhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:37:20 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57229 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbbAMVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:37:18 -0500
From: Bilel DRIRA <bilel.dr@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org, joe@perches.com,
        tapaswenipathak@gmail.com, gdonald@gmail.com, aybuke.147@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: Bilel DRIRA <bilel.dr@gmail.com>
Subject: [PATCH v2 ] staging: ft1000: fix else style error
Date: Tue, 13 Jan 2015 22:34:00 +0100
Message-Id: <1421184840-24108-1-git-send-email-bilel.dr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl error:

	ERROR: else should follow close brace '}'

Signed-off-by: Bilel DRIRA <bilel.dr@gmail.com>
---
v2: remove braces instead of just putting else after close brace. (suggested by Joe Perches).

 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |   29 ++++++++--------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index e9a37ee..4b830ac 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -570,12 +570,10 @@ static void ft1000_hbchk(u_long data)
 		pr_debug("hi_ho value = 0x%x\n", tempword);
 		/* Let's perform another check if ho is not detected */
 		if (tempword != ho) {
-			if (info->AsicID == ELECTRABUZZ_ID) {
+			if (info->AsicID == ELECTRABUZZ_ID)
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			else
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
-			}
 		}
 		if (tempword != ho) {
 			pr_info("heartbeat failed - no ho detected\n");
@@ -686,20 +684,15 @@ static void ft1000_hbchk(u_long data)
 		}
 		/* Let's write hi again if fail */
 		if (tempword != hi) {
-			if (info->AsicID == ELECTRABUZZ_ID) {
+			if (info->AsicID == ELECTRABUZZ_ID)
 				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
-			}
-			else {
+			else
 				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
-			}
 
-			if (info->AsicID == ELECTRABUZZ_ID) {
+			if (info->AsicID == ELECTRABUZZ_ID)
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			else
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
-			}
-
 		}
 
 		if (tempword != hi) {
@@ -957,12 +950,11 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 		u16 wrd;
 	} convert;
 
-	if (info->AsicID == ELECTRABUZZ_ID) {
+	if (info->AsicID == ELECTRABUZZ_ID)
 		tempword = FT1000_DPRAM_RX_BASE+2;
-	}
-	else {
+	else
 		tempword = FT1000_DPRAM_MAG_RX_BASE;
-	}
+
 	if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
 
 		/* Get the message type which is total_len + PSEUDO header + msgtype + message body */
@@ -1039,8 +1031,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 						info->ConTm = 0;
 					}
 				}
-			}
-			else {
+			} else {
 				pr_debug("Media is down\n");
 				if (info->mediastate == 1) {
 					info->mediastate = 0;
-- 
1.7.9.5

