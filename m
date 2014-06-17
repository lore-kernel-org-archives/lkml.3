Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaFQCXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:23:41 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44932 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbaFQCX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:23:29 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/8] x86_64,vdso: Remove jiffies from the vvar page
Date: Mon, 16 Jun 2014 19:23:11 -0700
Message-Id: <0dc0031c4de3bc394204540577d731900cca0fe0.1402971639.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402971639.git.luto@amacapital.net>
References: <cover.1402971639.git.luto@amacapital.net>
In-Reply-To: <cover.1402971639.git.luto@amacapital.net>
References: <cover.1402971639.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that the jiffies vvar was once used for the vgetcpu cache.
That code is long gone, so let's just make jiffies be a normal
variable.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vvar.h | 1 -
 arch/x86/kernel/time.c      | 2 +-
 arch/x86/vdso/vgetcpu.c     | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 5d2b9ad..5f6d407 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -44,7 +44,6 @@ extern char __vvar_page;
 
 /* DECLARE_VVAR(offset, type, name) */
 
-DECLARE_VVAR(0, volatile unsigned long, jiffies)
 DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index bf7ef5c..822773b 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -23,7 +23,7 @@
 #include <asm/time.h>
 
 #ifdef CONFIG_X86_64
-__visible DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
+__visible volatile unsigned long jiffies __cacheline_aligned = INITIAL_JIFFIES;
 #endif
 
 unsigned long profile_pc(struct pt_regs *regs)
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 2f94b03..add1d98 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -7,7 +7,6 @@
 
 #include <linux/kernel.h>
 #include <linux/getcpu.h>
-#include <linux/jiffies.h>
 #include <linux/time.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
-- 
1.9.3

