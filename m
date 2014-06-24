Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaFXIpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:45:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40673 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaFXIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:45:44 -0400
Date: Tue, 24 Jun 2014 09:45:40 +0100
From: Daniel Walter <dwalter@google.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] arch/mips rb532: replace mac_addr parsing
Message-ID: <20140624084540.GA22930@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace parse_mac_addr with sscanf.


Signed-off-by: Daniel Walter <dwalter@google.com>
---
Changes since v1:
  sending in the working patch
Patch applies against current linux-tree
---
 arch/mips/rb532/devices.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)
---
diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 3af00b2..6e32819b 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -250,28 +250,6 @@ static struct platform_device *rb532_devs[] = {
 	&rb532_wdt
 };
 
-static void __init parse_mac_addr(char *macstr)
-{
-	int i, h, l;
-
-	for (i = 0; i < 6; i++) {
-		if (i != 5 && *(macstr + 2) != ':')
-			return;
-
-		h = hex_to_bin(*macstr++);
-		if (h == -1)
-			return;
-
-		l = hex_to_bin(*macstr++);
-		if (l == -1)
-			return;
-
-		macstr++;
-		korina_dev0_data.mac[i] = (h << 4) + l;
-	}
-}
-
-
 /* NAND definitions */
 #define NAND_CHIP_DELAY 25
 
@@ -333,7 +311,13 @@ static int __init plat_setup_devices(void)
 static int __init setup_kmac(char *s)
 {
 	printk(KERN_INFO "korina mac = %s\n", s);
-	parse_mac_addr(s);
+	sscanf(s, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
+			&korina_dev0_data.mac[0],
+			&korina_dev0_data.mac[1],
+			&korina_dev0_data.mac[2],
+			&korina_dev0_data.mac[3],
+			&korina_dev0_data.mac[4],
+			&korina_dev0_data.mac[5]);
 	return 0;
 }
 
