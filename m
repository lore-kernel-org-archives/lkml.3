Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaFGDCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:02:39 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50322 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaFGDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:02:36 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: dan.carpenter@oracle.com
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH v2 2/5] staging: ft1000: ft1000-usb: ft1000_debug.c: Add required spaces.
Date: Fri,  6 Jun 2014 20:02:15 -0700
Message-Id: <1402110138-13713-3-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
References: <20140602103056.GY15585@mwanda>
 <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add spaces around operators, after commas, and between (foo*).

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 48 ++++++++++++------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 338f91e..1395c2b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -193,7 +193,7 @@ int ft1000_create_dev(struct ft1000_usb *dev)
 
 	/* initialize application information */
 	dev->appcnt = 0;
-	for (i=0; i<MAX_NUM_APP; i++) {
+	for (i = 0; i < MAX_NUM_APP; i++) {
 		dev->app_info[i].nTxMsg = 0;
 		dev->app_info[i].nRxMsg = 0;
 		dev->app_info[i].nTxMsgReject = 0;
@@ -260,7 +260,7 @@ void ft1000_destroy_dev(struct net_device *netdev)
 			dev->DeviceName);
 
 		/* Make sure we free any memory reserve for slow Queue */
-		for (i=0; i<MAX_NUM_APP; i++) {
+		for (i = 0; i < MAX_NUM_APP; i++) {
 			while (list_empty(&dev->app_info[i].app_sqlist) == 0) {
 				pdpram_blk = list_entry(dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
 				list_del(&pdpram_blk->list);
@@ -301,7 +301,7 @@ static int ft1000_open(struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
 	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
-	int i,num;
+	int i, num;
 
 	DEBUG("%s called\n", __func__);
 	num = (MINOR(inode->i_rdev) & 0xf);
@@ -318,7 +318,7 @@ static int ft1000_open(struct inode *inode, struct file *file)
 	}
 
 	/* Search for available application info block */
-	for (i=0; i<MAX_NUM_APP; i++) {
+	for (i = 0; i < MAX_NUM_APP; i++) {
 		if ((dev->app_info[i].fileobject == NULL)) {
 			break;
 		}
@@ -369,7 +369,7 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 	}
 
 	/* Search for matching file object */
-	for (i=0; i<MAX_NUM_APP; i++) {
+	for (i = 0; i < MAX_NUM_APP; i++) {
 		if (dev->app_info[i].fileobject == &file->f_owner) {
 			/* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", dev->app_info[i].app_id); */
 			break;
@@ -411,7 +411,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 	void __user *argp = (void __user *)argument;
 	struct ft1000_info *info;
 	struct ft1000_usb *ft1000dev;
-	int result=0;
+	int result = 0;
 	int cmd;
 	int i;
 	u16 tempword;
@@ -419,15 +419,15 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 	struct timeval tv;
 	struct IOCTL_GET_VER get_ver_data;
 	struct IOCTL_GET_DSP_STAT get_stat_data;
-	u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
-			      0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
-			      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-			      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-			      0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
-			      0x00,0x01,0x00,0x00};
+	u8 ConnectionMsg[] = {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64,
+			      0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x0a,
+			      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			      0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x7f, 0x00,
+			      0x00, 0x01, 0x00, 0x00};
 
-	unsigned short ledStat=0;
-	unsigned short conStat=0;
+	unsigned short ledStat = 0;
+	unsigned short conStat = 0;
 
 	/* DEBUG("ft1000_ioctl called\n"); */
 
@@ -447,14 +447,14 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 	switch (cmd) {
 	case IOCTL_REGISTER_CMD:
 		DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
-		result = get_user(tempword, (__u16 __user*)argp);
+		result = get_user(tempword, (__u16 __user *)argp);
 		if (result) {
 			DEBUG("result = %d failed to get_user\n", result);
 			break;
 		}
 		if (tempword == DSPBCMSGID) {
 			/* Search for matching file object */
-			for (i=0; i<MAX_NUM_APP; i++) {
+			for (i = 0; i < MAX_NUM_APP; i++) {
 				if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
 					ft1000dev->app_info[i].DspBCMsgFlag = 1;
 					DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
@@ -475,7 +475,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 			break;
 		}
 
-		DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
+		DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n", (unsigned int)get_ver_data.drv_ver);
 
 		break;
 	case IOCTL_CONNECT:
@@ -581,12 +581,12 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 					result = -EFAULT;
 				} else {
 					/* Check if this message came from a registered application */
-					for (i=0; i<MAX_NUM_APP; i++) {
+					for (i = 0; i < MAX_NUM_APP; i++) {
 						if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
 							break;
 						}
 					}
-					if (i==MAX_NUM_APP) {
+					if (i == MAX_NUM_APP) {
 						DEBUG("FT1000:No matching application fileobject\n");
 						result = -EINVAL;
 						kfree(dpram_data);
@@ -646,13 +646,13 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 						/* Calculate new checksum */
 						ppseudo_hdr->checksum = *pmsg++;
 						/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
-						for (i=1; i<7; i++) {
+						for (i = 1; i < 7; i++) {
 							ppseudo_hdr->checksum ^= *pmsg++;
 							/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
 						}
 						pmsg++;
 						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-						card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
+						card_send_command(ft1000dev, (unsigned short *)dpram_data, total_len+2);
 
 
 						ft1000dev->app_info[app_index].nTxMsg++;
@@ -682,7 +682,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 			}
 
 			/* Search for matching file object */
-			for (i=0; i<MAX_NUM_APP; i++) {
+			for (i = 0; i < MAX_NUM_APP; i++) {
 				if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
 					/*DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
 					break;
@@ -766,14 +766,14 @@ static int ft1000_release(struct inode *inode, struct file *file)
 	}
 
 	/* Search for matching file object */
-	for (i=0; i<MAX_NUM_APP; i++) {
+	for (i = 0; i < MAX_NUM_APP; i++) {
 		if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
 			/* DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id); */
 			break;
 		}
 	}
 
-	if (i==MAX_NUM_APP)
+	if (i == MAX_NUM_APP)
 		return 0;
 
 	while (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
-- 
1.9.1

