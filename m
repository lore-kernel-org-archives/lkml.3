Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaCYWDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:03:38 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51240 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaCYWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:03:36 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arve@android.com, gregkh@linuxfoundation.org, joe@perches.com,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCHv2 1/2] staging: binder: add __user annotation in binder.c
Date: Tue, 25 Mar 2014 23:03:20 +0100
Message-Id: <1395785001-4153-1-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __user to binder_version and correct sparse warning.
Reduce line size to fit to coding style.

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/android/binder.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..6d8ee37 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2683,16 +2683,19 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_free_thread(proc, thread);
 		thread = NULL;
 		break;
-	case BINDER_VERSION:
+	case BINDER_VERSION: {
+		struct binder_version __user *ver = ubuf;
 		if (size != sizeof(struct binder_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+			&ver->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
 		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto err;
-- 
1.9.1

