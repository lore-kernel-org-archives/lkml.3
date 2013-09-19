Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3ISMsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:48:35 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:60326 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab3ISMsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:48:33 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: usbip-devel@lists.sourceforge.net
Cc: linux-kernel@i4.cs.fau.de, Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: Fix build with --with-tcp-wrappers
Date: Thu, 19 Sep 2013 14:47:41 +0200
Message-Id: <1379594861-13894-1-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With --with-tcp-wrappers=no specified, the build system reset LIBS to
the empty string and thus fails to link against libsysfs.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/configure.ac | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 0b0e035..a1a1267 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -69,7 +69,6 @@ AC_ARG_WITH([tcp-wrappers],
 		       [AC_MSG_RESULT([not found]); exit 1])
 	     else
 		     AC_MSG_RESULT([no]);
-		     LIBS="$saved_LIBS"
 	     fi],
 	    dnl [ACTION-IF-NOT-GIVEN]
 	    [AC_MSG_RESULT([(default)])
-- 
1.8.4

