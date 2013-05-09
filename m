Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3EIADB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:03:01 -0400
Received: from ozlabs.org ([203.10.76.45]:60190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab3EIAC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:02:59 -0400
Message-ID: <1368057766.17894.3.camel@concordia>
Subject: Re: Invalid perf_branch_entry.to entries question
From: Michael Ellerman <michael@ellerman.id.au>
To: Michael Neuling <mikey@neuling.org>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Date: Thu, 09 May 2013 10:02:46 +1000
In-Reply-To: <15099.1368053151@ale.ozlabs.ibm.com>
References: <25394.1367890528@ale.ozlabs.ibm.com>
	 <20130508155929.GA8459@dyad.programming.kicks-ass.net>
	 <CABPqkBRSMxQK8LJWhD39yo8EQZBd3-dRkeMqvwhWwLiHa6m66g@mail.gmail.com>
	 <15099.1368053151@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 08:45 +1000, Michael Neuling wrote:
> Stephane Eranian <eranian@google.com> wrote:
> 
> > On Wed, May 8, 2013 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, May 07, 2013 at 11:35:28AM +1000, Michael Neuling wrote:
> > >> Peter & Stephane,
> > >>
> > >> We are plumbing the POWER8 Branch History Rolling Buffer (BHRB) into
> > >> struct perf_branch_entry.
> > >>
> > >> Sometimes on POWER8 we may not be able to fill out the "to" address.
> > >
> > > Just because I'm curious.. however does that happen? Surely the CPU knows where
> > > next to fetch instructions?
> > >
> > >> We
> > >> initially thought of just making this 0, but it's feasible that this
> > >> could be a valid address to branch to.
> > >
> > > Right, while highly unlikely, x86 actually has some cases where 0 address is
> > > valid *shudder*..
> > >
> > >> The other logical value to indicate an invalid entry would be all 1s
> > >> which is not possible (on POWER at least).
> > >>
> > >> Do you guys have a preference as to what we should use as an invalid
> > >> entry?  This would have some consequences for the userspace tool also.
> > >>
> > >> The alternative would be to add a flag alongside mispred/predicted to
> > >> indicate the validity of the "to" address.
> > >
> > > Either would work with me I suppose.. Stephane do you have any preference?
> > 
> > But if the 'to' is bogus, why not just drop the sample?
> > That happens on x86 if the HW captured branches which do not correspond to
> > user filter settings (due to bug).
> 
> We can I guess but it seems useful to log the from address when
> possible.  

Yeah I think it is useful. Knowing that you were there, but the to
address is invalid, is better than wondering why you never hit the code
at all.

cheers

