Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3IISuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:50:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab3IISpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 15/24] net: Check the correct namespace when spoofing pid over SCM_RIGHTS
Date: Mon,  9 Sep 2013 11:45:05 -0700
Message-Id: <1378752314-2416-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit d661684cf6820331feae71146c35da83d794467e upstream.

This is a security bug.

The follow-up will fix nsproxy to discourage this type of issue from
happening again.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 2dc6cda..7b6d0d9 100644
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
1.8.1.2

