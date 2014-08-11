Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaHKNha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:37:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32809 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398AbaHKNh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:37:28 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/2] arm64: compat: wire up memfd_create and getrandom syscalls for aarch32
Date: Mon, 11 Aug 2014 14:37:07 +0100
Message-Id: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/ just grew support for the new memfd_create and getrandom
syscalls, so add them to our compat layer too.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/unistd.h   | 2 +-
 arch/arm64/include/asm/unistd32.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 4bc95d27e063..6d2bf419431d 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -41,7 +41,7 @@
 #define __ARM_NR_compat_cacheflush	(__ARM_NR_COMPAT_BASE+2)
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
 
-#define __NR_compat_syscalls		383
+#define __NR_compat_syscalls		386
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index e242600c4046..da1f06b535e3 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -787,3 +787,8 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
 __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
 #define __NR_renameat2 382
 __SYSCALL(__NR_renameat2, sys_renameat2)
+			/* 383 for seccomp */
+#define __NR_getrandom 384
+__SYSCALL(__NR_getrandom, sys_getrandom)
+#define __NR_memfd_create 385
+__SYSCALL(__NR_memfd_create, sys_memfd_create)
-- 
2.0.1

