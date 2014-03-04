Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaCDTMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:12:42 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64050 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaCDTLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:38 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 11/12] staging: usbip: userspace: remove libsysfs flag and autoconf check
Date: Tue,  4 Mar 2014 21:10:51 +0200
Message-Id: <1393960252-21247-12-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libsysfs is now completely removed from USB/IP.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/configure.ac | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index a5193c6..25bf160 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -44,12 +44,6 @@ AC_FUNC_REALLOC
 AC_CHECK_FUNCS([memset mkdir regcomp socket strchr strerror strstr dnl
 		strtoul])
 
-AC_CHECK_HEADER([sysfs/libsysfs.h],
-		[AC_CHECK_LIB([sysfs], [sysfs_open_directory_list],
-			      [LIBS="$LIBS -lsysfs"],
-			      [AC_MSG_ERROR([Missing sysfs2 library!])])],
-		[AC_MSG_ERROR([Missing /usr/include/sysfs/libsysfs.h])])
-
 AC_CHECK_HEADER([libudev.h],
 		[AC_CHECK_LIB([udev], [udev_new],
 			      [LIBS="$LIBS -ludev"],
-- 
1.8.1.2

