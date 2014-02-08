Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaBHHxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:53:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaBHHwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471774440"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/14] asmlinkage: Make jiffies visible
Date: Sat,  8 Feb 2014 08:51:59 +0100
Message-Id: <1391845930-28580-3-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiffies is referenced by the linker script, so it has to be visible.

Handled both the generic and the x86 version.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
 
-- 
1.8.5.2

