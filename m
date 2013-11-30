Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3K3PnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:43:01 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:59253 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3K3PnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:43:00 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v2] fix printk output
Date: Sat, 30 Nov 2013 19:42:32 +0400
Message-Id: <1385826152-17531-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <20131127220746.GA11255@order.stressinduktion.org>
References: <20131127220746.GA11255@order.stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 Changes v1..v2
 * 1-for-1 match between source and output lines
 * clarify warning
 * print tool name to avoid confusion with what to upgrade

 kernel/module.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index f5a3b1e..0e627e7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -816,8 +816,10 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	name[MODULE_NAME_LEN-1] = '\0';
 
 	if (!(flags & O_NONBLOCK)) {
+		char tool[TASK_COMM_LEN];
 		printk(KERN_WARNING
-		       "waiting module removal not supported: please upgrade");
+		       "waiting module removal no longer supported\n"
+		       "please upgrade %s\n", get_task_comm(tool, current));
 	}
 
 	if (mutex_lock_interruptible(&module_mutex) != 0)
-- 
1.8.4.3

