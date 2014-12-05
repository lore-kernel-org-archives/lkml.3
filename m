Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaLEG14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:27:56 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57256 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaLEG1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:27:53 -0500
From: "Joshua I. James" <joshua@cybercrimetech.com>
X-Google-Original-From: "Joshua I. James" <Joshua@cybercrimetech.com>
To: linux-kernel@vger.kernel.org
Cc: "Joshua I. James" <joshua@cybercrimetech.com>
Subject: [PATCH] staging: kernel: fixed style errors in pid.c
Date: Fri,  5 Dec 2014 15:27:38 +0900
Message-Id: <1417760858-26831-1-git-send-email-Joshua@cybercrimetech.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joshua I. James" <joshua@cybercrimetech.com>

Fixed style errors identified by checkpatch.

ERROR: space prohibited after that open square bracket '['
WARNING: Missing a blank line after declarations
ERROR: space required before the open parenthesis '('
WARNING: line over 80 characters
WARNING: quoted string split across lines

Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
---
 kernel/pid.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..8e92d38 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -72,7 +72,7 @@ struct pid_namespace init_pid_ns = {
 		.refcount       = ATOMIC_INIT(2),
 	},
 	.pidmap = {
-		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
+		[0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
 	.nr_hashed = PIDNS_HASH_ADDING,
@@ -142,6 +142,7 @@ static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
 {
 	int prev;
 	int last_write = base;
+
 	do {
 		prev = last_write;
 		last_write = cmpxchg(&pid_ns->last_pid, prev, pid);
@@ -250,6 +251,7 @@ EXPORT_SYMBOL_GPL(put_pid);
 static void delayed_put_pid(struct rcu_head *rhp)
 {
 	struct pid *pid = container_of(rhp, struct pid, rcu);
+
 	put_pid(pid);
 }
 
@@ -263,8 +265,9 @@ void free_pid(struct pid *pid)
 	for (i = 0; i <= pid->level; i++) {
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
+
 		hlist_del_rcu(&upid->pid_chain);
-		switch(--ns->nr_hashed) {
+		switch (--ns->nr_hashed) {
 		case 2:
 		case 1:
 			/* When all that is left in the pid namespace
@@ -383,6 +386,7 @@ EXPORT_SYMBOL_GPL(find_vpid);
 void attach_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid_link *link = &task->pids[type];
+
 	hlist_add_head_rcu(&link->node, &link->pid->tasks[type]);
 }
 
@@ -429,12 +433,15 @@ void transfer_pid(struct task_struct *old, struct task_struct *new,
 struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result = NULL;
+
 	if (pid) {
 		struct hlist_node *first;
+
 		first = rcu_dereference_check(hlist_first_rcu(&pid->tasks[type]),
 					      lockdep_tasklist_lock_is_held());
 		if (first)
-			result = hlist_entry(first, struct task_struct, pids[(type)].node);
+			result = hlist_entry(first, struct task_struct,
+						pids[(type)].node);
 	}
 	return result;
 }
@@ -446,8 +453,7 @@ EXPORT_SYMBOL(pid_task);
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
 	rcu_lockdep_assert(rcu_read_lock_held(),
-			   "find_task_by_pid_ns() needs rcu_read_lock()"
-			   " protection");
+		"find_task_by_pid_ns() needs rcu_read_lock() protection");
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
@@ -459,6 +465,7 @@ struct task_struct *find_task_by_vpid(pid_t vnr)
 struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid;
+
 	rcu_read_lock();
 	if (type != PIDTYPE_PID)
 		task = task->group_leader;
@@ -471,8 +478,10 @@ EXPORT_SYMBOL_GPL(get_task_pid);
 struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result;
+
 	rcu_read_lock();
 	result = pid_task(pid, type);
+
 	if (result)
 		get_task_struct(result);
 	rcu_read_unlock();
-- 
1.9.1

