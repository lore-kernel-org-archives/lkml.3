Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbaFZRLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:11:47 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:21823 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684AbaFZRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:11:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KAIBTrFNXQz8N/2dsb2JhbABagw2rRQUBAQEBAQEFAW2Yf4ENF3WEMS8jgRo3iEYBwX8XhWSJHB2ELQWPeopfizqIO4IAgUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/dlm/debug_fs.c: remove unnecessary null test before debugfs_remove
Date: Thu, 26 Jun 2014 19:10:22 +0200
Message-Id: <1403802622-8511-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: cluster-devel@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/dlm/debug_fs.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 8d77ba7..1323c56 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -718,16 +718,11 @@ static const struct file_operations waiters_fops = {
 
 void dlm_delete_debug_file(struct dlm_ls *ls)
 {
-	if (ls->ls_debug_rsb_dentry)
-		debugfs_remove(ls->ls_debug_rsb_dentry);
-	if (ls->ls_debug_waiters_dentry)
-		debugfs_remove(ls->ls_debug_waiters_dentry);
-	if (ls->ls_debug_locks_dentry)
-		debugfs_remove(ls->ls_debug_locks_dentry);
-	if (ls->ls_debug_all_dentry)
-		debugfs_remove(ls->ls_debug_all_dentry);
-	if (ls->ls_debug_toss_dentry)
-		debugfs_remove(ls->ls_debug_toss_dentry);
+	debugfs_remove(ls->ls_debug_rsb_dentry);
+	debugfs_remove(ls->ls_debug_waiters_dentry);
+	debugfs_remove(ls->ls_debug_locks_dentry);
+	debugfs_remove(ls->ls_debug_all_dentry);
+	debugfs_remove(ls->ls_debug_toss_dentry);
 }
 
 int dlm_create_debug_file(struct dlm_ls *ls)
-- 
1.8.4.5

