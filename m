Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBND6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:58:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaBND6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:58:19 -0500
Date: Thu, 13 Feb 2014 19:58:07 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-40747ffa5aa8d5b99ca46c696234b9194b59e0ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-3-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-3-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage: Make jiffies visible
Git-Commit-ID: 40747ffa5aa8d5b99ca46c696234b9194b59e0ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:58:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40747ffa5aa8d5b99ca46c696234b9194b59e0ac
Gitweb:     http://git.kernel.org/tip/40747ffa5aa8d5b99ca46c696234b9194b59e0ac
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:51:59 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:12:09 -0800

asmlinkage: Make jiffies visible

Jiffies is referenced by the linker script, so it has to be visible.

Handled both the generic and the x86 version.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-3-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/time.c | 2 +-
 kernel/timer.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 24d3c91..6ec91c0 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -23,7 +23,7 @@
 #include <asm/time.h>
 
 #ifdef CONFIG_X86_64
-DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
+__visible DEFINE_VVAR(volatile unsigned long, jiffies) = INITIAL_JIFFIES;
 #endif
 
 unsigned long profile_pc(struct pt_regs *regs)
diff --git a/kernel/timer.c b/kernel/timer.c
index accfd24..d78de04 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -52,7 +52,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/timer.h>
 
-u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
+__visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
 
