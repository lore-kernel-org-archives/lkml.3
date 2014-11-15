Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaKOO3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 09:29:36 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51215 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbaKOO3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 09:29:34 -0500
Date: Sat, 15 Nov 2014 15:25:35 +0100
From: Christian Resell <christian.resell@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, marcus.farkas@finitebox.com,
        dan.carpenter@oracle.com, sudipm.mukherjee@gmail.com,
        paul.gortmaker@windriver.com, tapaswenipathak@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: fix coding style warning
Message-ID: <20141115142535.GB15904@Kosekroken.jensen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple style fix ("else is not generally useful after a break or return").
For the eudyptula challenge (http://eudyptula-challenge.org/).

Signed-off-by: Christian F. Resell <christian.resell@gmail.com>
---
diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index c653ad6..cc3a446 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -126,26 +126,24 @@ static void crc32_init(void)
 {
 	if (bcrc32initialized == 1)
 		return;
-	else {
-		sint i, j;
-		u32 c;
-		u8 *p = (u8 *)&c, *p1;
-		u8 k;
-
-		c = 0x12340000;
-		for (i = 0; i < 256; ++i) {
-			k = crc32_reverseBit((u8)i);
-			for (c = ((u32)k) << 24, j = 8; j > 0; --j)
-				c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY :
-				    (c << 1);
-			p1 = (u8 *)&crc32_table[i];
-			p1[0] = crc32_reverseBit(p[3]);
-			p1[1] = crc32_reverseBit(p[2]);
-			p1[2] = crc32_reverseBit(p[1]);
-			p1[3] = crc32_reverseBit(p[0]);
-		}
-		bcrc32initialized = 1;
+	sint i, j;
+	u32 c;
+	u8 *p = (u8 *)&c, *p1;
+	u8 k;
+
+	c = 0x12340000;
+	for (i = 0; i < 256; ++i) {
+		k = crc32_reverseBit((u8)i);
+		for (c = ((u32)k) << 24, j = 8; j > 0; --j)
+			c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY :
+				(c << 1);
+		p1 = (u8 *)&crc32_table[i];
+		p1[0] = crc32_reverseBit(p[3]);
+		p1[1] = crc32_reverseBit(p[2]);
+		p1[2] = crc32_reverseBit(p[1]);
+		p1[3] = crc32_reverseBit(p[0]);
 	}
+	bcrc32initialized = 1;
 }
 
 static u32 getcrc32(u8 *buf, u32 len)
