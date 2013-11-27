Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab3K0WEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:04:21 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40129 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3K0WET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:04:19 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] fix printk output
Date: Thu, 28 Nov 2013 02:03:59 +0400
Message-Id: <1385589839-11767-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 kernel/module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index f5a3b1e..6f87299 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -817,7 +817,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 
 	if (!(flags & O_NONBLOCK)) {
 		printk(KERN_WARNING
-		       "waiting module removal not supported: please upgrade");
+		       "waiting module removal not supported: "
+		       "please upgrade\n");
 	}
 
 	if (mutex_lock_interruptible(&module_mutex) != 0)
-- 
1.8.4.2

