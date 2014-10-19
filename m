Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJSNLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:11:24 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62374 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaJSNLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:11:03 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: ft1000: space prohibited after '(' and '&', before ')'
Date: Sun, 19 Oct 2014 20:59:48 +0800
Message-Id: <1413723590-19690-6-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code style error from ft1000/ft1000-pcmcia/ft1000_hw.c:
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'
ERROR: space prohibited after that '&' (ctx:WxW)

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 32 ++++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 1bf685a..3280a3c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -885,7 +885,7 @@ static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
 	unsigned long flags;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		size = ( ft1000_read_dpram(dev, *pnxtph) ) + sizeof(struct pseudo_hdr);
+		size = (ft1000_read_dpram(dev, *pnxtph)) + sizeof(struct pseudo_hdr);
 	} else {
 		size =
 			ntohs(ft1000_read_dpram_mag_16
@@ -994,10 +994,10 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
     } else {
         tempword = FT1000_DPRAM_MAG_RX_BASE;
     }
-    if ( ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword) ) {
+    if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword)) {
 
 		/* Get the message type which is total_len + PSEUDO header + msgtype + message body */
-		pdrvmsg = (struct drv_msg *) & cmdbuffer[0];
+		pdrvmsg = (struct drv_msg *) &cmdbuffer[0];
 		msgtype = ntohs(pdrvmsg->type);
 		DEBUG(1, "Command message type = 0x%x\n", msgtype);
 		switch (msgtype) {
@@ -1051,7 +1051,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 			info->CardReady = 1;
 			break;
 		case MEDIA_STATE:
-			pmediamsg = (struct media_msg *) & cmdbuffer[0];
+			pmediamsg = (struct media_msg *) &cmdbuffer[0];
 			if (info->ProgConStat != 0xFF) {
 			if (pmediamsg->state) {
 				DEBUG(1, "Media is up\n");
@@ -1082,7 +1082,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
             }
 			break;
 		case DSP_INIT_MSG:
-			pdspinitmsg = (struct dsp_init_msg *) & cmdbuffer[0];
+			pdspinitmsg = (struct dsp_init_msg *) &cmdbuffer[0];
 			memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
 			DEBUG(1, "DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n",
 				  info->DspVer[0], info->DspVer[1], info->DspVer[2],
@@ -1116,7 +1116,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 			tempword = ntohs(pdrvmsg->length);
 			info->DSPInfoBlklen = tempword;
 			if (tempword < (MAX_DSP_SESS_REC - 4)) {
-				pmsg = (u16 *) & pdrvmsg->data[0];
+				pmsg = (u16 *) &pdrvmsg->data[0];
 				for (i = 0; i < ((tempword + 1) / 2); i++) {
 					DEBUG(1,
 						  "FT1000:drivermsg:dsp info data = 0x%x\n",
@@ -1198,7 +1198,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 				 * Put message into Slow Queue
 				 * Form Pseudo header
 				 */
-				pmsg = (u16 *) & tempbuffer[0];
+				pmsg = (u16 *) &tempbuffer[0];
 				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				ppseudo_hdr->length = htons(0x0012);
 				ppseudo_hdr->source = 0x10;
@@ -1219,7 +1219,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
                 for (i = 1; i < 7; i++) {
                     ppseudo_hdr->checksum ^= *pmsg++;
                 }
-				pmsg = (u16 *) & tempbuffer[16];
+				pmsg = (u16 *) &tempbuffer[16];
 				*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
 				*pmsg++ = htons(0x000e);
 				*pmsg++ = htons(info->DSP_TIME[0]);
@@ -1875,22 +1875,22 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 				  i + 8, htons(*packet));
 		}
 	} else {
-		outl(*(u32 *) & pseudo.buff[0],
+		outl(*(u32 *) &pseudo.buff[0],
 			 dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[0]);
-		outl(*(u32 *) & pseudo.buff[2],
+			  *(u32 *) &pseudo.buff[0]);
+		outl(*(u32 *) &pseudo.buff[2],
 			 dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[2]);
-		outl(*(u32 *) & pseudo.buff[4],
+			  *(u32 *) &pseudo.buff[2]);
+		outl(*(u32 *) &pseudo.buff[4],
 			 dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[4]);
-		outl(*(u32 *) & pseudo.buff[6],
+			  *(u32 *) &pseudo.buff[4]);
+		outl(*(u32 *) &pseudo.buff[6],
 			 dev->base_addr + FT1000_REG_MAG_UFDR);
 		DEBUG(1, "ft1000_copy_down_pkt: Pseudo = 0x%8x\n",
-			  *(u32 *) & pseudo.buff[6]);
+			  *(u32 *) &pseudo.buff[6]);
 
 		plong = (u32 *) packet;
 		/* Write PPP type + IP Packet into Downlink FIFO */
-- 
2.1.1

