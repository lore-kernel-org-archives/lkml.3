Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3H3HDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:03:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53287 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3H3HDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:03:52 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: klmckinney1@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: bcm: remove Version.h file.
Date: Fri, 30 Aug 2013 12:31:51 +0530
Message-Id: <1377846111-25543-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

many of the macros defined in Version.h are not being used,
so we can remove the file.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/bcm/Bcmchar.c |    4 ++--
 drivers/staging/bcm/Version.h |   29 -----------------------------
 drivers/staging/bcm/headers.h |    3 +--
 3 files changed, 3 insertions(+), 33 deletions(-)
 delete mode 100644 drivers/staging/bcm/Version.h

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index f67a225..f91bc1f 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1004,9 +1004,9 @@ cntrlEnd:
 		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
 			return -EFAULT;
 
-		len = min_t(ulong, IoBuffer.OutputLength, strlen(VER_FILEVERSION_STR) + 1);
+		len = min_t(ulong, IoBuffer.OutputLength, strlen(DRV_VERSION) + 1);
 
-		if (copy_to_user(IoBuffer.OutputBuffer, VER_FILEVERSION_STR, len))
+		if (copy_to_user(IoBuffer.OutputBuffer, DRV_VERSION, len))
 			return -EFAULT;
 		Status = STATUS_SUCCESS;
 		break;
diff --git a/drivers/staging/bcm/Version.h b/drivers/staging/bcm/Version.h
deleted file mode 100644
index f1cb9de..0000000
--- a/drivers/staging/bcm/Version.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*Copyright (c) 2005 Beceem Communications Inc.
-
-Module Name:
-
-  Version.h
-
-Abstract:
-
-
---*/
-
-#ifndef VERSION_H
-#define VERSION_H
-
-
-#define VER_FILETYPE                VFT_DRV
-#define VER_FILESUBTYPE             VFT2_DRV_NETWORK
-
-#define VER_FILEVERSION             5.2.45
-#define VER_FILEVERSION_STR         "5.2.45"
-
-#undef VER_PRODUCTVERSION
-#define VER_PRODUCTVERSION          VER_FILEVERSION
-
-#undef VER_PRODUCTVERSION_STR
-#define VER_PRODUCTVERSION_STR      VER_FILEVERSION_STR
-
-
-#endif /* VERSION_H */
diff --git a/drivers/staging/bcm/headers.h b/drivers/staging/bcm/headers.h
index da47db8..7fd21c6 100644
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@ -38,7 +38,6 @@
 #include <net/ip.h>
 
 #include "Typedefs.h"
-#include "Version.h"
 #include "Macros.h"
 #include "HostMIBSInterface.h"
 #include "cntrl_SignalingInterface.h"
@@ -71,7 +70,7 @@
 #define DEV_NAME	"tarang"
 #define DRV_DESCRIPTION "Beceem Communications Inc. WiMAX driver"
 #define DRV_COPYRIGHT	"Copyright 2010. Beceem Communications Inc"
-#define DRV_VERSION	VER_FILEVERSION_STR
+#define DRV_VERSION	"5.2.45"
 #define PFX		DRV_NAME " "
 
 extern struct class *bcm_class;
-- 
1.7.10.4

