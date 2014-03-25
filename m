Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaCYWDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:03:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34351 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaCYWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:03:42 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arve@android.com, gregkh@linuxfoundation.org, joe@perches.com,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH 2/2] staging: binder: Code simplification
Date: Tue, 25 Mar 2014 23:03:21 +0100
Message-Id: <1395785001-4153-2-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395785001-4153-1-git-send-email-mathieu.maret@gmail.com>
References: <1395785001-4153-1-git-send-email-mathieu.maret@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/android/binder.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 6d8ee37..67aaa38 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2685,11 +2685,9 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	case BINDER_VERSION: {
 		struct binder_version __user *ver = ubuf;
-		if (size != sizeof(struct binder_version)) {
-			ret = -EINVAL;
-			goto err;
-		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+
+		if (size != sizeof(struct binder_version) ||
+			put_user(BINDER_CURRENT_PROTOCOL_VERSION,
 			&ver->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
-- 
1.9.1

