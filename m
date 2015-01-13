Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbbAML5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:57:20 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47192 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbAML5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:57:18 -0500
From: Bilel DRIRA <bilel.dr@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org, joe@perches.com,
        tapaswenipathak@gmail.com, gdonald@gmail.com, aybuke.147@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Bilel DRIRA <bilel.dr@gmail.com>
Subject: [PATCH] staging: ft1000: fix else style error
Date: Tue, 13 Jan 2015 12:57:01 +0100
Message-Id: <1421150221-16028-1-git-send-email-bilel.dr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <ft1000else_style>
References: <ft1000else_style>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the checkpatch.pl error:

	ERROR: else should follow close brace '}'

Signed-off-by: Bilel DRIRA <bilel.dr@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index e9a37ee..cf0683f 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -572,8 +572,7 @@ static void ft1000_hbchk(u_long data)
 		if (tempword != ho) {
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			} else {
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
 			}
 		}
@@ -688,15 +687,13 @@ static void ft1000_hbchk(u_long data)
 		if (tempword != hi) {
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
-			}
-			else {
+			} else {
 				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
 			}
 
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			} else {
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
 			}
 
@@ -959,8 +956,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		tempword = FT1000_DPRAM_RX_BASE+2;
-	}
-	else {
+	} else {
 		tempword = FT1000_DPRAM_MAG_RX_BASE;
 	}
 	if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
@@ -1039,8 +1035,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
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

