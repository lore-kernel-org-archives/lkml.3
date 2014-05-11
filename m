Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbaEKGPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 02:15:49 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58364 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbaEKGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 02:15:39 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v3 4/5] drivers: staging: ft1000: Remove typedefs
Date: Sun, 11 May 2014 21:14:29 +0300
Message-Id: <1399832070-15276-5-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399832070-15276-1-git-send-email-wwctrsrx@gmail.com>
References: <1399832070-15276-1-git-send-email-wwctrsrx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove typedefs according to the "Chapter 5: Typedefs" from
Documentation/CodingStyle.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |   10 ++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h |   26 +++++++++++-----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index ffdc7f5..4a3103d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -417,8 +417,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
     u16 tempword;
     unsigned long flags;
     struct timeval tv;
-    IOCTL_GET_VER get_ver_data;
-    IOCTL_GET_DSP_STAT get_stat_data;
+	struct IOCTL_GET_VER get_ver_data;
+	struct IOCTL_GET_DSP_STAT get_stat_data;
     u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
                           0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
                           0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
@@ -527,8 +527,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
         break;
     case IOCTL_SET_DPRAM_CMD:
         {
-            IOCTL_DPRAM_BLK *dpram_data = NULL;
-            /* IOCTL_DPRAM_COMMAND dpram_command; */
+		struct IOCTL_DPRAM_BLK *dpram_data = NULL;
+		/* struct IOCTL_DPRAM_COMMAND dpram_command; */
             u16 qtype;
             u16 msgsz;
 		struct pseudo_hdr *ppseudo_hdr;
@@ -672,7 +672,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
     case IOCTL_GET_DPRAM_CMD:
         {
 		struct dpram_blk *pdpram_blk;
-            IOCTL_DPRAM_BLK __user *pioctl_dpram;
+		struct IOCTL_DPRAM_BLK __user *pioctl_dpram;
             int msglen;
 
             /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\n"); */
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index 5c5e79f..c10d518 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -28,12 +28,12 @@
 #ifndef _FT1000IOCTLH_
 #define _FT1000IOCTLH_
 
-typedef struct _IOCTL_GET_VER {
+struct IOCTL_GET_VER {
 	unsigned long drv_ver;
-} __packed IOCTL_GET_VER, *PIOCTL_GET_VER;
+} __packed;
 
 /* Data structure for Dsp statistics */
-typedef struct _IOCTL_GET_DSP_STAT {
+struct IOCTL_GET_DSP_STAT {
 	unsigned char DspVer[DSPVERSZ];        /* DSP version number */
 	unsigned char HwSerNum[HWSERNUMSZ];    /* Hardware Serial Number */
 	unsigned char Sku[SKUSZ];              /* SKU */
@@ -67,19 +67,19 @@ typedef struct _IOCTL_GET_DSP_STAT {
 	unsigned long ConTm;                  /* Current session connection time in seconds */
 	unsigned char CalVer[CALVERSZ];       /* Proprietary Calibration Version */
 	unsigned char CalDate[CALDATESZ];     /* Proprietary Calibration Date */
-} __packed IOCTL_GET_DSP_STAT, *PIOCTL_GET_DSP_STAT;
+} __packed;
 
 /* Data structure for Dual Ported RAM messaging between Host and Dsp */
-typedef struct _IOCTL_DPRAM_BLK {
+struct IOCTL_DPRAM_BLK {
 	unsigned short total_len;
 	struct pseudo_hdr pseudohdr;
 	unsigned char buffer[1780];
-} __packed IOCTL_DPRAM_BLK, *PIOCTL_DPRAM_BLK;
+} __packed;
 
-typedef struct _IOCTL_DPRAM_COMMAND {
+struct IOCTL_DPRAM_COMMAND {
 	unsigned short extra;
-	IOCTL_DPRAM_BLK dpram_blk;
-} __packed IOCTL_DPRAM_COMMAND, *PIOCTL_DPRAM_COMMAND;
+	struct IOCTL_DPRAM_BLK dpram_blk;
+} __packed;
 
 /*
 * Custom IOCTL command codes
@@ -94,12 +94,12 @@ typedef struct _IOCTL_DPRAM_COMMAND {
 #define IOCTL_CONNECT		10
 #define IOCTL_DISCONNECT	11
 
-#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, IOCTL_GET_DSP_STAT)
-#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, IOCTL_GET_VER)
+#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, struct IOCTL_GET_DSP_STAT)
+#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, struct IOCTL_GET_VER)
 #define IOCTL_FT1000_CONNECT _IO(FT1000_MAGIC_CODE, IOCTL_CONNECT)
 #define IOCTL_FT1000_DISCONNECT _IO(FT1000_MAGIC_CODE, IOCTL_DISCONNECT)
-#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, struct IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, struct IOCTL_DPRAM_BLK)
 #define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, unsigned short *)
 
 #endif /* _FT1000IOCTLH_ */
-- 
1.7.10.4

