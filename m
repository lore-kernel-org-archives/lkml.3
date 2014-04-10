Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783AbaDJUkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:40:52 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36611 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbaDJUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:40:50 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, aquini@redhat.com
Subject: [PATCH 2/2] ipc:kernel:clear whitespace
Date: Thu, 10 Apr 2014 21:40:44 +0100
Message-Id: <1397162444-9327-2-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397162444-9327-1-git-send-email-paulmcquad@gmail.com>
References: <1397162444-9327-1-git-send-email-paulmcquad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/msg.c     | 31 +++++++++++++++----------------
 ipc/sem.c     | 10 +++++-----
 ipc/shm.c     |  2 +-
 ipc/util.c    |  4 ++--
 ipc/util.h    |  8 ++++----
 kernel/acct.c |  4 ++--
 6 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index a385372..45c6360 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -612,23 +612,22 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 
 static int testmsg(struct msg_msg *msg, long type, int mode)
 {
-	switch (mode)
-	{
-		case SEARCH_ANY:
-		case SEARCH_NUMBER:
+	switch (mode) {
+	case SEARCH_ANY:
+	case SEARCH_NUMBER:
+		return 1;
+	case SEARCH_LESSEQUAL:
+		if (msg->m_type <= type)
 			return 1;
-		case SEARCH_LESSEQUAL:
-			if (msg->m_type <= type)
-				return 1;
-			break;
-		case SEARCH_EQUAL:
-			if (msg->m_type == type)
-				return 1;
-			break;
-		case SEARCH_NOTEQUAL:
-			if (msg->m_type != type)
-				return 1;
-			break;
+		break;
+	case SEARCH_EQUAL:
+		if (msg->m_type == type)
+			return 1;
+		break;
+	case SEARCH_NOTEQUAL:
+		if (msg->m_type != type)
+			return 1;
+		break;
 	}
 	return 0;
 }
diff --git a/ipc/sem.c b/ipc/sem.c
index 3bbfa6c..64a8bba 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -160,7 +160,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
  *	sem_array.pending{_alter,_cont},
  *	sem_array.sem_undo: global sem_lock() for read/write
  *	sem_undo.proc_next: only "current" is allowed to read/write that field.
- *	
+ *
  *	sem_array.sem_base[i].pending_{const,alter}:
  *		global or semaphore sem_lock() for read/write
  */
@@ -1161,7 +1161,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		err = security_sem_semctl(NULL, cmd);
 		if (err)
 			return err;
-		
+
 		memset(&seminfo, 0, sizeof(seminfo));
 		seminfo.semmni = ns->sc_semmni;
 		seminfo.semmns = ns->sc_semmns;
@@ -1181,7 +1181,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		}
 		max_id = ipc_get_maxid(&sem_ids(ns));
 		up_read(&sem_ids(ns).rwsem);
-		if (copy_to_user(p, &seminfo, sizeof(struct seminfo))) 
+		if (copy_to_user(p, &seminfo, sizeof(struct seminfo)))
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
@@ -1883,7 +1883,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
 	 */
-		
+
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
@@ -2016,7 +2016,7 @@ int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
 			return error;
 		atomic_inc(&undo_list->refcnt);
 		tsk->sysvsem.undo_list = undo_list;
-	} else 
+	} else
 		tsk->sysvsem.undo_list = NULL;
 
 	return 0;
diff --git a/ipc/shm.c b/ipc/shm.c
index 89ab12c..33d7e95 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -694,7 +694,7 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
 		out.shmmin	= in->shmmin;
 		out.shmmni	= in->shmmni;
 		out.shmseg	= in->shmseg;
-		out.shmall	= in->shmall; 
+		out.shmall	= in->shmall;
 
 		return copy_to_user(buf, &out, sizeof(out));
 	    }
diff --git a/ipc/util.c b/ipc/util.c
index 2eb0d1e..00bd4f5 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -183,7 +183,7 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
  * ipc_findkey	- find a key in an ipc identifier set
  * @ids: ipc identifier set
  * @key: key to find
- *	
+ *
  * Returns the locked pointer to the ipc structure if found or NULL
  * otherwise. If key is found ipc points to the owning ipc structure
  *
@@ -538,7 +538,7 @@ int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
-	if ((requested_mode & ~granted_mode & 0007) && 
+	if ((requested_mode & ~granted_mode & 0007) &&
 	    !ns_capable(ns->user_ns, CAP_IPC_OWNER))
 		return -1;
 
diff --git a/ipc/util.h b/ipc/util.h
index 9c47d6f..e426d42 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -78,9 +78,9 @@ struct ipc_params {
  *      . routine to call for an extra check if needed
  */
 struct ipc_ops {
-	int (*getnew) (struct ipc_namespace *, struct ipc_params *);
-	int (*associate) (struct kern_ipc_perm *, int);
-	int (*more_checks) (struct kern_ipc_perm *, struct ipc_params *);
+	int (*getnew)(struct ipc_namespace *, struct ipc_params *);
+	int (*associate)(struct kern_ipc_perm *, int);
+	int (*more_checks)(struct kern_ipc_perm *, struct ipc_params *);
 };
 
 struct seq_file;
@@ -142,7 +142,7 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc64_perm *perm, int extra_perm);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
-  /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
+/* On IA-64, we always use the "64-bit version" of the IPC structures.  */
 # define ipc_parse_version(cmd)	IPC_64
 #else
 int ipc_parse_version(int *cmd);
diff --git a/kernel/acct.c b/kernel/acct.c
index df28519..808a86f 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -134,7 +134,7 @@ static int check_free_space(struct bsd_acct_struct *acct, struct file *file)
 	spin_lock(&acct_lock);
 	if (file != acct->file) {
 		if (act)
-			res = act>0;
+			res = act > 0;
 		goto out;
 	}
 
@@ -262,7 +262,7 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 	if (name) {
 		struct filename *tmp = getname(name);
 		if (IS_ERR(tmp))
-			return (PTR_ERR(tmp));
+			return PTR_ERR(tmp);
 		error = acct_on(tmp);
 		putname(tmp);
 	} else {
-- 
1.8.3.2

