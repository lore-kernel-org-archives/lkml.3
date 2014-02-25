Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaBYKlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:41:14 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:51323 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBYKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:40:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 4/4] spi: spidev_fdx: Add support for Dual/Quad SPI Transfers
Date: Tue, 25 Feb 2014 11:40:19 +0100
Message-Id: <1393324819-3810-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
References: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Use SPI_IOC_RD_MODE32 to print the full SPI mode, now in hex.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - New

 Documentation/spi/spidev_fdx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/spi/spidev_fdx.c b/Documentation/spi/spidev_fdx.c
index 36ec0774ca0b..0ea3e51292fc 100644
--- a/Documentation/spi/spidev_fdx.c
+++ b/Documentation/spi/spidev_fdx.c
@@ -78,10 +78,10 @@ static void do_msg(int fd, int len)
 
 static void dumpstat(const char *name, int fd)
 {
-	__u8	mode, lsb, bits;
-	__u32	speed;
+	__u8	lsb, bits;
+	__u32	mode, speed;
 
-	if (ioctl(fd, SPI_IOC_RD_MODE, &mode) < 0) {
+	if (ioctl(fd, SPI_IOC_RD_MODE32, &mode) < 0) {
 		perror("SPI rd_mode");
 		return;
 	}
@@ -98,7 +98,7 @@ static void dumpstat(const char *name, int fd)
 		return;
 	}
 
-	printf("%s: spi mode %d, %d bits %sper word, %d Hz max\n",
+	printf("%s: spi mode 0x%x, %d bits %sper word, %d Hz max\n",
 		name, mode, bits, lsb ? "(lsb first) " : "", speed);
 }
 
-- 
1.7.9.5

