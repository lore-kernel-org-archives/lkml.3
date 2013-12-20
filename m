Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3LTK1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:27:50 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59288 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3LTK1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:27:47 -0500
Date: Fri, 20 Dec 2013 11:27:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>, Davidlohr Bueso <davidlohr@hp.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131220102742.GA22187@gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
 <20131219192532.GB564@gmail.com>
 <1387481345.5494.1.camel@buesod1.americas.hpqcorp.net>
 <20131219194213.GA824@gmail.com>
 <1387492517.2353.29.camel@joe-AO722>
 <20131220091113.GB21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220091113.GB21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Dec 19, 2013 at 02:35:17PM -0800, Joe Perches wrote:
> > On Thu, 2013-12-19 at 20:42 +0100, Ingo Molnar wrote:
> > > * Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > 
> > > > On Thu, 2013-12-19 at 20:25 +0100, Ingo Molnar wrote:
> > > > > * Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > > > 
> > > > > > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > > > > > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > > > > > Signed-off-by: Jason Low <jason.low2@hp.com>
> > > > > 
> > > > > So, that's not a valid SOB sequence either, the person 
> > > > > sending me a patch should be the last person in the SOB 
> > > > > chain
> > > > 
> > > > Which is why I had it like that in the original version.
> > > 
> > > The problem with that order was that the first person should be 
> > > the primary author and in the 'From' tag.
> > > 
> > > A SOB chain is intended to depict the true propagation/route of 
> > > a patch, from author, through maintainers who handle and forward 
> > > it, to the maintainer who applies it to a Git tree. The patch 
> > > starts up with a single SOB (the primary author's) and every 
> > > 'hop' after that adds a SOB to the tail of the existing SOB 
> > > chain.
> > 
> > Multiple "Signed-off-by:"s are also used when there are multiple 
> > authors of a single patch.
> 
> Abused; which is exactly what we're saying is not correct.
> 
> While doing so we've also found people abusing SoB where Reviewed-by 
> was meant and other 'creative' use.

Yes, so I used to allow and author such signoff sequences years ago, 
but eventually Linus noticed the weirdness and asked me not to do it.

There's so many ways to credit people for contributions:

  - Reviewed-by, Acked-by tags carry credits

  - The changelog can mention someone specifically

  - I sometimes add the "Originally-by:" special tag, if an original
    patch was turned into a real patch by someone else.

  - If there's truly serious contribution then the code itself can
    carry a credit as well.

  - In a clean workflow authorship is naturally expressed through
    being the author of individual patches, and we want to encourage
    people to use clean workflows.

Having clean SOB sequences is also really useful: for example LWN.net 
is trying to keep track of the route of patches, and having 'creative' 
uses for signoffs adds unnecessary noise.

So there's no strong technical justification to pollute the SOB 
sequence with contibution/courtesy Signed-off-by lines, while there's 
good technological reasons to keep it a clean route.

I don't think Linus is buerocratically checking every single SOB 
sequence but statistically if you do too many messy signoffs someone 
eventually notices.

So I'm enforcing clean signoff sequences for the subsystems I maintain 
and patches I apply to Git - I might miss some, and it's not the end 
of the world since it has no functional side effects. Other 
maintainers might be more permissive.

It might make sense to clarify Documentation/SubmittingPatches 
accordingly.

Thanks,

	Ingo
