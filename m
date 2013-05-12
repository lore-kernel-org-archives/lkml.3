Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3ELXJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 19:09:23 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63153 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab3ELXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 19:09:22 -0400
Message-ID: <1368400159.1350.25.camel@x61.thuisdomein>
Subject: [PATCH] mtd: doc: remove Kconfig traces of Doc 2000/2001/2001+
From: Paul Bolle <pebolle@tiscali.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 01:09:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2013 23:09:20.0204 (UTC) FILETIME=[BBD6F0C0:01CE4F65]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b5a6c3095f ("mtd: doc: remove support for DoC 2000/2001/2001+")
made the Kconfig symbols MTD_DOCECC, MTD_DOCPROBE_ADDRESS, and
MTD_DOCPROBE_55AA unused. Thus, kill this ancient cruft too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/mtd/devices/Kconfig | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 2a4d55e..dc01c59 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -226,10 +226,6 @@ endif
 
 config MTD_DOCPROBE
 	tristate
-	select MTD_DOCECC
-
-config MTD_DOCECC
-	tristate
 
 config MTD_DOCPROBE_ADVANCED
 	bool "Advanced detection options for DiskOnChip"
@@ -240,23 +236,6 @@ config MTD_DOCPROBE_ADVANCED
 	  are unlikely to need any of this unless you are using LinuxBIOS.
 	  Say 'N'.
 
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
 config MTD_DOCPROBE_HIGH
 	bool "Probe high addresses"
 	depends on MTD_DOCPROBE_ADVANCED
@@ -267,16 +246,4 @@ config MTD_DOCPROBE_HIGH
 	  0xFFFEE000.  Unless you are using LinuxBIOS, this is unlikely to be
 	  useful to you.  Say 'N'.
 
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
-- 
1.7.11.7

