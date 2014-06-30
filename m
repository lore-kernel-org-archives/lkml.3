Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbaF3TEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:04:39 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:32068 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333AbaF3TEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:04:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgJAHyzsVNbtAo1/2dsb2JhbABagw2sQQUBAQEBAQEFAW4BmUaBEhd1hGAjgRo3iEYByDYXhWSJIx2ELQWaXos/iD6DRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [RFC 1/1] proc: constify seq_operations
Date: Mon, 30 Jun 2014 21:03:17 +0200
Message-Id: <1404154997-15490-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_uid_seq_operations, proc_gid_seq_operations and proc_projid_seq_operations
are only called in proc_id_map_open with seq_open as
const struct seq_operations so we can constify the 3 structures and update
proc_id_map_open prototype.

(
If it's correct, do I have to send separate patches or different subject ?

Thanks,
Fabian

)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/proc/base.c                 | 2 +-
 include/linux/user_namespace.h | 6 +++---
 kernel/user_namespace.c        | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0..79df9ff 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2449,7 +2449,7 @@ static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
 
 #ifdef CONFIG_USER_NS
 static int proc_id_map_open(struct inode *inode, struct file *file,
-	struct seq_operations *seq_ops)
+	const struct seq_operations *seq_ops)
 {
 	struct user_namespace *ns = NULL;
 	struct task_struct *task;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 4836ba3..e953726 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -57,9 +57,9 @@ static inline void put_user_ns(struct user_namespace *ns)
 }
 
 struct seq_operations;
-extern struct seq_operations proc_uid_seq_operations;
-extern struct seq_operations proc_gid_seq_operations;
-extern struct seq_operations proc_projid_seq_operations;
+extern const struct seq_operations proc_uid_seq_operations;
+extern const struct seq_operations proc_gid_seq_operations;
+extern const struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index fcc0256..aa312b0 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -526,21 +526,21 @@ static void m_stop(struct seq_file *seq, void *v)
 	return;
 }
 
-struct seq_operations proc_uid_seq_operations = {
+const struct seq_operations proc_uid_seq_operations = {
 	.start = uid_m_start,
 	.stop = m_stop,
 	.next = m_next,
 	.show = uid_m_show,
 };
 
-struct seq_operations proc_gid_seq_operations = {
+const struct seq_operations proc_gid_seq_operations = {
 	.start = gid_m_start,
 	.stop = m_stop,
 	.next = m_next,
 	.show = gid_m_show,
 };
 
-struct seq_operations proc_projid_seq_operations = {
+const struct seq_operations proc_projid_seq_operations = {
 	.start = projid_m_start,
 	.stop = m_stop,
 	.next = m_next,
-- 
1.8.4.5

