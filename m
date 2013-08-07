Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3HGQDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:03:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35436 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753077Ab3HGQDk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:03:40 -0400
Date: Wed, 7 Aug 2013 12:03:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130807160336.GA1336@Krystal>
References: <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com> <1375798783.25420.30.camel@gandalf.local.home> <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com> <1375811885.25420.44.camel@gandalf.local.home> <20130806203319.GA16170@Krystal> <1375821817.25420.50.camel@gandalf.local.home> <1375836304.25420.76.camel@gandalf.local.home> <1375836960.25420.80.camel@gandalf.local.home> <20130807050601.GA5385@domone.kolej.mff.cuni.cz> <1375887730.6848.7.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1375887730.6848.7.camel@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2013-08-07 at 07:06 +0200, Ondřej Bílka wrote:
> 
> > Add short_counter,long_counter and before increment counter before each
> > jump. That way we will know how many short/long jumps were taken. 
> 
> That's not trivial at all. The jump is a single location (in an asm
> goto() statement) that happens to be inlined through out the kernel. The
> assembler decides if it will be a short or long jump. How do you add a
> counter to count the difference?

You might want to try creating a global array of counters (accessible
both from C for printout and assembly for update).

Index the array from assembly using:   (2f - 1f)

1:
        jmp ...;
2:

And put an atomic increment of the counter. This increment instruction
should be located prior to the jmp for obvious reasons.

You'll end up with the sums you're looking for at indexes 2 and 5 of the
array.

Thanks,

Mathieu

> 
> The output I gave is from the boot up code that converts the jmp back to
> a nop (or in this case, the default nop to the ideal nop). It knows the
> size by reading the op code. This is a static analysis, not a running
> one. It's no trivial task to have a counter for each jump.
> 
> There is a way though. If we enable all the jumps (all tracepoints, and
> other users of jumplabel), record the trace and then compare the trace
> to the output that shows which ones were short jumps, and all others are
> long jumps.
> 
> I'll post the patches soon and you can have fun doing the compare :-)
> 
> Actually, I'm working on the 4 patches of the series that is more about
> clean ups and safety checks than the jmp conversion. That is not
> controversial, and I'll be posting them for 3.12 soon.
> 
> After that, I'll post the updated patches that have the conversion as
> well as the counter, for RFC and for others to play with.
> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
