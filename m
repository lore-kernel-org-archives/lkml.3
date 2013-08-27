Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3H0Iby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:31:54 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:58852 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3H0Ibw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:31:52 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for ARC
Date: Tue, 27 Aug 2013 14:01:25 +0530
Message-ID: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frame pointer on ARC doesn't serve the conventional purpose of stack
unwinding due to the typical way ABI designates it's usage.
Thus it's explicit usage on ARC is discouraged (gcc is free to use it,
for some tricky stack frames even if -fomit-frame-pointer).

Hence no point enabling it for ARC.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org
---
 lib/Kconfig.debug | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1501aa5..c971f3a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -908,7 +908,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1347,7 +1347,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
@@ -1357,7 +1357,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
-- 
1.8.1.2

