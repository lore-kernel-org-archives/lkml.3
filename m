Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaFSMh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:37:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFSMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:37:55 -0400
Date: Thu, 19 Jun 2014 05:36:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4f3aaf2c2ba35bc2cd823a240f9969ebfb3c7549@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, davej@redhat.com, pebolle@tiscali.nl,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        pebolle@tiscali.nl, Waiman.Long@hp.com, tglx@linutronix.de
In-Reply-To: <20140611090509.GC3588@twins.programming.kicks-ass.net>
References: <20140611090509.GC3588@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] x86, locking: Use no more OOSTORE nonsense
Git-Commit-ID: 4f3aaf2c2ba35bc2cd823a240f9969ebfb3c7549
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

Commit-ID:  4f3aaf2c2ba35bc2cd823a240f9969ebfb3c7549
Gitweb:     http://git.kernel.org/tip/4f3aaf2c2ba35bc2cd823a240f9969ebfb3c7549
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Jun 2014 11:01:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:41:22 +0200

x86, locking: Use no more OOSTORE nonsense

Paul reported that X86_OOSTORE is dead, yay! Update a comment and
remove a newly added reference.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/20140611090509.GC3588@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/barrier.h | 2 +-
 arch/x86/include/asm/qrwlock.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 5c7198c..0f4460b 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -99,7 +99,7 @@
 #if defined(CONFIG_X86_PPRO_FENCE)
 
 /*
- * For either of these options x86 doesn't have a strong TSO memory
+ * For this option x86 doesn't have a strong TSO memory
  * model and we should fall back to full barriers.
  */
 
diff --git a/arch/x86/include/asm/qrwlock.h b/arch/x86/include/asm/qrwlock.h
index 70f46f0..ae0e241 100644
--- a/arch/x86/include/asm/qrwlock.h
+++ b/arch/x86/include/asm/qrwlock.h
@@ -3,7 +3,7 @@
 
 #include <asm-generic/qrwlock_types.h>
 
-#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#ifndef CONFIG_X86_PPRO_FENCE
 #define queue_write_unlock queue_write_unlock
 static inline void queue_write_unlock(struct qrwlock *lock)
 {
