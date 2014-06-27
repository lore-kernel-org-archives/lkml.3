Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaF0XXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:23:53 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44851 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaF0XXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:23:51 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v9 01/11] seccomp: create internal mode-setting function
Date: Fri, 27 Jun 2014 16:22:50 -0700
Message-Id: <1403911380-27787-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403911380-27787-1-git-send-email-keescook@chromium.org>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for having other callers of the seccomp mode setting
logic, split the prctl entry point away from the core logic that performs
seccomp mode setting.

Signed-off-by: Kees Cook <keescook@chromium.org>
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

