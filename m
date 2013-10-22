Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3JVQNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:13:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:61399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab3JVQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:13:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396828245"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org
Subject: [PATCH 03/11] asmlinkage: Make jiffies visible
Date: Tue, 22 Oct 2013 09:12:18 -0700
Message-Id: <1382458346-24811-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
index 4296d13..a3ae2da 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -52,7 +52,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/timer.h>
 
-u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
+__visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
 
-- 
1.8.3.1

