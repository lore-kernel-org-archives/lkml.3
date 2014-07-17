Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982AbaGQQ2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:28:38 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:58230 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607AbaGQQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:28:36 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, knivey@botops.net,
        hsweeten@visionengravers.com, abbotti@mev.co.uk,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 3/4]  drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c: drop incorrect checks
Date: Thu, 17 Jul 2014 19:28:21 +0300
Message-Id: <1405614501-4554-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped some "< 0" and ">= 0" checks on unsigned int values.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80501
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci3200.c        | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index a3026a2..3a215ac 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -1750,34 +1750,34 @@ static int apci3200_ai_config(struct comedi_device *dev,
 	/* END JK 06.07.04: Management of sevrals boards */
 
 	if (data[5] == 0) {
-		if (ui_ChannelNo < 0 || ui_ChannelNo > 15) {
+		if (ui_ChannelNo > 15) {
 			printk("\nThe Selection of the channel is in error\n");
 			i_err++;
-		}		/*  if(ui_ChannelNo<0 || ui_ChannelNo>15) */
+		}		/*  if(ui_ChannelNo>15) */
 	}			/* if(data[5]==0) */
 	else {
 		if (data[14] == 2) {
-			if (ui_ChannelNo < 0 || ui_ChannelNo > 3) {
+			if (ui_ChannelNo > 3) {
 				printk("\nThe Selection of the channel is in error\n");
 				i_err++;
-			}	/*  if(ui_ChannelNo<0 || ui_ChannelNo>3) */
+			}	/*  if(ui_ChannelNo>3) */
 		}		/* if(data[14]==2) */
 		else {
-			if (ui_ChannelNo < 0 || ui_ChannelNo > 7) {
+			if (ui_ChannelNo > 7) {
 				printk("\nThe Selection of the channel is in error\n");
 				i_err++;
-			}	/*  if(ui_ChannelNo<0 || ui_ChannelNo>7) */
+			}	/*  if(ui_ChannelNo>7) */
 		}		/* elseif(data[14]==2) */
 	}			/* elseif(data[5]==0) */
 	if (data[12] == 0 || data[12] == 1) {
 		switch (data[5]) {
 		case 0:
-			if (ui_ChannelNo >= 0 && ui_ChannelNo <= 3) {
+			if (ui_ChannelNo <= 3) {
 				/* BEGIN JK 06.07.04: Management of sevrals boards */
 				/* i_Offset=0; */
 				s_BoardInfos[dev->minor].i_Offset = 0;
 				/* END JK 06.07.04: Management of sevrals boards */
-			}	/* if(ui_ChannelNo >=0 && ui_ChannelNo <=3) */
+			}	/* if(ui_ChannelNo <=3) */
 			if (ui_ChannelNo >= 4 && ui_ChannelNo <= 7) {
 				/* BEGIN JK 06.07.04: Management of sevrals boards */
 				/* i_Offset=64; */
@@ -1831,12 +1831,12 @@ static int apci3200_ai_config(struct comedi_device *dev,
 				ui_ChannelNo = 0;
 				break;
 			}	/* if(data[14]==2) */
-			if (ui_ChannelNo >= 0 && ui_ChannelNo <= 1) {
+			if (ui_ChannelNo <= 1) {
 				/* BEGIN JK 06.07.04: Management of sevrals boards */
 				/* i_Offset=0; */
 				s_BoardInfos[dev->minor].i_Offset = 0;
 				/* END JK 06.07.04: Management of sevrals boards */
-			}	/* if(ui_ChannelNo >=0 && ui_ChannelNo <=1) */
+			}	/* if(ui_ChannelNo <=1) */
 			if (ui_ChannelNo >= 2 && ui_ChannelNo <= 3) {
 				/* BEGIN JK 06.07.04: Management of sevrals boards */
 				/* i_ChannelNo=i_ChannelNo-2; */
-- 
1.8.5.5

