Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaLZX1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:27:15 -0500
Received: from mail.ispras.ru ([83.149.199.45]:53404 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaLZX1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:27:13 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: lustre: do not ignore try_module_get() fail in obd_class_open()
Date: Sat, 27 Dec 2014 02:26:53 +0300
Message-Id: <1419636413-17452-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

obd_class_open() ignores error code of try_module_get(),
while it can lead to race with module unload.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 66ceab20c743..bb4bc72ddac7 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -168,8 +168,7 @@ EXPORT_SYMBOL(obd_ioctl_popdata);
 /*  opening /dev/obd */
 static int obd_class_open(struct inode *inode, struct file *file)
 {
-	try_module_get(THIS_MODULE);
-	return 0;
+	return try_module_get(THIS_MODULE);
 }
 
 /*  closing /dev/obd */
-- 
1.9.1

