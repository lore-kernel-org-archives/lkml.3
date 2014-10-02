Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaJBQUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:20:37 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62410 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaJBQUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:20:35 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        manfred@colorfullife.com, aquini@redhat.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipc: compat_mq  sizeof() instead of sizeof
Date: Thu,  2 Oct 2014 17:20:28 +0100
Message-Id: <1412266828-4274-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added a parenthesis for sizeof function

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/compat_mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index ef6f91c..27496d9 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -25,7 +25,7 @@ struct compat_mq_attr {
 static inline int get_compat_mq_attr(struct mq_attr *attr,
 			const struct compat_mq_attr __user *uattr)
 {
-	if (!access_ok(VERIFY_READ, uattr, sizeof *uattr))
+	if (!access_ok(VERIFY_READ, uattr, sizeof(*uattr)))
 		return -EFAULT;
 
 	return __get_user(attr->mq_flags, &uattr->mq_flags)
@@ -37,7 +37,7 @@ static inline int get_compat_mq_attr(struct mq_attr *attr,
 static inline int put_compat_mq_attr(const struct mq_attr *attr,
 			struct compat_mq_attr __user *uattr)
 {
-	if (clear_user(uattr, sizeof *uattr))
+	if (clear_user(uattr, sizeof(*uattr)))
 		return -EFAULT;
 
 	return __put_user(attr->mq_flags, &uattr->mq_flags)
-- 
1.9.1

