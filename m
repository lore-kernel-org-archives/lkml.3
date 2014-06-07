Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaFGDCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:02:42 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38039 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaFGDCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:02:39 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: dan.carpenter@oracle.com
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH v2 4/5] staging: ft1000: ft1000-usb: ft1000_debug.c: Remove unnecessary braces.
Date: Fri,  6 Jun 2014 20:02:17 -0700
Message-Id: <1402110138-13713-5-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
References: <20140602103056.GY15585@mwanda>
 <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary braces from single statement if blocks.

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 5e371b7..94fb9f9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -319,9 +319,8 @@ static int ft1000_open(struct inode *inode, struct file *file)
 
 	/* Search for available application info block */
 	for (i = 0; i < MAX_NUM_APP; i++) {
-		if ((dev->app_info[i].fileobject == NULL)) {
+		if ((dev->app_info[i].fileobject == NULL))
 			break;
-		}
 	}
 
 	/* Fail due to lack of application info block */
@@ -540,17 +539,14 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 			/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\n");*/
 
 
-			if (ft1000_flarion_cnt == 0) {
+			if (ft1000_flarion_cnt == 0)
 				return (-EBADF);
-			}
 
-			if (ft1000dev->DrvMsgPend) {
+			if (ft1000dev->DrvMsgPend)
 				return (-ENOTTY);
-			}
 
-			if (ft1000dev->fProvComplete == 0) {
+			if (ft1000dev->fProvComplete == 0)
 				return (-EACCES);
-			}
 
 			ft1000dev->fAppMsgPend = 1;
 
@@ -582,9 +578,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 				} else {
 					/* Check if this message came from a registered application */
 					for (i = 0; i < MAX_NUM_APP; i++) {
-						if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+						if (ft1000dev->app_info[i].fileobject == &file->f_owner)
 							break;
-						}
 					}
 					if (i == MAX_NUM_APP) {
 						DEBUG("FT1000:No matching application fileobject\n");
@@ -636,9 +631,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 						pmsg = (u16 *)&dpram_data->pseudohdr;
 						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 						total_len = msgsz+2;
-						if (total_len & 0x1) {
+						if (total_len & 0x1)
 							total_len++;
-						}
 
 						/* Insert slow queue sequence number */
 						ppseudo_hdr->seq_num = info->squeseqnum++;
@@ -677,9 +671,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 
 			/* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n"); */
 
-			if (ft1000_flarion_cnt == 0) {
+			if (ft1000_flarion_cnt == 0)
 				return (-EBADF);
-			}
 
 			/* Search for matching file object */
 			for (i = 0; i < MAX_NUM_APP; i++) {
-- 
1.9.1

