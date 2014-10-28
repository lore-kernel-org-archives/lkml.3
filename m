Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaJ1LJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:09:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaJ1LJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:09:06 -0400
Date: Tue, 28 Oct 2014 04:08:13 -0700
From: "tip-bot for Peter Zijlstra (Intel)" <tipbot@zytor.com>
Message-ID: <tip-65d71fe1375b973083733294795bf2b09d45b3c2@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, acme@kernel.org
Reply-To: hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, acme@kernel.org, luto@amacapital.net
In-Reply-To: <20141007124757.GH19379@twins.programming.kicks-ass.net>
References: <20141007124757.GH19379@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix bogus kernel printk
Git-Commit-ID: 65d71fe1375b973083733294795bf2b09d45b3c2
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

Commit-ID:  65d71fe1375b973083733294795bf2b09d45b3c2
Gitweb:     http://git.kernel.org/tip/65d71fe1375b973083733294795bf2b09d45b3c2
Author:     Peter Zijlstra (Intel) <peterz@infradead.org>
AuthorDate: Tue, 7 Oct 2014 19:07:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:51:01 +0100

perf: Fix bogus kernel printk

Andy spotted the fail in what was intended as a conditional printk level.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Fixes: cc6cd47e7395 ("perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141007124757.GH19379@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1b8299d..66451a6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -243,8 +243,9 @@ static bool check_hw_exists(void)
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
-	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
-	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
+	printk("%sFailed to access perfctr msr (MSR %x is %Lx)\n",
+		boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR,
+		reg, val_new);
 
 	return false;
 }
