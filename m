Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3JCPf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:35:28 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43057 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3JCPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:35:26 -0400
Date: Thu, 3 Oct 2013 17:35:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131003153522.GA31978@gmail.com>
References: <20130924154159.855373283@linux.com>
 <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com>
 <20130924171029.GB10261@gmail.com>
 <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
 <20130925181146.GA16693@gmail.com>
 <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com>
 <20130928084412.GC26167@gmail.com>
 <0000014179b65a63-512751f8-346a-4621-b6d1-9abd62e781c9-000000@email.amazonses.com>
 <20131003072100.GA5775@gmail.com>
 <000001417eac34d5-43f9e4c6-661b-4329-ab17-4b8a044922c8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001417eac34d5-43f9e4c6-661b-4329-ab17-4b8a044922c8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 3 Oct 2013, Ingo Molnar wrote:
> 
> > It was important to me and other maintainers as well back then and today
> > as well, as me and others complained about it out numerous times.
> 
> Yes there were some complaints and in discussions about what to do. I 
> suggested how this could be addressed. But no patches showed up [...]

_You_ added the facility with broken (== non-existent) preemption 
debugging for __this_cpu ops, _you_ caused Peter Zijstra and others to 
waste time due to you ignoring those requests to add debugging. Everyone 
rightfully expected _you_ to fix the problem you introduced.

And now you blame the victims of your sloppiness, that they should have 
fixed the problem you introduced?

> [...] and there were always other more pressing things. Especially since 
> this is a minor issue related to CONFIG_PREEMPT which seems to be not in 
> use in the kernels that I see in HPC, FIS and the industry at large.

People wasting time and the kernel becoming less robust is not a minor 
issue at all.

> > I can fix that omission easily: consider all your __this_cpu* patches 
> > NAK-ed by me until the (trivial) preemption debug checks are upstream 
> > worthy:
> >
> >   - tested
> >   - complete
> >   - don't produce false warnings when enabled.
> 
> Not sure what tests you will like to see run and if it is even possible 
> to test all possible kernel runtime configurations. You seem to have 
> some setup to do some testing along these lines I believe?

As a starting point it would be fine if you tested it on your own systems 
with all relevant debugging enabled...

> These two patches will allow this testing to be done. And I do not see 
> any mention of technical issues with the code. [...]

Here's the list of open technical problems:

 - Lack of testing - you have not stated it whether any warnings trigger 
   with those two patches applied and debugging enabled, on your systems.

 - I pointed out in detail how your last submission was broken in several 
   places which show lack of time and care on the patch series.

 - Your statement in the discussion that warnings will trigger with the
   debug option enabled points to an obvious technical problem as well - 
   all warnings known to trigger by you should be fixed by you, as part of 
   the series.

Please resolve these technical problems and resend a clean, tested, 
working series.

Until all the problems are addressed my NAK stands and I suspect Peter 
Zijlstra's as well.

Thanks,

	Ingo
