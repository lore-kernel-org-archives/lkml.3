Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914Ab3HREDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 00:03:43 -0400
Received: from 25.seven.greendata.pl ([91.228.196.25]:40692 "EHLO
	vz1947.biznes-host.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733Ab3HREDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 00:03:42 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Aug 2013 00:03:42 EDT
From: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Organization: tigusoft.pl
To: linux-kernel@vger.kernel.org
Subject: howto make define seen in all files?
Date: Sun, 18 Aug 2013 05:56:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.46-grsec-good.0.1.6; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9XEESf5pU+ugMBO"
Message-Id: <201308180556.45833.lkml@tigusoft.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9XEESf5pU+ugMBO
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, I want to provide a general defined macro like __MY__TIME__ (for 
determinictic build) and that symbol should be seen as #define or -D... to gcc 
in all files;

Value of __MY_TIME__ is determined once, at start of build.

I was using file scripts/mkcompile_h as in the attached .diff patch, worked in 
3.2.48 but in 3.2.50 files do not see the value _MY_BUILD__TIME__


--Boundary-00=_9XEESf5pU+ugMBO
Content-Type: text/x-patch;
  charset="UTF-8";
  name="linux-3.2.48-deterministic-build.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-3.2.48-deterministic-build.diff"

diff -uprN a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
--- a/arch/x86/math-emu/errors.c	2013-06-29 05:06:45.000000000 +0200
+++ b/arch/x86/math-emu/errors.c	2013-07-25 15:46:14.922972587 +0200
@@ -332,7 +332,7 @@ asmlinkage void FPU_exception(int n)
 	if ((~control_word & n & CW_Exceptions) || (n == EX_INTERNAL)) {
 #ifdef PRINT_MESSAGES
 		/* My message from the sponsor */
-		printk(FPU_VERSION " " __DATE__ " (C) W. Metzenthen.\n");
+		printk(FPU_VERSION " " _MY_BUILD__DATE__ " (C) W. Metzenthen.\n");
 #endif /* PRINT_MESSAGES */
 
 		/* Get a name string for error reporting */
diff -uprN a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c	2013-06-29 05:06:45.000000000 +0200
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c	2013-07-25 15:46:06.990972484 +0200
@@ -43,7 +43,7 @@ int brcmf_msg_level;
 #ifdef BCMDBG
 static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on "
-	__DATE__ " at " __TIME__;
+	_MY_BUILD__TIME__ " at " _MY_BUILD__DATE__;
 #else
 static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR;
diff -uprN a/drivers/staging/rts5139/rts51x_scsi.c b/drivers/staging/rts5139/rts51x_scsi.c
--- a/drivers/staging/rts5139/rts51x_scsi.c	2013-06-29 05:06:45.000000000 +0200
+++ b/drivers/staging/rts5139/rts51x_scsi.c	2013-07-25 15:46:03.808972463 +0200
@@ -2067,7 +2067,7 @@ int proc_info(struct Scsi_Host *host, ch
 	SPRINTF("       Vendor: Realtek Corp.\n");
 	SPRINTF("      Product: RTS51xx USB Card Reader\n");
 	SPRINTF("      Version: %s\n", DRIVER_VERSION);
-	SPRINTF("        Build: %s\n", __TIME__);
+	SPRINTF("        Build: %s\n", _MY_BUILD__TIME__);
 
 	/*
 	 * Calculate start of next buffer, and return value.
diff -uprN a/drivers/staging/wlags49_h2/wl_version.h b/drivers/staging/wlags49_h2/wl_version.h
--- a/drivers/staging/wlags49_h2/wl_version.h	2013-06-29 05:06:45.000000000 +0200
+++ b/drivers/staging/wlags49_h2/wl_version.h	2013-07-25 15:46:19.639972804 +0200
@@ -130,7 +130,7 @@ err: define bus type;
 #endif  /* BUS_XXX */
 
 #ifdef DBG
-#define MODULE_DATE         __DATE__ " " __TIME__
+#define MODULE_DATE         _MY_BUILD__DATE__ " " _MY_BUILD__TIME__
 #else
 #define MODULE_DATE         "07/18/2004 13:30:00"
 #endif // DBG
diff -uprN a/fs/ubifs/super.c b/fs/ubifs/super.c
--- a/fs/ubifs/super.c	2013-06-29 05:06:45.000000000 +0200
+++ b/fs/ubifs/super.c	2013-07-25 15:46:11.783972639 +0200
@@ -1435,7 +1435,7 @@ static int mount_ubifs(struct ubifs_info
 	ubifs_msg("reserved for root:  %llu bytes (%llu KiB)",
 		c->report_rp_size, c->report_rp_size >> 10);
 
-	dbg_msg("compiled on:         " __DATE__ " at " __TIME__);
+	dbg_msg("compiled on:         " _MY_BUILD__DATE__ " at " _MY_BUILD__TIME__);
 	dbg_msg("min. I/O unit size:  %d bytes", c->min_io_size);
 	dbg_msg("max. write size:     %d bytes", c->max_write_size);
 	dbg_msg("LEB size:            %d bytes (%d KiB)",
diff -uprN a/scripts/mkcompile_h b/scripts/mkcompile_h
--- a/scripts/mkcompile_h	2013-06-29 05:06:45.000000000 +0200
+++ b/scripts/mkcompile_h	2013-07-25 15:45:47.194972240 +0200
@@ -42,6 +42,11 @@ if [ -z "$KBUILD_BUILD_TIMESTAMP" ]; the
 else
 	TIMESTAMP=$KBUILD_BUILD_TIMESTAMP
 fi
+
+# create _MY_BUILD__TIME__ instead __TIME__ (and DATE) deterministic build
+_MY_BUILD__TIME__=`date  -d "$TIMESTAMP"  "+%H:%M:%S"`
+_MY_BUILD__DATE__=`date  -d "$TIMESTAMP"  "+%b %d %Y"`
+
 if test -z "$KBUILD_BUILD_USER"; then
 	LINUX_COMPILE_BY=$(whoami | sed 's/\\/\\\\/')
 else

--Boundary-00=_9XEESf5pU+ugMBO--
