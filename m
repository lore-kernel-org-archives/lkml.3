Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbaEJTzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:55:46 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33171 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbaEJTzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:55:43 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v2 4/5] drivers: staging: ft1000: Remove typedefs
Date: Sun, 11 May 2014 10:54:23 +0300
Message-Id: <1399794864-28705-5-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
References: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove typedefs according to the "Chapter 5: Typedefs" from
Documentation/CodingStyle.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |   10 +++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h |   18 +++++++++---------
 2 files changed, 14 insertions(+), 14 deletions(-)

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
index 5c5e79f..43209a1 100644
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
-- 
1.7.10.4

