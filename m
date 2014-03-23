Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaCWSnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:43:37 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55389 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaCWSng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:43:36 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Use RCU_INIT_POINTER(x, NULL) in aio.c
Date: Mon, 24 Mar 2014 00:12:31 +0530
Message-Id: <1395600151-8911-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..c3d3eb6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -775,7 +775,7 @@ void exit_aio(struct mm_struct *mm)
 		do {
 			if (!table || i >= table->nr) {
 				rcu_read_unlock();
-				rcu_assign_pointer(mm->ioctx_table, NULL);
+				RCU_INIT_POINTER(mm->ioctx_table, NULL);
 				if (table)
 					kfree(table);
 				return;
-- 
1.7.9.5

