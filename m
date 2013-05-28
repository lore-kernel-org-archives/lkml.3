Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab3E1Mzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:55:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab3E1Mzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:55:48 -0400
Date: Tue, 28 May 2013 05:55:23 -0700
From: tip-bot for Paul Bolle <tipbot@zytor.com>
Message-ID: <tip-4eedb77a9cd8f2e68b31c8b9a20524a50727c16f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1368780693.1350.228.camel@x61.thuisdomein>
References: <1368780693.1350.228.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Fix copy/paste errors of "
 ARCH_INLINE_*_UNLOCK_BH"
Git-Commit-ID: 4eedb77a9cd8f2e68b31c8b9a20524a50727c16f
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

Commit-ID:  4eedb77a9cd8f2e68b31c8b9a20524a50727c16f
Gitweb:     http://git.kernel.org/tip/4eedb77a9cd8f2e68b31c8b9a20524a50727c16f
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Fri, 17 May 2013 10:51:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 08:50:00 +0200

locking: Fix copy/paste errors of "ARCH_INLINE_*_UNLOCK_BH"

The Kconfig symbols ARCH_INLINE_READ_UNLOCK_IRQ,
ARCH_INLINE_SPIN_UNLOCK_IRQ, and ARCH_INLINE_WRITE_UNLOCK_IRQ were added
in v2.6.33, but have never actually been used. Ingo Molnar spotted that
this is caused by three identical copy/paste erros. Eg, the Kconfig
entry for

    INLINE_READ_UNLOCK_IRQ

has an (optional) dependency on:

    ARCH_INLINE_READ_UNLOCK_BH

were it apparently should depend on:

    ARCH_INLINE_READ_UNLOCK_IRQ

instead. Likewise for the Kconfig entries for INLINE_SPIN_UNLOCK_IRQ and
INLINE_WRITE_UNLOCK_IRQ. Fix these three errors.

This never really caused any real problems as these symbols are set (or
unset) in a group - but it's worth fixing it nevertheless.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1368780693.1350.228.camel@x61.thuisdomein
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Kconfig.locks | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 44511d1..d2b32ac 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -138,7 +138,7 @@ config INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_IRQ
 
 config INLINE_SPIN_UNLOCK_IRQRESTORE
 	def_bool y
@@ -175,7 +175,7 @@ config INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_IRQ
 
 config INLINE_READ_UNLOCK_IRQRESTORE
 	def_bool y
@@ -212,7 +212,7 @@ config INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_IRQ
 
 config INLINE_WRITE_UNLOCK_IRQRESTORE
 	def_bool y
