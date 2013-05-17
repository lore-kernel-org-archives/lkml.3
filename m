Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3EQWOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:14:55 -0400
Received: from ozlabs.org ([203.10.76.45]:41037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097Ab3EQWOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:14:53 -0400
From: Michael Neuling <mikey@neuling.org>
To: Stephane Eranian <eranian@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
In-reply-to: <CABPqkBSSg8Sfpa5xG-DCpX-qY22qeRVtwzVPTPD4K=3DmS5dUA@mail.gmail.com>
References: <20130503121122.931661809@chello.nl> <20130503121256.230745028@chello.nl> <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com> <20130516090916.GF19669@dyad.programming.kicks-ass.net> <8578.1368699317@ale.ozlabs.ibm.com> <20130516111634.GA15314@twins.programming.kicks-ass.net> <CABPqkBSCXJN7gLK_e_Q3YVVVFVGS78fo4j2z0+MmriqoXszH+w@mail.gmail.com> <20130517111232.GE5162@dyad.programming.kicks-ass.net> <29969.1368790328@ale.ozlabs.ibm.com> <20130517113922.GF5162@dyad.programming.kicks-ass.net> <CABPqkBSSg8Sfpa5xG-DCpX-qY22qeRVtwzVPTPD4K=3DmS5dUA@mail.gmail.com>
Comments: In-reply-to Stephane Eranian <eranian@google.com>
   message dated "Fri, 17 May 2013 23:39:46 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Sat, 18 May 2013 08:14:52 +1000
Message-ID: <30065.1368828892@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> wrote:

> On Fri, May 17, 2013 at 1:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, May 17, 2013 at 09:32:08PM +1000, Michael Neuling wrote:
> >> Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> > Wouldn't it be mostly conditional branches that are the primary control flow
> >> > and can get predicted wrong? I mean, I'm sure someone will miss-predict an
> >> > unconditional branch but its not like we care about people with such
> >> > afflictions do we?
> >>
> >> You could mispredict the target address of a computed goto.  You'd know
> >> it was taken but not know target address until later in the pipeline.
> >
> > Oh right, computed targets could indeed be mis predicted. I was more thinking
> > about jumps with immediate values.
> >
> >> On this, the POWER8 branch history buffer tells us two things about the
> >> prediction status.
> >>   1) if the branch was predicted taken/not taken correctly
> >>   2) if the target address was predicted correctly or not (for computed
> >>      gotos only)
> >> So we'd actually like more prediction bits too :-D
> >
> > So if I understand this right, 1) maps to the predicted flags we have; 2)
> > would be new stuff?
> >
> > We don't really have anything like that on x86, but I suppose if you make the
> > thing optional and present a 'useful' use-case implemented in userspace code
> > we could take it :-)
> >
> >> > Anyway, since PPC people thought it worth baking into hardware,
> >> > presumably they have a compelling use case. Mikey could you see if you
> >> > can retrieve that from someone in the know? It might be interesting.
> >>
> >> I don't think we can mispredict a non-conditional non-computed but I'll
> >> have to check with the HW folks.
> >
> > I was mostly wondering about the use-case for the conditional filter. Stephane
> > didn't think it useful, clearly your hardware guys thought different :-)
> 
> From my experience talking with compiler people, they care about ALL
> the branches and not the conditional so much. They use LBR to do basic
> block profiling.

OK.  I don't have a good handle on what's useful for compilers or JITs
right now.  I'm just plumbing through what's possible.

Mikey

