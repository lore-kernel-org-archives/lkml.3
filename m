Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaHERmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:42:24 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:12366 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaHERmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:42:23 -0400
Message-ID: <1407260539.6493.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] arch,locking: Ciao arch_mutex_cpu_relax()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 05 Aug 2014 10:42:19 -0700
In-Reply-To: <CAMuHMdX2ZCEd=J_Gpf-W+Zyqg27r4C6ULZgO=pg2houR-FXLvg@mail.gmail.com>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
	 <20140623065835.GF19860@laptop.programming.kicks-ass.net>
	 <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
	 <20140625062510.GB4260@osiris>
	 <CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>
	 <1404079773.2619.4.camel@buesod1.americas.hpqcorp.net>
	 <CAMuHMdX2ZCEd=J_Gpf-W+Zyqg27r4C6ULZgO=pg2houR-FXLvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 15:04 +0200, Geert Uytterhoeven wrote:
> It looks like you forgot to update frv?  It's been failing on -next since a
> few days:
> 
> kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
> function 'cpu_relax_lowlatency'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
> function 'cpu_relax_lowlatency'
> [-Werror=implicit-function-declaration]
> make[3]: *** [kernel/locking/mcs_spinlock.o] Error 1
> cc1: some warnings being treated as errors
> make[3]: *** [kernel/locking/mutex.o] Error 1
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/11616307/

Ah, indeed. Thanks for the report, afaict this was the only missing
arch .

8<---------------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] frv: Define cpu_relax_lowlatency()

Fixes errors such as:

kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of function 'cpu_relax_lowlatency'

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 arch/frv/include/asm/processor.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index a34f309..6554e78 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -129,7 +129,8 @@ unsigned long get_wchan(struct task_struct *p);
 #define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
 #define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
 
-#define cpu_relax()    barrier()
+#define cpu_relax() barrier()
+#define cpu_relax_lowlatency() cpu_relax()
 
 /* data cache prefetch */
 #define ARCH_HAS_PREFETCH
-- 
1.8.1.4



