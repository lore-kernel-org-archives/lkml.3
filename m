Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaBQDv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 22:51:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBQDv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 22:51:57 -0500
Date: Sun, 16 Feb 2014 19:51:30 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-bd9ee7fd99f127ee1306289415141d45792c97f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392587568-7325-10-git-send-email-stefani@seibold.net>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Instead of dummy functions, include <
 linux/spinlock_up.h>
Git-Commit-ID: bd9ee7fd99f127ee1306289415141d45792c97f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 16 Feb 2014 19:51:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd9ee7fd99f127ee1306289415141d45792c97f3
Gitweb:     http://git.kernel.org/tip/bd9ee7fd99f127ee1306289415141d45792c97f3
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 16 Feb 2014 19:47:01 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 Feb 2014 19:47:01 -0800

x86, vdso: Instead of dummy functions, include <linux/spinlock_up.h>

The list of dummy functions is insufficient.  However, instead of
having a full list of dummy functions we can include
<linux/spinlock_up.h> which contains the (trivial) implementations
that we use on uniprocessor.

There aren't supposed to be any spinlocks at all in the VDSO, of
course.

Cc: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392587568-7325-10-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso32/vclock_gettime.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
index 5de5057..2335f26 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -36,20 +36,12 @@
  * a lot of warnings with make C=1.
  * It is imposible not to include spinlock.h since most kernel headers does
  * include it.
+ *
+ * <linux/spinlock_up.h> includes the minimal functions which are used
+ * on UP; include it instead.
  */
 #define _ASM_X86_SPINLOCK_H
-
-/*
- * dummys for unneeded arck_spin functions
- */
-static inline void arch_spin_unlock_wait(void *p)
-{
-}
-
-static inline int arch_spin_is_locked(void *p)
-{
-	return 0;
-}
+#include <linux/spinlock_up.h>
 
 /*
  * The define of CONFIG_ILLEGAL_POINTER_VALUE is also to prevent the
