Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaDFAO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 20:14:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52715 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaDFAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 20:14:18 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ashmem: Fix coding style
Date: Sat,  5 Apr 2014 17:13:56 -0700
Message-Id: <1396743236-5653-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep checkpatch happy by addressing the following:
CHECK: Alignment should match open parenthesis
CHECK: Blank lines aren't necessary after an open brace '{'
CHECK: No space is necessary after a cast

Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
---
 drivers/staging/android/ashmem.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 713a972..d441b65 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -447,8 +447,8 @@ ashmem_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		loff_t end = (range->pgend + 1) * PAGE_SIZE;
 
 		do_fallocate(range->asma->file,
-				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				start, end - start);
+			     FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			     start, end - start);
 		range->purged = ASHMEM_WAS_PURGED;
 		lru_del(range);
 
@@ -549,7 +549,6 @@ static int get_name(struct ashmem_area *asma, void __user *name)
 
 	mutex_lock(&ashmem_mutex);
 	if (asma->name[ASHMEM_NAME_PREFIX_LEN] != '\0') {
-
 		/*
 		 * Copying only `len', instead of ASHMEM_NAME_LEN, bytes
 		 * prevents us from revealing one user's stack to another.
@@ -751,10 +750,10 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case ASHMEM_SET_NAME:
-		ret = set_name(asma, (void __user *) arg);
+		ret = set_name(asma, (void __user *)arg);
 		break;
 	case ASHMEM_GET_NAME:
-		ret = get_name(asma, (void __user *) arg);
+		ret = get_name(asma, (void __user *)arg);
 		break;
 	case ASHMEM_SET_SIZE:
 		ret = -EINVAL;
@@ -775,7 +774,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case ASHMEM_PIN:
 	case ASHMEM_UNPIN:
 	case ASHMEM_GET_PIN_STATUS:
-		ret = ashmem_pin_unpin(asma, cmd, (void __user *) arg);
+		ret = ashmem_pin_unpin(asma, cmd, (void __user *)arg);
 		break;
 	case ASHMEM_PURGE_ALL_CACHES:
 		ret = -EPERM;
@@ -799,7 +798,6 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static long compat_ashmem_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-
 	switch (cmd) {
 	case COMPAT_ASHMEM_SET_SIZE:
 		cmd = ASHMEM_SET_SIZE;
-- 
1.8.3.2

