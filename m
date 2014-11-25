Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaKYBIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:08:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaKYBHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:07:34 -0500
Subject: [RFC PATCH 2/4] nsproxy - make create_new_namespaces() non-static
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Oleg Nesterov <onestero@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 25 Nov 2014 09:07:28 +0800
Message-ID: <20141125010727.4974.27785.stgit@pluto.fritz.box>
In-Reply-To: <20141125005255.4974.54193.stgit@pluto.fritz.box>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_new_namespaces() will be needed by call_usermodehelper_ns()
and call_usermodehelper_keys() for namespace restricted execution.

Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/nsproxy.h |    3 +++
 kernel/nsproxy.c        |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 35fa08f..dfe7dda 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -62,6 +62,9 @@ extern struct nsproxy init_nsproxy;
  *
  */
 
+struct nsproxy *create_new_namespaces(unsigned long flags,
+	struct task_struct *tsk, struct user_namespace *user_ns,
+	struct fs_struct *new_fs);
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
 void exit_task_namespaces(struct task_struct *tsk);
 void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index ef42d0a..dcfbb13 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -56,7 +56,7 @@ static inline struct nsproxy *create_nsproxy(void)
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(unsigned long flags,
+struct nsproxy *create_new_namespaces(unsigned long flags,
 	struct task_struct *tsk, struct user_namespace *user_ns,
 	struct fs_struct *new_fs)
 {

