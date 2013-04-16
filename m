Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935974Ab3DPS0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935828Ab3DPS0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 06/28] proc: Move proc_fd() to fs/proc/fd.h [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:26:17 +0100
Message-ID: <20130416182617.27773.90168.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move proc_fd() to fs/proc/fd.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/fd.h       |    5 +++++
 fs/proc/internal.h |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/fd.h b/fs/proc/fd.h
index cbb1d47..7c047f2 100644
--- a/fs/proc/fd.h
+++ b/fs/proc/fd.h
@@ -11,4 +11,9 @@ extern const struct inode_operations proc_fdinfo_inode_operations;
 
 extern int proc_fd_permission(struct inode *inode, int mask);
 
+static inline int proc_fd(struct inode *inode)
+{
+	return PROC_I(inode)->fd;
+}
+
 #endif /* __PROCFS_FD_H__ */
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index aaf2dd8..32d8f51 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -94,11 +94,6 @@ static inline struct task_struct *get_proc_task(struct inode *inode)
 	return get_pid_task(proc_pid(inode), PIDTYPE_PID);
 }
 
-static inline int proc_fd(struct inode *inode)
-{
-	return PROC_I(inode)->fd;
-}
-
 static inline int task_dumpable(struct task_struct *task)
 {
 	int dumpable = 0;

