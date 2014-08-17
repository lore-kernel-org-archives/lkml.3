Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaHQTnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 15:43:10 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45159 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaHQTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 15:43:08 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/5] staging: vt6655: Use ether_crc in kernel.
Date: Sun, 17 Aug 2014 20:42:25 +0100
Message-Id: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ether_crc is already in kernel remove local code and
include linux/crc32.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  1 +
 drivers/staging/vt6655/device_main.c | 17 -----------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index e4c5292..fadebe9 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/io.h>
 #include <linux/if.h>
+#include <linux/crc32.h>
 //#include <linux/config.h>
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a44233c..95460d4 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2561,23 +2561,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static unsigned const ethernet_polynomial = 0x04c11db7U;
-static inline u32 ether_crc(int length, unsigned char *data)
-{
-	int crc = -1;
-
-	while (--length >= 0) {
-		unsigned char current_octet = *data++;
-		int bit;
-
-		for (bit = 0; bit < 8; bit++, current_octet >>= 1) {
-			crc = (crc << 1) ^
-				((crc < 0) ^ (current_octet & 1) ? ethernet_polynomial : 0);
-		}
-	}
-	return crc;
-}
-
 //2008-8-4 <add> by chester
 static int Config_FileGetParameter(unsigned char *string,
 				   unsigned char *dest, unsigned char *source)
-- 
1.9.1

