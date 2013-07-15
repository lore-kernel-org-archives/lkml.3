Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3GOQ7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:59:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab3GOQ7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:59:00 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: restore order of tty and ses fields in log output
Date: Mon, 15 Jul 2013 12:57:40 -0400
Message-Id: <1373907460-4538-1-git-send-email-rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When being refactored from audit_log_start() to audit_log_task_info(), in
commit e23eb920 the tty and ses fields in the log output got transposed.
Restore to original order to avoid breaking search tools.

Cc: stable@vger.kernel.org # v3.6
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..63b2dd5 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1590,7 +1590,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	audit_log_format(ab,
 			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
-			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
+			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
 			 sys_getppid(),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
@@ -1602,7 +1602,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 from_kgid(&init_user_ns, cred->egid),
 			 from_kgid(&init_user_ns, cred->sgid),
 			 from_kgid(&init_user_ns, cred->fsgid),
-			 audit_get_sessionid(tsk), tty);
+			 tty, audit_get_sessionid(tsk));
 
 	get_task_comm(name, tsk);
 	audit_log_format(ab, " comm=");
-- 
1.7.1

