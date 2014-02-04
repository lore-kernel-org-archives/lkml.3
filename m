Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438AbaBDXCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:02:33 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:32819 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933902AbaBDXC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:02:28 -0500
X-Sasl-enc: QFdX+lerh4krkd7kcsGH9J2m9tmzqybZtzlDTQMNYpr2 1391554945
From: Sebastian Keller <sebastiankeller@fastmail.net>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org,
        Sebastian Keller <sebastiankeller@fastmail.net>
Subject: [PATCH] kernel: nsproxy.c: fixed coding style issues
Date: Wed,  5 Feb 2014 00:02:07 +0100
Message-Id: <1391554927-6013-1-git-send-email-sebastiankeller@fastmail.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 3 coding style issues (80 column limit, trailing whitespace)

Signed-off-by: Sebastian Keller <sebastiankeller@fastmail.net>
---
 kernel/nsproxy.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e78110..049774a 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -67,7 +67,8 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
-	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, user_ns, new_fs);
+	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, user_ns,
+					new_fs);
 	if (IS_ERR(new_nsp->mnt_ns)) {
 		err = PTR_ERR(new_nsp->mnt_ns);
 		goto out_ns;
@@ -144,7 +145,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	 * it along with CLONE_NEWIPC.
 	 */
 	if ((flags & (CLONE_NEWIPC | CLONE_SYSVSEM)) ==
-		(CLONE_NEWIPC | CLONE_SYSVSEM)) 
+		(CLONE_NEWIPC | CLONE_SYSVSEM))
 		return -EINVAL;
 
 	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
@@ -174,7 +175,8 @@ void free_nsproxy(struct nsproxy *ns)
  * On success, returns the new nsproxy.
  */
 int unshare_nsproxy_namespaces(unsigned long unshare_flags,
-	struct nsproxy **new_nsp, struct cred *new_cred, struct fs_struct *new_fs)
+	struct nsproxy **new_nsp, struct cred *new_cred,
+	struct fs_struct *new_fs)
 {
 	struct user_namespace *user_ns;
 	int err = 0;
-- 
1.8.5.3

