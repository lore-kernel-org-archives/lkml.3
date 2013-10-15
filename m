Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3JOSgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:36:32 -0400
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:33152 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758936Ab3JOSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:36:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:69:327:355:379:541:599:960:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2693:2828:2897:2901:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4559:4605:5007:7576:7652:7875:7903:8603:8660:9010:9164:10004:10848:11026:11232:11914:12043:12219:12291:12296:12438:12517:12519:12555:12681:12683:12740:13148:13230:13868:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war87_1b3f88d43164f
X-Filterd-Recvd-Size: 31819
Message-ID: <1381862186.22110.33.camel@joe-AO722>
Subject: Re: [PATCH] ipc/sem.c: fix small codingstyle
From: Joe Perches <joe@perches.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Libin <huawei.libin@huawei.com>, akpm@linux-foundation.org,
        manfred@colorfullife.com, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com, xiexiuqi@huawei.com
Date: Tue, 15 Oct 2013 11:36:26 -0700
In-Reply-To: <1381855484.2354.0.camel@buesod1.americas.hpqcorp.net>
References: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com>
	 <1381855484.2354.0.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 09:44 -0700, Davidlohr Bueso wrote:
> On Tue, 2013-10-15 at 16:19 +0800, Libin wrote:
> > From: Li Bin <huawei.libin@huawei.com>
> > 
> > small codingstyle fix: '*' should be adjacent to the data name.
> 
> There are *tons* of these, go crazy.
> 

Here are the whitespace changes proposed by
$ scripts/checkpatch -f --fix --types=pointer_location,spacing,space_before_tab ipc/*.[ch]

$ git diff -w shows no difference

 ipc/compat.c     | 10 +++---
 ipc/compat_mq.c  |  2 +-
 ipc/ipc_sysctl.c | 14 ++++----
 ipc/mqueue.c     | 16 ++++-----
 ipc/msg.c        | 18 +++++------
 ipc/sem.c        | 98 ++++++++++++++++++++++++++++----------------------------
 ipc/shm.c        | 34 ++++++++++----------
 ipc/util.c       | 24 +++++++-------
 ipc/util.h       | 14 ++++----
 9 files changed, 115 insertions(+), 115 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 892f658..ed0530b 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -197,7 +197,7 @@ static inline int __put_compat_ipc_perm(struct ipc64_perm *p,
 static inline int get_compat_semid64_ds(struct semid64_ds *s64,
 					struct compat_semid64_ds __user *up64)
 {
-	if (!access_ok (VERIFY_READ, up64, sizeof(*up64)))
+	if (!access_ok(VERIFY_READ, up64, sizeof(*up64)))
 		return -EFAULT;
 	return __get_compat_ipc64_perm(&s64->sem_perm, &up64->sem_perm);
 }
@@ -205,7 +205,7 @@ static inline int get_compat_semid64_ds(struct semid64_ds *s64,
 static inline int get_compat_semid_ds(struct semid64_ds *s,
 				      struct compat_semid_ds __user *up)
 {
-	if (!access_ok (VERIFY_READ, up, sizeof(*up)))
+	if (!access_ok(VERIFY_READ, up, sizeof(*up)))
 		return -EFAULT;
 	return __get_compat_ipc_perm(&s->sem_perm, &up->sem_perm);
 }
@@ -215,7 +215,7 @@ static inline int put_compat_semid64_ds(struct semid64_ds *s64,
 {
 	int err;
 
-	if (!access_ok (VERIFY_WRITE, up64, sizeof(*up64)))
+	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
 	err  = __put_compat_ipc64_perm(&s64->sem_perm, &up64->sem_perm);
 	err |= __put_user(s64->sem_otime, &up64->sem_otime);
@@ -229,7 +229,7 @@ static inline int put_compat_semid_ds(struct semid64_ds *s,
 {
 	int err;
 
-	if (!access_ok (VERIFY_WRITE, up, sizeof(*up)))
+	if (!access_ok(VERIFY_WRITE, up, sizeof(*up)))
 		return -EFAULT;
 	err  = __put_compat_ipc_perm(&s->sem_perm, &up->sem_perm);
 	err |= __put_user(s->sem_otime, &up->sem_otime);
@@ -376,7 +376,7 @@ COMPAT_SYSCALL_DEFINE6(ipc, u32, call, int, first, int, second,
 			struct compat_ipc_kludge ipck;
 			if (!uptr)
 				return -EINVAL;
-			if (copy_from_user (&ipck, uptr, sizeof(ipck)))
+			if (copy_from_user(&ipck, uptr, sizeof(ipck)))
 				return -EFAULT;
 			uptr = compat_ptr(ipck.msgp);
 			fifth = ipck.msgtyp;
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index 380ea4f..63d7c6de 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -64,7 +64,7 @@ asmlinkage long compat_sys_mq_open(const char __user *u_name,
 	return sys_mq_open(u_name, oflag, mode, p);
 }
 
-static int compat_prepare_timeout(struct timespec __user * *p,
+static int compat_prepare_timeout(struct timespec __user **p,
 				  const struct compat_timespec __user *u)
 {
 	struct timespec ts;
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 130dfec..a0b716b 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -166,21 +166,21 @@ static struct ctl_table ipc_kern_table[] = {
 	{
 		.procname	= "shmmax",
 		.data		= &init_ipc_ns.shm_ctlmax,
-		.maxlen		= sizeof (init_ipc_ns.shm_ctlmax),
+		.maxlen		= sizeof(init_ipc_ns.shm_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_doulongvec_minmax,
 	},
 	{
 		.procname	= "shmall",
 		.data		= &init_ipc_ns.shm_ctlall,
-		.maxlen		= sizeof (init_ipc_ns.shm_ctlall),
+		.maxlen		= sizeof(init_ipc_ns.shm_ctlall),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_doulongvec_minmax,
 	},
 	{
 		.procname	= "shmmni",
 		.data		= &init_ipc_ns.shm_ctlmni,
-		.maxlen		= sizeof (init_ipc_ns.shm_ctlmni),
+		.maxlen		= sizeof(init_ipc_ns.shm_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
 	},
@@ -196,28 +196,28 @@ static struct ctl_table ipc_kern_table[] = {
 	{
 		.procname	= "msgmax",
 		.data		= &init_ipc_ns.msg_ctlmax,
-		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
+		.maxlen		= sizeof(init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
 	},
 	{
 		.procname	= "msgmni",
 		.data		= &init_ipc_ns.msg_ctlmni,
-		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
+		.maxlen		= sizeof(init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_callback_dointvec,
 	},
 	{
 		.procname	=  "msgmnb",
 		.data		= &init_ipc_ns.msg_ctlmnb,
-		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
+		.maxlen		= sizeof(init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
 	},
 	{
 		.procname	= "sem",
 		.data		= &init_ipc_ns.sem_ctls,
-		.maxlen		= 4*sizeof (int),
+		.maxlen		= 4*sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
 	},
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ae1996d..c43e42f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -6,7 +6,7 @@
  *
  * Spinlocks:               Mohamed Abbas           (abbas.mohamed@intel.com)
  * Lockless receive & send, fd based notify:
- * 			    Manfred Spraul	    (manfred@colorfullife.com)
+ *			    Manfred Spraul	    (manfred@colorfullife.com)
  *
  * Audit:                   George Wilson           (ltcgcw@us.ibm.com)
  *
@@ -73,7 +73,7 @@ struct mqueue_inode_info {
 	struct mq_attr attr;
 
 	struct sigevent notify;
-	struct pid* notify_owner;
+	struct pid *notify_owner;
 	struct user_namespace *notify_user_ns;
 	struct user_struct *user;	/* user who created, for accounting */
 	struct sock *notify_sock;
@@ -92,7 +92,7 @@ static void remove_notification(struct mqueue_inode_info *info);
 
 static struct kmem_cache *mqueue_inode_cachep;
 
-static struct ctl_table_header * mq_sysctl_table;
+static struct ctl_table_header *mq_sysctl_table;
 
 static inline struct mqueue_inode_info *MQUEUE_I(struct inode *inode)
 {
@@ -466,13 +466,13 @@ out_unlock:
 
 static int mqueue_unlink(struct inode *dir, struct dentry *dentry)
 {
-  	struct inode *inode = dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 
 	dir->i_ctime = dir->i_mtime = dir->i_atime = CURRENT_TIME;
 	dir->i_size -= DIRENT_SIZE;
-  	drop_nlink(inode);
-  	dput(dentry);
-  	return 0;
+	drop_nlink(inode);
+	dput(dentry);
+	return 0;
 }
 
 /*
@@ -622,7 +622,7 @@ static struct ext_wait_queue *wq_get_first_waiter(
 
 static inline void set_cookie(struct sk_buff *skb, char code)
 {
-	((char*)skb->data)[NOTIFY_COOKIE_LEN-1] = code;
+	((char *)skb->data)[NOTIFY_COOKIE_LEN-1] = code;
 }
 
 /*
diff --git a/ipc/msg.c b/ipc/msg.c
index 9e4310c..eff31af 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -318,7 +318,7 @@ SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
 static inline unsigned long
 copy_msqid_to_user(void __user *buf, struct msqid64_ds *in, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		return copy_to_user(buf, in, sizeof(*in));
 	case IPC_OLD:
@@ -363,7 +363,7 @@ copy_msqid_to_user(void __user *buf, struct msqid64_ds *in, int version)
 static inline unsigned long
 copy_msqid_from_user(struct msqid64_ds *out, void __user *buf, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		if (copy_from_user(out, buf, sizeof(*out)))
 			return -EFAULT;
@@ -375,9 +375,9 @@ copy_msqid_from_user(struct msqid64_ds *out, void __user *buf, int version)
 		if (copy_from_user(&tbuf_old, buf, sizeof(tbuf_old)))
 			return -EFAULT;
 
-		out->msg_perm.uid      	= tbuf_old.msg_perm.uid;
-		out->msg_perm.gid      	= tbuf_old.msg_perm.gid;
-		out->msg_perm.mode     	= tbuf_old.msg_perm.mode;
+		out->msg_perm.uid	= tbuf_old.msg_perm.uid;
+		out->msg_perm.gid	= tbuf_old.msg_perm.gid;
+		out->msg_perm.mode	= tbuf_old.msg_perm.mode;
 
 		if (tbuf_old.msg_qbytes == 0)
 			out->msg_qbytes	= tbuf_old.msg_lqbytes;
@@ -606,13 +606,13 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 
 static int testmsg(struct msg_msg *msg, long type, int mode)
 {
-	switch(mode)
+	switch (mode)
 	{
 		case SEARCH_ANY:
 		case SEARCH_NUMBER:
 			return 1;
 		case SEARCH_LESSEQUAL:
-			if (msg->m_type <=type)
+			if (msg->m_type <= type)
 				return 1;
 			break;
 		case SEARCH_EQUAL:
@@ -970,7 +970,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 		 * wake_up_process(). There is a race with exit(), see
 		 * ipc/mqueue.c for the details.
 		 */
-		msg = (struct msg_msg*)msr_d.r_msg;
+		msg = (struct msg_msg *)msr_d.r_msg;
 		while (msg == NULL) {
 			cpu_relax();
 			msg = (struct msg_msg *)msr_d.r_msg;
@@ -991,7 +991,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 		/* Lockless receive, part 4:
 		 * Repeat test after acquiring the spinlock.
 		 */
-		msg = (struct msg_msg*)msr_d.r_msg;
+		msg = (struct msg_msg *)msr_d.r_msg;
 		if (msg != ERR_PTR(-EAGAIN))
 			goto out_unlock0;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 8c4f59b..c8d9514 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -188,7 +188,7 @@ void sem_exit_ns(struct ipc_namespace *ns)
 }
 #endif
 
-void __init sem_init (void)
+void __init sem_init(void)
 {
 	sem_init_ns(&init_ipc_ns);
 	ipc_init_proc_interface("sysvipc/sem",
@@ -445,11 +445,11 @@ static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
  *	* call wake_up_process
  *	* set queue.status to the final value.
  * - the previously blocked thread checks queue.status:
- *   	* if it's IN_WAKEUP, then it must wait until the value changes
- *   	* if it's not -EINTR, then the operation was completed by
- *   	  update_queue. semtimedop can return queue.status without
- *   	  performing any operation on the sem array.
- *   	* otherwise it must acquire the spinlock and check what's up.
+ *	* if it's IN_WAKEUP, then it must wait until the value changes
+ *	* if it's not -EINTR, then the operation was completed by
+ *	  update_queue. semtimedop can return queue.status without
+ *	  performing any operation on the sem array.
+ *	* otherwise it must acquire the spinlock and check what's up.
  *
  * The two-stage algorithm is necessary to protect against the following
  * races:
@@ -491,12 +491,12 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	if (ns->used_sems + nsems > ns->sc_semmns)
 		return -ENOSPC;
 
-	size = sizeof (*sma) + nsems * sizeof (struct sem);
+	size = sizeof(*sma) + nsems * sizeof(struct sem);
 	sma = ipc_rcu_alloc(size);
 	if (!sma) {
 		return -ENOMEM;
 	}
-	memset (sma, 0, size);
+	memset(sma, 0, size);
 
 	sma->sem_perm.mode = (semflg & S_IRWXUGO);
 	sma->sem_perm.key = key;
@@ -601,7 +601,7 @@ static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 {
 	int result, sem_op;
 	struct sembuf *sop;
-	struct sem * curr;
+	struct sem *curr;
 
 	for (sop = sops; sop < sops + nsops; sop++) {
 		curr = sma->sem_base + sop->sem_num;
@@ -619,7 +619,7 @@ static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 		if (sop->sem_flg & SEM_UNDO) {
 			int undo = un->semadj[sop->sem_num] - sem_op;
 			/*
-	 		 *	Exceeding the undo range is an error.
+			 *	Exceeding the undo range is an error.
 			 */
 			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
 				goto out_of_range;
@@ -998,21 +998,21 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
  * The counts we return here are a rough approximation, but still
  * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
  */
-static int count_semncnt (struct sem_array * sma, ushort semnum)
+static int count_semncnt(struct sem_array *sma, ushort semnum)
 {
 	int semncnt;
-	struct sem_queue * q;
+	struct sem_queue *q;
 
 	semncnt = 0;
 	list_for_each_entry(q, &sma->sem_base[semnum].pending_alter, list) {
-		struct sembuf * sops = q->sops;
+		struct sembuf *sops = q->sops;
 		BUG_ON(sops->sem_num != semnum);
 		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
 			semncnt++;
 	}
 
 	list_for_each_entry(q, &sma->pending_alter, list) {
-		struct sembuf * sops = q->sops;
+		struct sembuf *sops = q->sops;
 		int nsops = q->nsops;
 		int i;
 		for (i = 0; i < nsops; i++)
@@ -1024,21 +1024,21 @@ static int count_semncnt (struct sem_array * sma, ushort semnum)
 	return semncnt;
 }
 
-static int count_semzcnt (struct sem_array * sma, ushort semnum)
+static int count_semzcnt(struct sem_array *sma, ushort semnum)
 {
 	int semzcnt;
-	struct sem_queue * q;
+	struct sem_queue *q;
 
 	semzcnt = 0;
 	list_for_each_entry(q, &sma->sem_base[semnum].pending_const, list) {
-		struct sembuf * sops = q->sops;
+		struct sembuf *sops = q->sops;
 		BUG_ON(sops->sem_num != semnum);
 		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
 			semzcnt++;
 	}
 
 	list_for_each_entry(q, &sma->pending_const, list) {
-		struct sembuf * sops = q->sops;
+		struct sembuf *sops = q->sops;
 		int nsops = q->nsops;
 		int i;
 		for (i = 0; i < nsops; i++)
@@ -1108,7 +1108,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		return copy_to_user(buf, in, sizeof(*in));
 	case IPC_OLD:
@@ -1151,7 +1151,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 	int err;
 	struct sem_array *sma;
 
-	switch(cmd) {
+	switch (cmd) {
 	case IPC_INFO:
 	case SEM_INFO:
 	{
@@ -1162,7 +1162,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		if (err)
 			return err;
 		
-		memset(&seminfo,0,sizeof(seminfo));
+		memset(&seminfo, 0, sizeof(seminfo));
 		seminfo.semmni = ns->sc_semmni;
 		seminfo.semmns = ns->sc_semmns;
 		seminfo.semmsl = ns->sc_semmsl;
@@ -1183,7 +1183,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		up_read(&sem_ids(ns).rwsem);
 		if (copy_to_user(p, &seminfo, sizeof(struct seminfo))) 
 			return -EFAULT;
-		return (max_id < 0) ? 0: max_id;
+		return (max_id < 0) ? 0 : max_id;
 	}
 	case IPC_STAT:
 	case SEM_STAT:
@@ -1239,7 +1239,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 {
 	struct sem_undo *un;
 	struct sem_array *sma;
-	struct sem* curr;
+	struct sem *curr;
 	int err;
 	struct list_head tasks;
 	int val;
@@ -1303,10 +1303,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int cmd, void __user *p)
 {
 	struct sem_array *sma;
-	struct sem* curr;
+	struct sem *curr;
 	int err, nsems;
 	ushort fast_sem_io[SEMMSL_FAST];
-	ushort* sem_io = fast_sem_io;
+	ushort *sem_io = fast_sem_io;
 	struct list_head tasks;
 
 	INIT_LIST_HEAD(&tasks);
@@ -1336,7 +1336,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		int i;
 
 		sem_lock(sma, NULL, -1);
-		if(nsems > SEMMSL_FAST) {
+		if (nsems > SEMMSL_FAST) {
 			if (!ipc_rcu_getref(sma)) {
 				sem_unlock(sma, -1);
 				rcu_read_unlock();
@@ -1346,7 +1346,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			sem_unlock(sma, -1);
 			rcu_read_unlock();
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
-			if(sem_io == NULL) {
+			if (sem_io == NULL) {
 				ipc_rcu_putref(sma, ipc_rcu_free);
 				return -ENOMEM;
 			}
@@ -1365,7 +1365,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
 		err = 0;
-		if(copy_to_user(array, sem_io, nsems*sizeof(ushort)))
+		if (copy_to_user(array, sem_io, nsems*sizeof(ushort)))
 			err = -EFAULT;
 		goto out_free;
 	}
@@ -1380,15 +1380,15 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		rcu_read_unlock();
 
-		if(nsems > SEMMSL_FAST) {
+		if (nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
-			if(sem_io == NULL) {
+			if (sem_io == NULL) {
 				ipc_rcu_putref(sma, ipc_rcu_free);
 				return -ENOMEM;
 			}
 		}
 
-		if (copy_from_user (sem_io, p, nsems*sizeof(ushort))) {
+		if (copy_from_user(sem_io, p, nsems*sizeof(ushort))) {
 			ipc_rcu_putref(sma, ipc_rcu_free);
 			err = -EFAULT;
 			goto out_free;
@@ -1441,10 +1441,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		err = curr->sempid;
 		goto out_unlock;
 	case GETNCNT:
-		err = count_semncnt(sma,semnum);
+		err = count_semncnt(sma, semnum);
 		goto out_unlock;
 	case GETZCNT:
-		err = count_semzcnt(sma,semnum);
+		err = count_semzcnt(sma, semnum);
 		goto out_unlock;
 	}
 
@@ -1454,7 +1454,7 @@ out_rcu_wakeup:
 	rcu_read_unlock();
 	wake_up_sem_queue_do(&tasks);
 out_free:
-	if(sem_io != fast_sem_io)
+	if (sem_io != fast_sem_io)
 		ipc_free(sem_io, sizeof(ushort)*nsems);
 	return err;
 }
@@ -1462,7 +1462,7 @@ out_free:
 static inline unsigned long
 copy_semid_from_user(struct semid64_ds *out, void __user *buf, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		if (copy_from_user(out, buf, sizeof(*out)))
 			return -EFAULT;
@@ -1471,7 +1471,7 @@ copy_semid_from_user(struct semid64_ds *out, void __user *buf, int version)
 	    {
 		struct semid_ds tbuf_old;
 
-		if(copy_from_user(&tbuf_old, buf, sizeof(tbuf_old)))
+		if (copy_from_user(&tbuf_old, buf, sizeof(tbuf_old)))
 			return -EFAULT;
 
 		out->sem_perm.uid	= tbuf_old.sem_perm.uid;
@@ -1498,7 +1498,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	struct semid64_ds semid64;
 	struct kern_ipc_perm *ipcp;
 
-	if(cmd == IPC_SET) {
+	if (cmd == IPC_SET) {
 		if (copy_semid_from_user(&semid64, p, version))
 			return -EFAULT;
 	}
@@ -1558,7 +1558,7 @@ SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, unsigned long, arg)
 	version = ipc_parse_version(&cmd);
 	ns = current->nsproxy->ipc_ns;
 
-	switch(cmd) {
+	switch (cmd) {
 	case IPC_INFO:
 	case SEM_INFO:
 	case IPC_STAT:
@@ -1626,7 +1626,7 @@ static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
 {
 	struct sem_undo *un;
 
-  	assert_spin_locked(&ulp->lock);
+	assert_spin_locked(&ulp->lock);
 
 	un = __lookup_undo(ulp, semid);
 	if (un) {
@@ -1662,7 +1662,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
 	spin_unlock(&ulp->lock);
-	if (likely(un!=NULL))
+	if (likely(un != NULL))
 		goto out;
 
 	/* no undo structure around - allocate one. */
@@ -1757,7 +1757,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	int error = -EINVAL;
 	struct sem_array *sma;
 	struct sembuf fast_sops[SEMOPM_FAST];
-	struct sembuf* sops = fast_sops, *sop;
+	struct sembuf *sops = fast_sops, *sop;
 	struct sem_undo *un;
 	int undos = 0, alter = 0, max, locknum;
 	struct sem_queue queue;
@@ -1771,13 +1771,13 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		return -EINVAL;
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
-	if(nsops > SEMOPM_FAST) {
-		sops = kmalloc(sizeof(*sops)*nsops,GFP_KERNEL);
-		if(sops==NULL)
+	if (nsops > SEMOPM_FAST) {
+		sops = kmalloc(sizeof(*sops)*nsops, GFP_KERNEL);
+		if (sops == NULL)
 			return -ENOMEM;
 	}
-	if (copy_from_user (sops, tsops, nsops * sizeof(*tsops))) {
-		error=-EFAULT;
+	if (copy_from_user(sops, tsops, nsops * sizeof(*tsops))) {
+		error =  -EFAULT;
 		goto out_free;
 	}
 	if (timeout) {
@@ -1974,7 +1974,7 @@ out_rcu_wakeup:
 	rcu_read_unlock();
 	wake_up_sem_queue_do(&tasks);
 out_free:
-	if(sops != fast_sops)
+	if (sops != fast_sops)
 		kfree(sops);
 	return error;
 }
@@ -2077,7 +2077,7 @@ void exit_sem(struct task_struct *tsk)
 
 		/* perform adjustments registered in un */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			struct sem * semaphore = &sma->sem_base[i];
+			struct sem *semaphore = &sma->sem_base[i];
 			if (un->semadj[i]) {
 				semaphore->semval += un->semadj[i];
 				/*
@@ -2091,7 +2091,7 @@ void exit_sem(struct task_struct *tsk)
 				 * Linux caps the semaphore value, both at 0
 				 * and at SEMVMX.
 				 *
-				 * 	Manfred <manfred@colorfullife.com>
+				 *	Manfred <manfred@colorfullife.com>
 				 */
 				if (semaphore->semval < 0)
 					semaphore->semval = 0;
diff --git a/ipc/shm.c b/ipc/shm.c
index d697396..7c0e0f5 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -67,7 +67,7 @@ static const struct vm_operations_struct shm_vm_ops;
 static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
 static void shm_close(struct vm_area_struct *vma);
-static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp);
+static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
@@ -91,7 +91,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct shmid_kernel *shp;
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
-	if (shp->shm_nattch){
+	if (shp->shm_nattch) {
 		shp->shm_perm.mode |= SHM_DEST;
 		/* Do not find it any more */
 		shp->shm_perm.key = IPC_PRIVATE;
@@ -116,7 +116,7 @@ static int __init ipc_ns_init(void)
 
 pure_initcall(ipc_ns_init);
 
-void __init shm_init (void)
+void __init shm_init(void)
 {
 	ipc_init_proc_interface("sysvipc/shm",
 #if BITS_PER_LONG <= 32
@@ -216,7 +216,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 	else if (shp->mlock_user)
 		user_shm_unlock(file_inode(shp->shm_file)->i_size,
 						shp->mlock_user);
-	fput (shp->shm_file);
+	fput(shp->shm_file);
 	ipc_rcu_putref(shp, shm_rcu_free);
 }
 
@@ -245,7 +245,7 @@ static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
  */
 static void shm_close(struct vm_area_struct *vma)
 {
-	struct file * file = vma->vm_file;
+	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
 	struct ipc_namespace *ns = sfd->ns;
@@ -376,7 +376,7 @@ static struct mempolicy *shm_get_policy(struct vm_area_struct *vma,
 }
 #endif
 
-static int shm_mmap(struct file * file, struct vm_area_struct * vma)
+static int shm_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
 	int ret;
@@ -483,7 +483,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	int error;
 	struct shmid_kernel *shp;
 	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	struct file * file;
+	struct file *file;
 	char name[13];
 	int id;
 	vm_flags_t acctflag = 0;
@@ -509,7 +509,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 		return error;
 	}
 
-	sprintf (name, "SYSV%08x", key);
+	sprintf(name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
 		struct hstate *hs;
 		size_t hugesize;
@@ -530,7 +530,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	} else {
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
-	 	 * if it's asked for.
+		 * if it's asked for.
 		 */
 		if  ((shmflg & SHM_NORESERVE) &&
 				sysctl_overcommit_memory != OVERCOMMIT_NEVER)
@@ -625,7 +625,7 @@ SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
 
 static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_ds *in, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		return copy_to_user(buf, in, sizeof(*in));
 	case IPC_OLD:
@@ -652,7 +652,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 static inline unsigned long
 copy_shmid_from_user(struct shmid64_ds *out, void __user *buf, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		if (copy_from_user(out, buf, sizeof(*out)))
 			return -EFAULT;
@@ -677,14 +677,14 @@ copy_shmid_from_user(struct shmid64_ds *out, void __user *buf, int version)
 
 static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminfo64 *in, int version)
 {
-	switch(version) {
+	switch (version) {
 	case IPC_64:
 		return copy_to_user(buf, in, sizeof(*in));
 	case IPC_OLD:
 	    {
 		struct shminfo out;
 
-		if(in->shmmax > INT_MAX)
+		if (in->shmmax > INT_MAX)
 			out.shmmax = INT_MAX;
 		else
 			out.shmmax = (int)in->shmmax;
@@ -843,14 +843,14 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		shminfo.shmall = ns->shm_ctlall;
 
 		shminfo.shmmin = SHMMIN;
-		if(copy_shminfo_to_user (buf, &shminfo, version))
+		if (copy_shminfo_to_user(buf, &shminfo, version))
 			return -EFAULT;
 
 		down_read(&shm_ids(ns).rwsem);
 		err = ipc_get_maxid(&shm_ids(ns));
 		up_read(&shm_ids(ns).rwsem);
 
-		if(err<0)
+		if (err < 0)
 			err = 0;
 		goto out;
 	}
@@ -861,7 +861,7 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		memset(&shm_info, 0, sizeof(shm_info));
 		down_read(&shm_ids(ns).rwsem);
 		shm_info.used_ids = shm_ids(ns).in_use;
-		shm_get_stat (ns, &shm_info.shm_rss, &shm_info.shm_swp);
+		shm_get_stat(ns, &shm_info.shm_rss, &shm_info.shm_swp);
 		shm_info.shm_tot = ns->shm_tot;
 		shm_info.swap_attempts = 0;
 		shm_info.swap_successes = 0;
@@ -1034,7 +1034,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	struct shmid_kernel *shp;
 	unsigned long addr;
 	unsigned long size;
-	struct file * file;
+	struct file *file;
 	int    err;
 	unsigned long flags;
 	unsigned long prot;
diff --git a/ipc/util.c b/ipc/util.c
index 71c76e9..4a45af8 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -135,7 +135,7 @@ void ipc_init_ids(struct ipc_ids *ids)
 		if (seq_limit > USHRT_MAX)
 			ids->seq_max = USHRT_MAX;
 		 else
-		 	ids->seq_max = seq_limit;
+			ids->seq_max = seq_limit;
 	}
 
 	idr_init(&ids->ipcs_idr);
@@ -212,7 +212,7 @@ static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 }
 
 /**
- *	ipc_get_maxid 	-	get the last assigned id
+ *	ipc_get_maxid	-	get the last assigned id
  *	@ids: IPC identifier set
  *
  *	Called with ipc_ids.rwsem held.
@@ -243,7 +243,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
 }
 
 /**
- *	ipc_addid 	-	add an IPC identifier
+ *	ipc_addid	-	add an IPC identifier
  *	@ids: IPC identifier set
  *	@new: new IPC permission set
  *	@size: limit for the number of used ids
@@ -255,7 +255,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *
  *	Called with writer ipc_ids.rwsem held.
  */
-int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
+int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size)
 {
 	kuid_t euid;
 	kgid_t egid;
@@ -448,7 +448,7 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 void *ipc_alloc(int size)
 {
 	void *out;
-	if(size > PAGE_SIZE)
+	if (size > PAGE_SIZE)
 		out = vmalloc(size);
 	else
 		out = kmalloc(size, GFP_KERNEL);
@@ -464,9 +464,9 @@ void *ipc_alloc(int size)
  *	used in the allocation call.
  */
 
-void ipc_free(void* ptr, int size)
+void ipc_free(void *ptr, int size)
 {
-	if(size > PAGE_SIZE)
+	if (size > PAGE_SIZE)
 		vfree(ptr);
 	else
 		kfree(ptr);
@@ -527,7 +527,7 @@ void ipc_rcu_free(struct rcu_head *head)
  *	Check user, group, other permissions for access
  *	to ipc resources. return 0 if allowed
  *
- * 	@flag will most probably be 0 or S_...UGO from <linux/stat.h>
+ *	@flag will most probably be 0 or S_...UGO from <linux/stat.h>
  */
  
 int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
@@ -566,7 +566,7 @@ int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
  */
  
 
-void kernel_to_ipc64_perm (struct kern_ipc_perm *in, struct ipc64_perm *out)
+void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out)
 {
 	out->key	= in->key;
 	out->uid	= from_kuid_munged(current_user_ns(), in->uid);
@@ -586,7 +586,7 @@ void kernel_to_ipc64_perm (struct kern_ipc_perm *in, struct ipc64_perm *out)
  *	object and store it into the @out pointer.
  */
  
-void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
+void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out)
 {
 	out->key	= in->key;
 	SET_UID(out->uid, in->uid);
@@ -772,7 +772,7 @@ err:
  *	just the command code.
  */
  
-int ipc_parse_version (int *cmd)
+int ipc_parse_version(int *cmd)
 {
 	if (*cmd & IPC_64) {
 		*cmd ^= IPC_64;
@@ -809,7 +809,7 @@ static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 	if (total >= ids->in_use)
 		return NULL;
 
-	for ( ; pos < IPCMNI; pos++) {
+	for (; pos < IPCMNI; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
diff --git a/ipc/util.h b/ipc/util.h
index f2f5036..ad01f29 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -15,9 +15,9 @@
 
 #define SEQ_MULTIPLIER	(IPCMNI)
 
-void sem_init (void);
-void msg_init (void);
-void shm_init (void);
+void sem_init(void);
+void msg_init(void);
+void shm_init(void);
 
 struct ipc_namespace;
 
@@ -116,8 +116,8 @@ int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flg);
 /* for rare, potentially huge allocations.
  * both function can sleep
  */
-void* ipc_alloc(int size);
-void ipc_free(void* ptr, int size);
+void *ipc_alloc(int size);
+void ipc_free(void *ptr, int size);
 
 /*
  * For allocation that need to be freed by RCU.
@@ -125,7 +125,7 @@ void ipc_free(void* ptr, int size);
  * getref increases the refcount, the putref call that reduces the recount
  * to 0 schedules the rcu destruction. Caller must guarantee locking.
  */
-void* ipc_rcu_alloc(int size);
+void *ipc_rcu_alloc(int size);
 int ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head));
 void ipc_rcu_free(struct rcu_head *head);
@@ -144,7 +144,7 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else
-int ipc_parse_version (int *cmd);
+int ipc_parse_version(int *cmd);
 #endif
 
 extern void free_msg(struct msg_msg *msg);


