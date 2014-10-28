Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaJ1LQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:16:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJ1LQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:16:19 -0400
Date: Tue, 28 Oct 2014 04:15:57 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-61a492fb1759f3e892ad0408e36d3575c5f890d0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, mingo@kernel.org,
        hpa@zytor.com, tglx@linutronix.de
Reply-To: luto@amacapital.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <fcfee6f8749af14d96373a9e2656354ad0b95499.1411494540.git.luto@amacapital.net>
References: <fcfee6f8749af14d96373a9e2656354ad0b95499.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64/vdso: Remove jiffies from the vvar page
Git-Commit-ID: 61a492fb1759f3e892ad0408e36d3575c5f890d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61a492fb1759f3e892ad0408e36d3575c5f890d0
Gitweb:     http://git.kernel.org/tip/61a492fb1759f3e892ad0408e36d3575c5f890d0
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:13 +0100

x86_64/vdso: Remove jiffies from the vvar page

I think that the jiffies vvar was once used for the vgetcpu
cache. That code is long gone, so let's just make jiffies be a
normal variable.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/fcfee6f8749af14d96373a9e2656354ad0b95499.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 0fa2960..25adc0e 100644
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
