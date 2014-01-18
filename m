Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaARJs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 04:48:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaARJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 04:48:23 -0500
Message-ID: <1390038366.5676.10.camel@marge.simpson.net>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Mike Galbraith <bitbucket@online.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 18 Jan 2014 10:46:06 +0100
In-Reply-To: <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
	 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	 <20140116222536.GX30183@twins.programming.kicks-ass.net>
	 <20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
	 <52D8625C.1000902@zytor.com>
	 <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:JUXugMeVsseakICSFI970OlSE5EWurWMO2sQWSLebIY
 vp4woKNbzf8Y+Rnsg6pOj/bcFmvDvZ6TMXvejZ+QXEPu7iJ7Ms
 eBWsDq+u/8isVhKDZdpfIPOlKDvNOchKvXDiSDU7BN5bbchtrG
 D95zwAWKg6PTfTEF98DVSI7CHkc7fX6Pwk0r2/IaC1wh9Hg7q8
 TvhyHDH0eu0i97ClpYYBp+HzqK2uTlsNMIAeTqlb68OzPG6Agj
 KNvhNc6fvT3yWYZpoGiHDwY6L6exhRluduhtGMBTe3hZ2vOIT8
 QeiAWXiqCsEy/5iZNxgUNqExgkwRZEebMjPatet5HLhtae25I2
 a7LndcGEvjMakJuZRtJvU+hbhEyX1Gabs+UKYuB90L3INZdr8+
 fGr4NMfeRYt5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 14:45 +1100, Stephen Rothwell wrote: 
> Hi all,
> 
> On Thu, 16 Jan 2014 14:51:08 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> > On 01/16/2014 02:34 PM, Stephen Rothwell wrote:
> > > 
> > > On Thu, 16 Jan 2014 23:25:36 +0100 Peter Zijlstra
> > > <peterz@infradead.org> wrote:
> > >> 
> > >> On Fri, Jan 17, 2014 at 07:46:28AM +1100, Stephen Rothwell
> > >> wrote:
> > >>> 
> > >>> On Thu, 16 Jan 2014 13:19:55 +0100 Peter Zijlstra
> > >>> <peterz@infradead.org> wrote:
> > >>>> 
> > >>>> I think the below ought to work
> > >>> 
> > >>> To be clear, all you did was replace the body of mwait_idle()
> > >>> with
> > >>> 
> > >>> mwait_idle_with_hints(0, 0);
> > >> 
> > >> Pretty much, and add the asm/mwait.h include, otherwise you'll
> > >> end up with a compile fail.
> > >> 
> > >>> (and the comment above it)?  I need to apply in incremental
> > >>> patch in the merge commit.
> > >> 
> > >> I don't think I touched the comment at all.
> > > 
> > 
> > In retrospect this bit probably should have gone through the idle
> > tree.  That was my bad, I need to coordinate with Len better.
> 
> So this is what I added as a merge fix patch.  Someone just needs to make
> sure Linus gets this when the latter of the tow trees gets merged.

I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
Q6600 box.  See below for an alternative.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 17 Jan 2014 14:42:06 +1100
> Subject: [PATCH] x86 idle: mwait_idle merge update
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/kernel/process.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index db471a87fdd8..4da840f01561 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -28,6 +28,7 @@
>  #include <asm/fpu-internal.h>
>  #include <asm/debugreg.h>
>  #include <asm/nmi.h>
> +#include <asm/mwait.h>
>  
>  /*
>   * per-CPU TSS segments. Threads are completely 'soft' on Linux,
> @@ -427,18 +428,7 @@ static int prefer_mwait_c1_over_halt(const struct cpuinfo_x86 *c)
>  
>  static void mwait_idle(void)
>  {
> -	if (!need_resched()) {
> -		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> -			clflush((void *)&current_thread_info()->flags);
> -
> -		__monitor((void *)&current_thread_info()->flags, 0, 0);
> -		smp_mb();
> -		if (!need_resched())
> -			__sti_mwait(0, 0);
> -		else
> -			local_irq_enable();
> -	} else
> -		local_irq_enable();
> +	mwait_idle_with_hints(0, 0);
>  }
>  
>  void select_idle_routine(const struct cpuinfo_x86 *c)
> -- 
> 1.8.5.2

idle: kill unnecessary mwait_idle() resched IPIs

Set/clear polling instead.

Q6600, pipe-test scheduling cross core:
3.8.13                   487.2 KHz    1.000
3.13.0-master            415.5 KHz     .852
3.13.0-master+           415.2 KHz     .852     + restore mwait_idle
3.13.0-master++          488.5 KHz    1.002     + restore mwait_idle + IPI fix
3.13.0-next-20140117     -ENOBOOT
3.13.0-next-20140117+    531.4 KHz    1.090     + IPI fix

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 arch/x86/include/asm/processor.h |    8 ++++++++
 arch/x86/kernel/process.c        |   10 +++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -723,6 +723,14 @@ static inline void sync_core(void)
 #endif
 }
 
+static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
+{
+	trace_hardirqs_on();
+	/* "mwait %eax, %ecx;" */
+	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
+		     :: "a" (eax), "c" (ecx));
+}
+
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_amd_e400_c1e_mask(void);
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/mwait.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -427,18 +428,21 @@ static int prefer_mwait_c1_over_halt(con
 
 static void mwait_idle(void)
 {
-	if (!need_resched()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+	if (!current_set_polling_and_test()) {
+		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+			mb();
 			clflush((void *)&current_thread_info()->flags);
+			mb();
+		}
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
 		if (!need_resched())
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
 	} else
 		local_irq_enable();
+	current_clr_polling();
 }
 
 void select_idle_routine(const struct cpuinfo_x86 *c)


