Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaIJRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:33:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIJRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:33:10 -0400
Date: Wed, 10 Sep 2014 10:31:24 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-caa17d49f9a5cc09b3bbb101dc640f914f3b4ff7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        davem@davemloft.net, linux@roeck-us.net, tglx@linutronix.de,
        sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        davem@davemloft.net, linux@roeck-us.net, sfr@canb.auug.org.au,
        tglx@linutronix.de
In-Reply-To: <20140902094016.GD31157@worktop.ger.corp.intel.com>
References: <20140902094016.GD31157@worktop.ger.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking, sparc64: Fix atomics
Git-Commit-ID: caa17d49f9a5cc09b3bbb101dc640f914f3b4ff7
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

Commit-ID:  caa17d49f9a5cc09b3bbb101dc640f914f3b4ff7
Gitweb:     http://git.kernel.org/tip/caa17d49f9a5cc09b3bbb101dc640f914f3b4ff7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 2 Sep 2014 11:40:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Sep 2014 11:45:04 +0200

locking, sparc64: Fix atomics

The patch folding the atomic ops had a silly fail in the _return primitives.

Fixes: 4f3316c2b5fe ("locking,arch,sparc: Fold atomic_ops")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sparclinux@vger.kernel.org
Link: http://lkml.kernel.org/r/20140902094016.GD31157@worktop.ger.corp.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sparc/lib/atomic_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/lib/atomic_64.S b/arch/sparc/lib/atomic_64.S
index 96d70b4..05dac43 100644
--- a/arch/sparc/lib/atomic_64.S
+++ b/arch/sparc/lib/atomic_64.S
@@ -37,7 +37,7 @@ ENTRY(atomic_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
 	cas	[%o1], %g1, %g7;					\
 	cmp	%g1, %g7;						\
 	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
-	 add	%g1, %o0, %g1;						\
+	 op	%g1, %o0, %g1;						\
 	retl;								\
 	 sra	%g1, 0, %o0;						\
 2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
@@ -76,7 +76,7 @@ ENTRY(atomic64_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
 	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
 	 nop;								\
 	retl;								\
-	 add	%g1, %o0, %o0;						\
+	 op	%g1, %o0, %o0;						\
 2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
 ENDPROC(atomic64_##op##_return);
 
