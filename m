Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaBQAyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:54:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaBQAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:54:30 -0500
Date: Sun, 16 Feb 2014 16:54:10 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-4b5e4f908855a66f0957bf35137ce3ee37c05230@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392587568-7325-10-git-send-email-stefani@seibold.net>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Add a lot more dummy locking functions to vclock_gettime.c
Git-Commit-ID: 4b5e4f908855a66f0957bf35137ce3ee37c05230
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 16 Feb 2014 16:54:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b5e4f908855a66f0957bf35137ce3ee37c05230
Gitweb:     http://git.kernel.org/tip/4b5e4f908855a66f0957bf35137ce3ee37c05230
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 16 Feb 2014 16:44:25 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 Feb 2014 16:44:25 -0800

x86, vdso: Add a lot more dummy locking functions to vclock_gettime.c

We need a lot more dummy locking functions to build in all possible
configurations.

Cc: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392587568-7325-10-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso32/vclock_gettime.c | 58 +++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
index 5de5057..56465ad 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -40,17 +40,69 @@
 #define _ASM_X86_SPINLOCK_H
 
 /*
- * dummys for unneeded arck_spin functions
+ * dummys for unneeded arch_spin functions
  */
-static inline void arch_spin_unlock_wait(void *p)
+static inline void arch_spin_lock(void *lock)
 {
 }
 
-static inline int arch_spin_is_locked(void *p)
+static inline int arch_spin_trylock(void *lock)
 {
 	return 0;
 }
 
+static inline void arch_spin_unlock(void *lock)
+{
+}
+
+static inline void arch_spin_lock_flags(void *lock,
+					unsigned long flags)
+{
+}
+
+static inline void arch_spin_unlock_wait(void *lock)
+{
+}
+
+static inline int arch_spin_is_locked(void *lock)
+{
+	return 0;
+}
+
+static inline int arch_read_trylock(void *lock)
+{
+	return 0;
+}
+
+static inline int arch_write_trylock(void *lock)
+{
+	return 0;
+}
+
+static inline void arch_read_lock(void *rw)
+{
+}
+
+static inline void arch_write_lock(void *rw)
+{
+}
+
+static inline void arch_read_lock_flags(void *rw, unsigned long flags)
+{
+}
+
+static inline void arch_write_lock_flags(void *rw, unsigned long flags)
+{
+}
+
+static inline void arch_read_unlock(void *rw)
+{
+}
+
+static inline void arch_write_unlock(void *rw)
+{
+}
+
 /*
  * The define of CONFIG_ILLEGAL_POINTER_VALUE is also to prevent the
  * "warning: integer constant is too large..."
