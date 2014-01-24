Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaAXRbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:31:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaAXRbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:31:51 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: stable@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH] audit: restore order of tty and ses fields in log output
Date: Fri, 24 Jan 2014 12:31:07 -0500
Message-Id: <2f2ad1013322c8f6c40fc6dafdbd32442fa730ad.1390584353.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When being refactored from audit_log_start() to audit_log_task_info(), in
commit e23eb920 the tty and ses fields in the log output got transposed.
Restore to original order to avoid breaking search tools.

Cc: stable@vger.kernel.org # v3.6
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/audit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 3d3747b..e88f599 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1716,7 +1716,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 	audit_log_format(ab,
 			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
 			 " euid=%u suid=%u fsuid=%u"
-			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
+			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
 			 sys_getppid(),
 			 tsk->pid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
@@ -1728,7 +1728,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 from_kgid(&init_user_ns, cred->egid),
 			 from_kgid(&init_user_ns, cred->sgid),
 			 from_kgid(&init_user_ns, cred->fsgid),
-			 audit_get_sessionid(tsk), tty);
+			 tty, audit_get_sessionid(tsk));
 
 	get_task_comm(name, tsk);
 	audit_log_format(ab, " comm=");
-- 
1.7.1

