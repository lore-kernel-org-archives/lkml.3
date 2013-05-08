Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3EHWpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:45:53 -0400
Received: from ozlabs.org ([203.10.76.45]:34734 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3EHWpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:45:52 -0400
From: Michael Neuling <mikey@neuling.org>
To: Stephane Eranian <eranian@google.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Subject: Re: Invalid perf_branch_entry.to entries question
In-reply-to: <CABPqkBRSMxQK8LJWhD39yo8EQZBd3-dRkeMqvwhWwLiHa6m66g@mail.gmail.com>
References: <25394.1367890528@ale.ozlabs.ibm.com> <20130508155929.GA8459@dyad.programming.kicks-ass.net> <CABPqkBRSMxQK8LJWhD39yo8EQZBd3-dRkeMqvwhWwLiHa6m66g@mail.gmail.com>
Comments: In-reply-to Stephane Eranian <eranian@google.com>
   message dated "Wed, 08 May 2013 23:33:52 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Thu, 09 May 2013 08:45:51 +1000
Message-ID: <15099.1368053151@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> wrote:

> On Wed, May 8, 2013 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, May 07, 2013 at 11:35:28AM +1000, Michael Neuling wrote:
> >> Peter & Stephane,
> >>
> >> We are plumbing the POWER8 Branch History Rolling Buffer (BHRB) into
> >> struct perf_branch_entry.
> >>
> >> Sometimes on POWER8 we may not be able to fill out the "to" address.
> >
> > Just because I'm curious.. however does that happen? Surely the CPU knows where
> > next to fetch instructions?
> >
> >> We
> >> initially thought of just making this 0, but it's feasible that this
> >> could be a valid address to branch to.
> >
> > Right, while highly unlikely, x86 actually has some cases where 0 address is
> > valid *shudder*..
> >
> >> The other logical value to indicate an invalid entry would be all 1s
> >> which is not possible (on POWER at least).
> >>
> >> Do you guys have a preference as to what we should use as an invalid
> >> entry?  This would have some consequences for the userspace tool also.
> >>
> >> The alternative would be to add a flag alongside mispred/predicted to
> >> indicate the validity of the "to" address.
> >
> > Either would work with me I suppose.. Stephane do you have any preference?
> 
> But if the 'to' is bogus, why not just drop the sample?
> That happens on x86 if the HW captured branches which do not correspond to
> user filter settings (due to bug).

We can I guess but it seems useful to log the from address when
possible.  

Can we log it and userspace tools can ignore it if it's not useful?

Mikey
