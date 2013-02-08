Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab3BHOtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:49:40 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:50617 "EHLO
	wasted.dev.rtsoft.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758171Ab3BHOtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:49:39 -0500
X-Greylist: delayed 811 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 09:49:38 EST
To: linux-usb@vger.kernel.org
Subject: [PATCH resend] testusb: remove all mentions of 'usbfs'
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sshtylyov@dev.rtsoft.ru>
Organization: RTSoft, Inc.
Date: Fri, 8 Feb 2013 18:48:03 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302081848.03347.sshtylyov@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8a424bf40d772fedacc91862ecc86f10541fabb3 (tools/usb: remove last USBFS
user) removed 'usbfs' files from the source but retained mentions of 'usbfs'
all over the place, most importantly in the misleading error messages printed
in case USB device files are not there.  Remove all the  mentions of 'usbfs'
for good now!

Signed-off-by: Sergei Shtylyov <sshtylyov@dev.rtsoft.ru>

---
This patch is atop of 'usb-next' branch of Greg's tree...

Yes, I got that "usbfs files are missing" message on DaVinci recently, and it
sent me on the wrong trail for some time, so I'd like to egt this sorted out...

Resending as I messed out with KMail config. and not seeing the message in the
list archives...

 tools/usb/testusb.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: usb/tools/usb/testusb.c
===================================================================
--- usb.orig/tools/usb/testusb.c
+++ usb/tools/usb/testusb.c
@@ -279,8 +279,7 @@ nomem:
 
 	entry->ifnum = ifnum;
 
-	/* FIXME ask usbfs what speed; update USBDEVFS_CONNECTINFO so
-	 * it tells about high speed etc */
+	/* FIXME update USBDEVFS_CONNECTINFO so it tells about high speed etc */
 
 	fprintf(stderr, "%s speed\t%s\t%u\n",
 		speed(entry->speed), entry->name, entry->ifnum);
@@ -351,7 +350,7 @@ restart:
 	return arg;
 }
 
-static const char *usbfs_dir_find(void)
+static const char *usb_dir_find(void)
 {
 	static char udev_usb_path[] = "/dev/bus/usb";
 
@@ -380,7 +379,7 @@ int main (int argc, char **argv)
 	int			c;
 	struct testdev		*entry;
 	char			*device;
-	const char		*usbfs_dir = NULL;
+	const char		*usb_dir = NULL;
 	int			all = 0, forever = 0, not = 0;
 	int			test = -1 /* all */;
 	struct usbtest_param	param;
@@ -407,8 +406,8 @@ int main (int argc, char **argv)
 	case 'D':	/* device, if only one */
 		device = optarg;
 		continue;
-	case 'A':	/* use all devices with specified usbfs dir */
-		usbfs_dir = optarg;
+	case 'A':	/* use all devices with specified USB dir */
+		usb_dir = optarg;
 		/* FALL THROUGH */
 	case 'a':	/* use all devices */
 		device = NULL;
@@ -449,7 +448,7 @@ usage:
 			"usage: %s [options]\n"
 			"Options:\n"
 			"\t-D dev		only test specific device\n"
-			"\t-A usbfs-dir\n"
+			"\t-A usb-dir\n"
 			"\t-a		test all recognized devices\n"
 			"\t-l		loop forever(for stress test)\n"
 			"\t-t testnum	only run specified case\n"
@@ -470,18 +469,18 @@ usage:
 		goto usage;
 	}
 
-	/* Find usbfs mount point */
-	if (!usbfs_dir) {
-		usbfs_dir = usbfs_dir_find();
-		if (!usbfs_dir) {
-			fputs ("usbfs files are missing\n", stderr);
+	/* Find usb device subdirectory */
+	if (!usb_dir) {
+		usb_dir = usb_dir_find();
+		if (!usb_dir) {
+			fputs ("USB device files are missing\n", stderr);
 			return -1;
 		}
 	}
 
 	/* collect and list the test devices */
-	if (ftw (usbfs_dir, find_testdev, 3) != 0) {
-		fputs ("ftw failed; is usbfs missing?\n", stderr);
+	if (ftw (usb_dir, find_testdev, 3) != 0) {
+		fputs ("ftw failed; are USB device files missing?\n", stderr);
 		return -1;
 	}
 
