Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3HVSja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:39:30 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62213 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3HVSj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:39:26 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>, security@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH 1/2] net: Check the correct namespace when spoofing pid over SCM_RIGHTS
Date: Thu, 22 Aug 2013 11:39:15 -0700
Message-Id: <ff9dd301d8c91ec02362d52494b4a640f370bc68.1377196394.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1377196394.git.luto@amacapital.net>
References: <cover.1377196394.git.luto@amacapital.net>
In-Reply-To: <cover.1377196394.git.luto@amacapital.net>
References: <cover.1377196394.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a security bug.

The follow-up will fix nsproxy to discourage this type of issue from
happening again.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 net/core/scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 03795d0..b4da80b 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -54,7 +54,7 @@ static __inline__ int scm_check_creds(struct ucred *creds)
 		return -EINVAL;
 
 	if ((creds->pid == task_tgid_vnr(current) ||
-	     ns_capable(current->nsproxy->pid_ns->user_ns, CAP_SYS_ADMIN)) &&
+	     ns_capable(task_active_pid_ns(current)->user_ns, CAP_SYS_ADMIN)) &&
 	    ((uid_eq(uid, cred->uid)   || uid_eq(uid, cred->euid) ||
 	      uid_eq(uid, cred->suid)) || nsown_capable(CAP_SETUID)) &&
 	    ((gid_eq(gid, cred->gid)   || gid_eq(gid, cred->egid) ||
-- 
1.8.3.1

