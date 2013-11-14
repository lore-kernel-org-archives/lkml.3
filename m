Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3KNQjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:06 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49269 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3KNQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:42 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 03/39] staging/lustre/build: fix 'deadcode' errors
Date: Fri, 15 Nov 2013 00:32:26 +0800
Message-Id: <1384446782-13741-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'deadcode' issues found by Coverity version 6.5.1:
Logically dead code (DEADCODE)
Execution cannot reach this statement.

Lustre-change: http://review.whamcloud.com/7167
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3097
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index a2ef64c..e0f2f79 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -195,7 +195,7 @@ static int cfs_access_process_vm(struct task_struct *tsk, unsigned long addr,
 int cfs_get_environ(const char *key, char *value, int *val_len)
 {
 	struct mm_struct *mm;
-	char *buffer, *tmp_buf = NULL;
+	char *buffer;
 	int buf_len = PAGE_CACHE_SIZE;
 	int key_len = strlen(key);
 	unsigned long addr;
@@ -286,8 +286,6 @@ int cfs_get_environ(const char *key, char *value, int *val_len)
 out:
 	mmput(mm);
 	kfree((void *)buffer);
-	if (tmp_buf)
-		kfree((void *)tmp_buf);
 	return rc;
 }
 EXPORT_SYMBOL(cfs_get_environ);
-- 
1.7.9.5

