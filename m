Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaDOKDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:03:50 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:65385 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaDOKDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:03:46 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, arve@android.com,
        joe@perches.com, serban.constantinescu@arm.com, prtvar.b@gmail.com,
        devel@driverdev.osuosl.org, standby24x7@gmail.com,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH RESEND 1/2] staging: binder: add __user annotation in binder.c
Date: Tue, 15 Apr 2014 12:03:05 +0200
Message-Id: <1397556186-5465-1-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.8.3.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __user to binder_version to correct sparse warning.
Reduce line size to fit to coding style.

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/android/binder.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..3dca577 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2683,16 +2683,20 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_free_thread(proc, thread);
 		thread = NULL;
 		break;
-	case BINDER_VERSION:
+	case BINDER_VERSION:{
+		struct binder_version __user *ver = ubuf;
+
 		if (size != sizeof(struct binder_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+			     &ver->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
 		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto err;
-- 
1.8.3.2

