Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3JXHcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:32:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3JXHbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:08 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847755"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 17/20] nsproxy: don't make create_new_namespaces static
Date: Thu, 24 Oct 2013 15:32:02 +0800
Message-Id: <1382599925-25143-18-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:30,
	Serialize complete at 2013/10/24 15:28:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit moudule will use create_new_namespaces to
create new nsproxy.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/nsproxy.h | 4 ++++
 kernel/nsproxy.c        | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index dc7af11..7ae15fc 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -73,6 +73,10 @@ void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
 void free_nsproxy(struct nsproxy *ns);
 int unshare_nsproxy_namespaces(unsigned long, struct nsproxy **,
 	struct cred *, struct fs_struct *);
+struct nsproxy *create_new_namespaces(unsigned long flags,
+				      struct task_struct *tsk,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs);
 int __init nsproxy_cache_init(void);
 
 static inline void put_nsproxy(struct nsproxy *ns)
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index e8374aa..a8cf2f4 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -60,7 +60,7 @@ static inline struct nsproxy *create_nsproxy(void)
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(unsigned long flags,
+struct nsproxy *create_new_namespaces(unsigned long flags,
 	struct task_struct *tsk, struct user_namespace *user_ns,
 	struct fs_struct *new_fs)
 {
-- 
1.8.3.1

