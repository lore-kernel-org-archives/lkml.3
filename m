Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaFWNEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:04:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaFWNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 43/93] audit: restore order of tty and ses fields in log output
Date: Mon, 23 Jun 2014 14:02:22 +0100
Message-Id: <1403528592-2163-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit 2f2ad1013322c8f6c40fc6dafdbd32442fa730ad upstream.

When being refactored from audit_log_start() to audit_log_task_info(), in
commit e23eb920 the tty and ses fields in the log output got transposed.
Restore to original order to avoid breaking search tools.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index aea9a1963e79..50512d11a445 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1615,7 +1615,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	audit_log_format(ab,
 			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
-			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
+			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
 			 task_ppid_nr(tsk),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
@@ -1627,7 +1627,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 from_kgid(&init_user_ns, cred->egid),
 			 from_kgid(&init_user_ns, cred->sgid),
 			 from_kgid(&init_user_ns, cred->fsgid),
-			 audit_get_sessionid(tsk), tty);
+			 tty, audit_get_sessionid(tsk));
 
 	get_task_comm(name, tsk);
 	audit_log_format(ab, " comm=");
-- 
1.9.1

