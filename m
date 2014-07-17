Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaGQSMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:12:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42779 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaGQSJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:09:24 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v12 01/11] seccomp: create internal mode-setting function
Date: Thu, 17 Jul 2014 11:08:28 -0700
Message-Id: <1405620518-18495-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405620518-18495-1-git-send-email-keescook@chromium.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for having other callers of the seccomp mode setting
logic, split the prctl entry point away from the core logic that performs
seccomp mode setting.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/seccomp.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 301bbc24739c..afb916c7e890 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -473,7 +473,7 @@ long prctl_get_seccomp(void)
 }
 
 /**
- * prctl_set_seccomp: configures current->seccomp.mode
+ * seccomp_set_mode: internal function for setting seccomp mode
  * @seccomp_mode: requested mode to use
  * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
  *
@@ -486,7 +486,7 @@ long prctl_get_seccomp(void)
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 {
 	long ret = -EINVAL;
 
@@ -517,3 +517,15 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 out:
 	return ret;
 }
+
+/**
+ * prctl_set_seccomp: configures current->seccomp.mode
+ * @seccomp_mode: requested mode to use
+ * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
+ *
+ * Returns 0 on success or -EINVAL on failure.
+ */
+long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+{
+	return seccomp_set_mode(seccomp_mode, filter);
+}
-- 
1.7.9.5

