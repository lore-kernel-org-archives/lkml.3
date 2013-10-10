Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3JJAgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:36:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:61942 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754640Ab3JJAgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:36:33 -0400
Date: Wed, 9 Oct 2013 20:36:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
Message-ID: <20131009203627.27166b20@gandalf.local.home>
In-Reply-To: <878uy2ytd8.fsf@tassilo.jf.intel.com>
References: <20131009144150.108f7041@gandalf.local.home>
	<5255C07E.70805@linux.intel.com>
	<878uy2ytd8.fsf@tassilo.jf.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Oct 2013 15:25:23 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> "H. Peter Anvin" <hpa@linux.intel.com> writes:
> 
> >> Summary
> >> -------
> >> 
> >> Although the extreme case shows a nice improvement, I'm skeptical if it
> >> is worth doing for real world applications.
> >
> > You did the experiment, and credit to you for not going "I did the work,
> > now include it" but rather for publishing the results so we can learn
> > from them.
> >
> > It *does* make me wonder if we can leverage RTM for a significant subset
> > of these (as an interrupt will abort a transaction); that should be
> > substantially cheaper and less complex.
> 
> I miss the original context and can't find the original patchkit, but:

Yeah, for some reason, the original email didn't make it to LKML.

Dave,

I don't know why my email never reached LKML, was there something about
it that prevented it from going? The total character length was 46,972,
well below the 100,000 limit. Also the Cc list wasn't that big. Did my
ISP get flagged as a spam bot or something?

I can bounce it to you to see what was wrong with it.

-- Steve

> 
> - If the goal is to lower interrupt latency then RTM would still
> need to use a fallback, so the worst case would be the fallback, thus
> not be better.
> 
> - If the goal is to make CLI/STI faster:
> I'm not sure RTM is any faster than a PUSHF/CLI/POPF pair. It may
> well be slightly slower in fact (guessing here, haven't benchmarked)
> 
> - Also when you abort you would need to reexecute of course.
> 
> - My TSX patchkit actually elides CLI/STI inside transactions
> (no need to do them, as any interrupt would abort anyways)
> but the main motivation was to avoid extra aborts.
> 
> - That said, I think a software CLI/STI is somewhat useful for profiling,
> as it can allow to measure how long interrupts are delayed
> by CLI/STI.  I heard use cases of this, but I'm not 
> sure how common it really is
> 
> [I presume a slightly modified RT kernel could also give the same
> profiling results]
> 
> -Andi
> 

