Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036Ab3DPS0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935828Ab3DPS0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 08/28] proc: Move PDE_NET() to fs/proc/proc_net.c [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:26:23 +0100
Message-ID: <20130416182623.27773.21187.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PDE_NET() to fs/proc/proc_net.c as that's where the only user is.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/proc_net.c      |    4 ++++
 include/linux/proc_fs.h |    5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index b4ac657..986e832 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -26,6 +26,10 @@
 
 #include "internal.h"
 
+static inline struct net *PDE_NET(struct proc_dir_entry *pde)
+{
+	return pde->parent->data;
+}
 
 static struct net *get_proc_net(const struct inode *inode)
 {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 8f7d8f2..3377224 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -187,11 +187,6 @@ static inline void *PDE_DATA(const struct inode *inode)
 	return PROC_I(inode)->pde->data;
 }
 
-static inline struct net *PDE_NET(struct proc_dir_entry *pde)
-{
-	return pde->parent->data;
-}
-
 #include <linux/signal.h>
 
 void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);

