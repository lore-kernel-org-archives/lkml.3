Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaEJT4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:56:32 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63487 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbaEJTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:55:37 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v2 2/5] drivers: staging: ft1000: Fix IOCTL_FT1000_* marcos
Date: Sun, 11 May 2014 10:54:21 +0300
Message-Id: <1399794864-28705-3-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
References: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes include:
 - Add closing brackets;
 - Remove sizeof (_IOR and _IOW macro can accept types);
 - Replace _IOW which size of 0 (the last arg) with _IO.
 - Actually these macros are not used anywhere and might be removed.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index ad4bf8a..5c5e79f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -94,12 +94,12 @@ typedef struct _IOCTL_DPRAM_COMMAND {
 #define IOCTL_CONNECT		10
 #define IOCTL_DISCONNECT	11
 
-#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, sizeof(IOCTL_GET_DSP_STAT)
-#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, sizeof(IOCTL_GET_VER)
-#define IOCTL_FT1000_CONNECT _IOW(FT1000_MAGIC_CODE, IOCTL_CONNECT, 0
-#define IOCTL_FT1000_DISCONNECT _IOW(FT1000_MAGIC_CODE, IOCTL_DISCONNECT, 0
-#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, sizeof(IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, sizeof(IOCTL_DPRAM_BLK)
-#define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, sizeof(unsigned short *)
-#endif /* _FT1000IOCTLH_ */
+#define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, IOCTL_GET_DSP_STAT)
+#define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, IOCTL_GET_VER)
+#define IOCTL_FT1000_CONNECT _IO(FT1000_MAGIC_CODE, IOCTL_CONNECT)
+#define IOCTL_FT1000_DISCONNECT _IO(FT1000_MAGIC_CODE, IOCTL_DISCONNECT)
+#define IOCTL_FT1000_SET_DPRAM _IOW(FT1000_MAGIC_CODE, IOCTL_SET_DPRAM_CMD, IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_GET_DPRAM _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DPRAM_CMD, IOCTL_DPRAM_BLK)
+#define IOCTL_FT1000_REGISTER  _IOW(FT1000_MAGIC_CODE, IOCTL_REGISTER_CMD, unsigned short *)
 
+#endif /* _FT1000IOCTLH_ */
-- 
1.7.10.4

