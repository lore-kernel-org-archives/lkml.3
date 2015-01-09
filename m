Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbbAIP5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:57:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58933 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbbAIP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:57:36 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] compat: Declare compat_sys_sigpending and compat_sys_sigprocmask prototypes
Date: Fri,  9 Jan 2015 15:57:24 +0000
Message-Id: <1420819048-3515-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
References: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ARCH_WANT_SYS_SIGPENDING or __ARCH_WANT_SYS_SIGPROGMASK may be defined
for compat support but the corresponding prototypes are missing from
linux/compat.h.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 7450ca2ac1fc..ab25814690bc 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -689,6 +689,15 @@ asmlinkage long compat_sys_sendfile64(int out_fd, int in_fd,
 asmlinkage long compat_sys_sigaltstack(const compat_stack_t __user *uss_ptr,
 				       compat_stack_t __user *uoss_ptr);
 
+#ifdef __ARCH_WANT_SYS_SIGPENDING
+asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set);
+#endif
+
+#ifdef __ARCH_WANT_SYS_SIGPROCMASK
+asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *nset,
+				       compat_old_sigset_t __user *oset);
+#endif
+
 int compat_restore_altstack(const compat_stack_t __user *uss);
 int __compat_save_altstack(compat_stack_t __user *, unsigned long);
 #define compat_save_altstack_ex(uss, sp) do { \
