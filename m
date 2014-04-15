Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaDOShJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaDOShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:04 -0400
Date: Tue, 15 Apr 2014 20:36:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND2 01/11] signals: kill sigfindinword()
Message-ID: <20140415183637.GA13389@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has no users and it doesn't look useful. I do not know why/when it
was introduced, I can't even find any user in the git history.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/signal.h |    9 ---------
 arch/x86/include/asm/signal.h  |    6 ------
 include/linux/signal.h         |    5 -----
 3 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 214320b..8c8ce5e 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -60,15 +60,6 @@ static inline int __gen_sigismember(sigset_t *set, int _sig)
 	 __const_sigismember(set,sig) :		\
 	 __gen_sigismember(set,sig))
 
-static inline int sigfindinword(unsigned long word)
-{
-	asm ("bfffo %1{#0,#0},%0"
-		: "=d" (word)
-		: "d" (word & -word)
-		: "cc");
-	return word ^ 31;
-}
-
 #endif /* !CONFIG_CPU_HAS_NO_BITFIELDS */
 
 #ifndef __uClinux__
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 35e67a4..31eab86 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -92,12 +92,6 @@ static inline int __gen_sigismember(sigset_t *set, int _sig)
 	 ? __const_sigismember((set), (sig))	\
 	 : __gen_sigismember((set), (sig)))
 
-static inline int sigfindinword(unsigned long word)
-{
-	asm("bsfl %1,%0" : "=r"(word) : "rm"(word) : "cc");
-	return word;
-}
-
 struct pt_regs;
 
 #else /* __i386__ */
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..ae744c3 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -63,11 +63,6 @@ static inline int sigismember(sigset_t *set, int _sig)
 		return 1 & (set->sig[sig / _NSIG_BPW] >> (sig % _NSIG_BPW));
 }
 
-static inline int sigfindinword(unsigned long word)
-{
-	return ffz(~word);
-}
-
 #endif /* __HAVE_ARCH_SIG_BITOPS */
 
 static inline int sigisemptyset(sigset_t *set)
-- 
1.5.5.1

