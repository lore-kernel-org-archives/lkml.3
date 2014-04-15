Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaDOKDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:03:55 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62454 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaDOKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:03:52 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, arve@android.com,
        joe@perches.com, serban.constantinescu@arm.com, prtvar.b@gmail.com,
        devel@driverdev.osuosl.org, standby24x7@gmail.com,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH RESEND 2/2] staging: binder: Code simplification
Date: Tue, 15 Apr 2014 12:03:06 +0200
Message-Id: <1397556186-5465-2-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397556186-5465-1-git-send-email-mathieu.maret@gmail.com>
References: <1397556186-5465-1-git-send-email-mathieu.maret@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/android/binder.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 3dca577..c29c3c7 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2686,11 +2686,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case BINDER_VERSION:{
 		struct binder_version __user *ver = ubuf;
 
-		if (size != sizeof(struct binder_version)) {
-			ret = -EINVAL;
-			goto err;
-		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+		if (size != sizeof(struct binder_version) ||
+		    put_user(BINDER_CURRENT_PROTOCOL_VERSION,
 			     &ver->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
-- 
1.8.3.2

