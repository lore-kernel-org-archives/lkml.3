Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbaAJSuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:50:07 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:45931 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaAJSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:42 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] ipc: remove braces for single statements
Date: Fri, 10 Jan 2014 10:48:22 -0800
Message-Id: <1389379707-20298-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deal with checkpatch messages:
     WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/compat.c | 18 +++++++++---------
 ipc/mqueue.c |  6 +++---
 ipc/sem.c    |  8 +++-----
 ipc/util.c   |  3 +--
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index ed0530b..f71e962 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -288,11 +288,11 @@ static long do_compat_semctl(int first, int second, int third, u32 pad)
 		break;
 
 	case IPC_SET:
-		if (version == IPC_64) {
+		if (version == IPC_64)
 			err = get_compat_semid64_ds(&s64, compat_ptr(pad));
-		} else {
+		else
 			err = get_compat_semid_ds(&s64, compat_ptr(pad));
-		}
+
 		up64 = compat_alloc_user_space(sizeof(s64));
 		if (copy_to_user(up64, &s64, sizeof(s64)))
 			err = -EFAULT;
@@ -515,11 +515,11 @@ long compat_sys_msgctl(int first, int second, void __user *uptr)
 		break;
 
 	case IPC_SET:
-		if (version == IPC_64) {
+		if (version == IPC_64)
 			err = get_compat_msqid64(&m64, uptr);
-		} else {
+		else
 			err = get_compat_msqid(&m64, uptr);
-		}
+
 		if (err)
 			break;
 		p = compat_alloc_user_space(sizeof(m64));
@@ -702,11 +702,11 @@ long compat_sys_shmctl(int first, int second, void __user *uptr)
 
 
 	case IPC_SET:
-		if (version == IPC_64) {
+		if (version == IPC_64)
 			err = get_compat_shmid64_ds(&s64, uptr);
-		} else {
+		else
 			err = get_compat_shmid_ds(&s64, uptr);
-		}
+
 		if (err)
 			break;
 		p = compat_alloc_user_space(sizeof(s64));
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index bb36aae..ccf1f9f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1303,11 +1303,11 @@ retry:
 out_fput:
 	fdput(f);
 out:
-	if (sock) {
+	if (sock)
 		netlink_detachskb(sock, nc);
-	} else if (nc) {
+	else if (nc)
 		dev_kfree_skb(nc);
-	}
+
 	return ret;
 }
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 1b1acdb..bee5554 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -492,9 +492,9 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 
 	size = sizeof(*sma) + nsems * sizeof(struct sem);
 	sma = ipc_rcu_alloc(size);
-	if (!sma) {
+	if (!sma)
 		return -ENOMEM;
-	}
+
 	memset(sma, 0, size);
 
 	sma->sem_perm.mode = (semflg & S_IRWXUGO);
@@ -1967,10 +1967,8 @@ sleep_again:
 	 * If queue.status != -EINTR we are woken up by another process.
 	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
-
-	if (error != -EINTR) {
+	if (error != -EINTR)
 		goto out_unlock_free;
-	}
 
 	/*
 	 * If an interrupt occurred we have to clean up the queue
diff --git a/ipc/util.c b/ipc/util.c
index af976fc6..cfbd8fa 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -183,9 +183,8 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
 			       NULL,           /* parent dir */
 			       &sysvipc_proc_fops,
 			       iface);
-	if (!pde) {
+	if (!pde)
 		kfree(iface);
-	}
 }
 #endif
 
-- 
1.8.1.4

