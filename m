Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158Ab3DHPhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:37:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab3DHPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:37:05 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=OBBN2wN6VI8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=B2NTZjWQ9qwA:10 a=WfulkdPnAAAA:8 a=QyXUC8HyAAAA:8 a=NkLCyU6eLXcKNtJZWf4A:9 a=QEXdDO2ut3YA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365435422.25498.7.camel@gandalf.local.home>
Subject: Re: [PATCH] perf: Enable function tracing for perf core
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 08 Apr 2013 11:37:02 -0400
In-Reply-To: <m2y5d7h6kb.fsf@firstfloor.org>
References: <1362785086-12901-1-git-send-email-andi@firstfloor.org>
	 <m2y5d7h6kb.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 08:45 -0700, Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > According to Steven R. there is no reason left to not support
> > function tracing for the perf core. This makes it easier to debug
> > perf.
> >
> > Don't remove -pg for the x86 and generic perf core.
> 
> Ping! patch is missing review.
> 

This needs an acked-by from either Peter or Frederic.

-- Steve

> 
> >
> > Cc: rostedt@goodmis.org
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/Makefile |    1 -
> >  kernel/events/Makefile       |    4 ----
> >  2 files changed, 0 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> > index a0e067d..8eb5d28 100644
> > --- a/arch/x86/kernel/cpu/Makefile
> > +++ b/arch/x86/kernel/cpu/Makefile
> > @@ -5,7 +5,6 @@
> >  # Don't trace early stages of a secondary CPU boot
> >  ifdef CONFIG_FUNCTION_TRACER
> >  CFLAGS_REMOVE_common.o = -pg
> > -CFLAGS_REMOVE_perf_event.o = -pg
> >  endif
> >  
> >  # Make sure load_percpu_segment has no stackprotector
> > diff --git a/kernel/events/Makefile b/kernel/events/Makefile
> > index 103f5d1..a630994 100644
> > --- a/kernel/events/Makefile
> > +++ b/kernel/events/Makefile
> > @@ -1,7 +1,3 @@
> > -ifdef CONFIG_FUNCTION_TRACER
> > -CFLAGS_REMOVE_core.o = -pg
> > -endif
> > -
> >  obj-y := core.o ring_buffer.o callchain.o
> >  
> >  obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
> 


