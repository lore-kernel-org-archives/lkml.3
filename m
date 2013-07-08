Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3GHEj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 00:39:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57370 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3GHEj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:39:26 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dwmw2@infradead.org
Cc: artem.bityutskiy@linux.intel.com, rdunlap@infradead.org,
        robert.jarzmik@free.fr, keescook@chromium.org, shijie8@gmail.com,
        arnd@arndb.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mtd: diskonchip: remove unused entries in Kconfig
Date: Mon,  8 Jul 2013 06:39:20 +0200
Message-Id: <1373258360-22702-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove kernel configuration parameters
defined in drivers/mtd/devices/Kconfig, but used nowhere
in the makefiles and source code (except in comments).

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/mtd/devices/Kconfig   | 55 -------------------------------------------
 drivers/mtd/nand/diskonchip.c |  4 ++--
 2 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 2a4d55e..74ab4b7 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -224,59 +224,4 @@ config BCH_CONST_T
 	default 4
 endif
 
-config MTD_DOCPROBE
-	tristate
-	select MTD_DOCECC
-
-config MTD_DOCECC
-	tristate
-
-config MTD_DOCPROBE_ADVANCED
-	bool "Advanced detection options for DiskOnChip"
-	depends on MTD_DOCPROBE
-	help
-	  This option allows you to specify nonstandard address at which to
-	  probe for a DiskOnChip, or to change the detection options.  You
-	  are unlikely to need any of this unless you are using LinuxBIOS.
-	  Say 'N'.
-
-config MTD_DOCPROBE_ADDRESS
-	hex "Physical address of DiskOnChip" if MTD_DOCPROBE_ADVANCED
-	depends on MTD_DOCPROBE
-	default "0x0"
-	---help---
-	  By default, the probe for DiskOnChip devices will look for a
-	  DiskOnChip at every multiple of 0x2000 between 0xC8000 and 0xEE000.
-	  This option allows you to specify a single address at which to probe
-	  for the device, which is useful if you have other devices in that
-	  range which get upset when they are probed.
-
-	  (Note that on PowerPC, the normal probe will only check at
-	  0xE4000000.)
-
-	  Normally, you should leave this set to zero, to allow the probe at
-	  the normal addresses.
-
-config MTD_DOCPROBE_HIGH
-	bool "Probe high addresses"
-	depends on MTD_DOCPROBE_ADVANCED
-	help
-	  By default, the probe for DiskOnChip devices will look for a
-	  DiskOnChip at every multiple of 0x2000 between 0xC8000 and 0xEE000.
-	  This option changes to make it probe between 0xFFFC8000 and
-	  0xFFFEE000.  Unless you are using LinuxBIOS, this is unlikely to be
-	  useful to you.  Say 'N'.
-
-config MTD_DOCPROBE_55AA
-	bool "Probe for 0x55 0xAA BIOS Extension Signature"
-	depends on MTD_DOCPROBE_ADVANCED
-	help
-	  Check for the 0x55 0xAA signature of a DiskOnChip, and do not
-	  continue with probing if it is absent.  The signature will always be
-	  present for a DiskOnChip 2000 or a normal DiskOnChip Millennium.
-	  Only if you have overwritten the first block of a DiskOnChip
-	  Millennium will it be absent.  Enable this option if you are using
-	  LinuxBIOS or if you need to recover a DiskOnChip Millennium on which
-	  you have managed to wipe the first block.
-
 endmenu
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 81fa578..eaa3c29 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -46,13 +46,13 @@ static unsigned long __initdata doc_locations[] = {
 	0xfffd8000, 0xfffda000, 0xfffdc000, 0xfffde000,
 	0xfffe0000, 0xfffe2000, 0xfffe4000, 0xfffe6000,
 	0xfffe8000, 0xfffea000, 0xfffec000, 0xfffee000,
-#else /*  CONFIG_MTD_DOCPROBE_HIGH */
+#else
 	0xc8000, 0xca000, 0xcc000, 0xce000,
 	0xd0000, 0xd2000, 0xd4000, 0xd6000,
 	0xd8000, 0xda000, 0xdc000, 0xde000,
 	0xe0000, 0xe2000, 0xe4000, 0xe6000,
 	0xe8000, 0xea000, 0xec000, 0xee000,
-#endif /*  CONFIG_MTD_DOCPROBE_HIGH */
+#endif
 #endif
 	0xffffffff };
 
-- 
1.8.1.2

