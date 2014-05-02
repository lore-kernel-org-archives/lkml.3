Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaEBPpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:45:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaEBPpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 083/151] audit: restore order of tty and ses fields in log output
Date: Fri,  2 May 2014 08:37:51 -0700
Message-Id: <1399045139-4531-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit 2f2ad1013322c8f6c40fc6dafdbd32442fa730ad upstream.

When being refactored from audit_log_start() to audit_log_task_info(), in
commit e23eb920 the tty and ses fields in the log output got transposed.
Restore to original order to avoid breaking search tools.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 15ec13a..a1e584f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1719,7 +1719,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	audit_log_format(ab,
 			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
-			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
+			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
 			 sys_getppid(),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
@@ -1731,7 +1731,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 from_kgid(&init_user_ns, cred->egid),
 			 from_kgid(&init_user_ns, cred->sgid),
 			 from_kgid(&init_user_ns, cred->fsgid),
-			 audit_get_sessionid(tsk), tty);
+			 tty, audit_get_sessionid(tsk));
 
 	get_task_comm(name, tsk);
 	audit_log_format(ab, " comm=");
-- 
1.9.1

