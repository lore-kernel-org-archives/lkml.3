Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3IYBPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:15:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab3IYAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 029/110] net: Check the correct namespace when spoofing pid over SCM_RIGHTS
Date: Tue, 24 Sep 2013 17:14:27 -0700
Message-Id: <20130925001326.564102433@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit d661684cf6820331feae71146c35da83d794467e upstream.

This is a security bug.

The follow-up will fix nsproxy to discourage this type of issue from
happening again.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/scm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -54,7 +54,7 @@ static __inline__ int scm_check_creds(st
 		return -EINVAL;
 
 	if ((creds->pid == task_tgid_vnr(current) ||
-	     ns_capable(current->nsproxy->pid_ns->user_ns, CAP_SYS_ADMIN)) &&
+	     ns_capable(task_active_pid_ns(current)->user_ns, CAP_SYS_ADMIN)) &&
 	    ((uid_eq(uid, cred->uid)   || uid_eq(uid, cred->euid) ||
 	      uid_eq(uid, cred->suid)) || nsown_capable(CAP_SETUID)) &&
 	    ((gid_eq(gid, cred->gid)   || gid_eq(gid, cred->egid) ||


