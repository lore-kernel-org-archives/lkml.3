Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbaE2OY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:24:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59302 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbaE2Nt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/103] audit: restore order of tty and ses fields in log output
Date: Thu, 29 May 2014 15:47:47 +0200
Message-Id: <5872d5558f8b2e001207dd558a2a5f6327d54ed9.1401371258.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2f2ad1013322c8f6c40fc6dafdbd32442fa730ad upstream.

When being refactored from audit_log_start() to audit_log_task_info(), in
commit e23eb920 the tty and ses fields in the log output got transposed.
Restore to original order to avoid breaking search tools.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 6def25f1b351..74ced93e5703 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1615,7 +1615,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	audit_log_format(ab,
 			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
-			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
+			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
 			 sys_getppid(),
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
1.9.3

