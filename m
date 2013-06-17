Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab3FQNA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:00:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43060 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3FQNAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:00:25 -0400
Date: Mon, 17 Jun 2013 15:00:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130617130004.GV3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-4-git-send-email-alex.shi@intel.com>
 <CAPM31RJFsh_gBXBHc4E6z=MtORR9D8sWs=86Yqy9onxK9x9fOg@mail.gmail.com>
 <51BB25BC.9070500@intel.com>
 <20130617092146.GM3204@twins.programming.kicks-ass.net>
 <CAPM31RKnosQ21GbiG7txV1roCzzYh1u_8i+EBBp8mP3q-ZWVCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RKnosQ21GbiG7txV1roCzzYh1u_8i+EBBp8mP3q-ZWVCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 02:39:53AM -0700, Paul Turner wrote:
> I actually did read it before, and still wasn't sure of the right tag to use.
> 
> "13) When to use Acked-by: and Cc:
> 
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path.
> 
> If a person was not directly involved in the preparation or handling of a
> patch but wishes to signify and record their approval of it then they can
> arrange to have an Acked-by: line added to the patch's changelog."
> https://www.kernel.org/doc/Documentation/SubmittingPatches
> 
> Acked-By seemed to fail the direct involvement test.
> The definition of "delivery path" is not clear; is this strictly by
> inputs to Linus' tree or recipients of the original patch?

The way I interpret the delivery path is when its part of a bigger
grouping. The author is always the first SOB, if the patch series isn't
by the same author then he who compiles the aggregate work adds his SOB.

Similar for (sub)maintainers passing it onwards towards Linus. I compile
batches of patch series and feed them to Ingo, Ingo stuffs the lot into
-tip and feeds them to Linus.

So supposing you wrote a patch, gave it to Alex who composed the bigger
series, which I picked up and handed to Ingo we'd get something like:

SoB: PJT
SoB: Alex
SoB: PeterZ
SoB: Mingo

and then when Linus pulls the lot he could add his SOB too, although
looking at git history he typically doesn't add his sob to each and
everything he pulls.

But yes, I see where the confusion stems from.

> Is Reviewed-By always more appropriate here?

Yes, or even Acked would work. The difference between reviewed and acked
is the level of involvement. An ack is for something you glanced over
and generally agree with, a review is for something you looked at in
minute detail.

Then there's some people (and I tend to lean towards this) who can't be
bothered with that distinction too much and simply always use ack.


