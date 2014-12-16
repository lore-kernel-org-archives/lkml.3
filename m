Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaLPHmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:42:24 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39627 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaLPHmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:42:22 -0500
From: sunwxg <sun.wxg@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Silvio Fricke <silvio.fricke@gmail.com>
Cc: Sun Wang <sun.wxg@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging:vt6655 Add extern variable in head file
Date: Tue, 16 Dec 2014 15:39:50 +0800
Message-Id: <1418715590-10074-2-git-send-email-sun.wxg@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sun Wang <sun.wxg@gmail.com>

Subject: [PATCH] staging:vt6655 Add extern variable in head file

Extern variable must be declared in head file. Compiler can catch the inconsistency when variable changes. 

Signed-off-by: Sun Wang <sun.wxg@gmail.com>

---
 drivers/staging/vt6655/ioctl.c | 1 -
 drivers/staging/vt6655/ioctl.h | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 970e80d..716fc89 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -31,7 +31,6 @@
  */
 
 #include "ioctl.h"
-#include "iocmd.h"
 #include "mac.h"
 #include "card.h"
 #include "hostap.h"
diff --git a/drivers/staging/vt6655/ioctl.h b/drivers/staging/vt6655/ioctl.h
index 2dc5a57..42f6910 100644
--- a/drivers/staging/vt6655/ioctl.h
+++ b/drivers/staging/vt6655/ioctl.h
@@ -30,6 +30,11 @@
 #define __IOCTL_H__
 
 #include "device.h"
+#include "iocmd.h"
+
+#ifdef WPA_SM_Transtatus
+extern SWPAResult wpa_Result;
+#endif
 
 int private_ioctl(struct vnt_private *, struct ifreq *rq);
 
