Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbbA1EcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:32:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:2907 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965267AbbA1EbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:31:25 -0500
Message-Id: <20150128043122.237438919@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 27 Jan 2015 23:30:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 3/3] ftrace: Rename variable from old_hash_ops to old_ops_hash
References: <20150128043036.429390502@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftrace-Rename-variable-from-old_hash_ops-to-old_ops_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The variable name "old_hash_ops" is confusing because it is a hash
and not an ops. It is of type "struct ftrace_ops_hash" and should
be called old_ops_hash.

Link: http://lkml.kernel.org/r/54B79D98.6070800@hitachi.com

Suggested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 224e768bdc73..769b28918b5d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3639,7 +3639,7 @@ int
 register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			      void *data)
 {
-	struct ftrace_ops_hash old_hash_ops;
+	struct ftrace_ops_hash old_ops_hash;
 	struct ftrace_func_probe *entry;
 	struct ftrace_hash **orig_hash = &trace_probe_ops.func_hash->filter_hash;
 	struct ftrace_hash *old_hash = *orig_hash;
@@ -3661,9 +3661,9 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	mutex_lock(&trace_probe_ops.func_hash->regex_lock);
 
-	old_hash_ops.filter_hash = old_hash;
+	old_ops_hash.filter_hash = old_hash;
 	/* Probes only have filters */
-	old_hash_ops.notrace_hash = NULL;
+	old_ops_hash.notrace_hash = NULL;
 
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, old_hash);
 	if (!hash) {
@@ -3725,7 +3725,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
 
-	__enable_ftrace_function_probe(&old_hash_ops);
+	__enable_ftrace_function_probe(&old_ops_hash);
 
 	if (!ret)
 		free_ftrace_hash_rcu(old_hash);
@@ -4048,7 +4048,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		unsigned long ip, int remove, int reset, int enable)
 {
 	struct ftrace_hash **orig_hash;
-	struct ftrace_ops_hash old_hash_ops;
+	struct ftrace_ops_hash old_ops_hash;
 	struct ftrace_hash *old_hash;
 	struct ftrace_hash *hash;
 	int ret;
@@ -4085,11 +4085,11 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_lock(&ftrace_lock);
 	old_hash = *orig_hash;
-	old_hash_ops.filter_hash = ops->func_hash->filter_hash;
-	old_hash_ops.notrace_hash = ops->func_hash->notrace_hash;
+	old_ops_hash.filter_hash = ops->func_hash->filter_hash;
+	old_ops_hash.notrace_hash = ops->func_hash->notrace_hash;
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
 	if (!ret) {
-		ftrace_ops_update_code(ops, &old_hash_ops);
+		ftrace_ops_update_code(ops, &old_ops_hash);
 		free_ftrace_hash_rcu(old_hash);
 	}
 	mutex_unlock(&ftrace_lock);
@@ -4301,7 +4301,7 @@ static void __init set_ftrace_early_filters(void)
 int ftrace_regex_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct ftrace_ops_hash old_hash_ops;
+	struct ftrace_ops_hash old_ops_hash;
 	struct ftrace_iterator *iter;
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *old_hash;
@@ -4335,12 +4335,12 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 		mutex_lock(&ftrace_lock);
 		old_hash = *orig_hash;
-		old_hash_ops.filter_hash = iter->ops->func_hash->filter_hash;
-		old_hash_ops.notrace_hash = iter->ops->func_hash->notrace_hash;
+		old_ops_hash.filter_hash = iter->ops->func_hash->filter_hash;
+		old_ops_hash.notrace_hash = iter->ops->func_hash->notrace_hash;
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
 		if (!ret) {
-			ftrace_ops_update_code(iter->ops, &old_hash_ops);
+			ftrace_ops_update_code(iter->ops, &old_ops_hash);
 			free_ftrace_hash_rcu(old_hash);
 		}
 		mutex_unlock(&ftrace_lock);
-- 
2.1.4


