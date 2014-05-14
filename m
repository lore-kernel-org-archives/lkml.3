Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaENT2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:28:35 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57578 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaENT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:28:33 -0400
Date: Wed, 14 May 2014 21:28:27 +0200
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: Fix bad fuction definitions in usbip
Message-ID: <20140514192823.GA5491@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bad function definitions in all files from drivers/staging/usbip directory

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 +-
 drivers/staging/usbip/userspace/libsrc/vhci_driver.c  | 2 +-
 drivers/staging/usbip/userspace/src/usbip_port.c      | 2 +-
 drivers/staging/usbip/userspace/src/usbipd.c          | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 05a7443..ac73710 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -237,7 +237,7 @@ int usbip_names_init(char *f)
 	return names_init(f);
 }
 
-void usbip_names_free()
+void usbip_names_free(void)
 {
 	names_free();
 }
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 8901fcb..ad92047 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -260,7 +260,7 @@ err:
 }
 
 
-void usbip_vhci_driver_close()
+void usbip_vhci_driver_close(void)
 {
 	if (!vhci_driver)
 		return;
diff --git a/drivers/staging/usbip/userspace/src/usbip_port.c b/drivers/staging/usbip/userspace/src/usbip_port.c
index 52aa168..a2e884f 100644
--- a/drivers/staging/usbip/userspace/src/usbip_port.c
+++ b/drivers/staging/usbip/userspace/src/usbip_port.c
@@ -16,7 +16,7 @@
 #include "vhci_driver.h"
 #include "usbip_common.h"
 
-static int list_imported_devices()
+static int list_imported_devices(void)
 {
 	int i;
 	struct usbip_imported_device *idev;
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index b32047a..2f87f2d 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -458,7 +458,7 @@ static void set_signal(void)
 
 static const char *pid_file;
 
-static void write_pid_file()
+static void write_pid_file(void)
 {
 	if (pid_file) {
 		dbg("creating pid file %s", pid_file);
@@ -475,7 +475,7 @@ static void write_pid_file()
 	}
 }
 
-static void remove_pid_file()
+static void remove_pid_file(void)
 {
 	if (pid_file) {
 		dbg("removing pid file %s", pid_file);
-- 
1.8.3.2

