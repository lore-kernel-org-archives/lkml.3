Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3JCQpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:45:08 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57006 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3JCQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:45:04 -0400
Date: Thu, 3 Oct 2013 18:44:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131003164459.GA32755@gmail.com>
References: <20130924171029.GB10261@gmail.com>
 <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
 <20130925181146.GA16693@gmail.com>
 <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com>
 <20130928084412.GC26167@gmail.com>
 <0000014179b65a63-512751f8-346a-4621-b6d1-9abd62e781c9-000000@email.amazonses.com>
 <20131003072100.GA5775@gmail.com>
 <000001417eac34d5-43f9e4c6-661b-4329-ab17-4b8a044922c8-000000@email.amazonses.com>
 <20131003153522.GA31978@gmail.com>
 <000001417f0b7a11-76e469b6-2d0c-4726-8611-27a2ada3e3ec-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001417f0b7a11-76e469b6-2d0c-4726-8611-27a2ada3e3ec-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 3 Oct 2013, Ingo Molnar wrote:
> 
> > _You_ added the facility with broken (== non-existent) preemption 
> > debugging for __this_cpu ops, _you_ caused Peter Zijstra and others to 
> > waste time due to you ignoring those requests to add debugging. 
> > Everyone rightfully expected _you_ to fix the problem you introduced.
> 
> Oh what __this_cpu ops was doing was clearly documented at the time it 
> was merged.

In hindsight it was merged prematurely - such things happen. After it was 
merged multiple people ran into problems: Thomas Gleixner, Peter Zijlstra 
and myself. IIRC at the Kernel Summit Linus agreed as well that not having 
__this_cpu() debug ops was a mistake.

If your only argument left is "but it was merged in that inferior form", 
and you refuse to fix its shortcomings, then our answer is to learn from 
our mistake and not merge patches from you in the future, until the 
facility is fixed.

> > And now you blame the victims of your sloppiness, that they should 
> > have fixed the problem you introduced?
> 
> I fix problems that others introduce into my subsystems as well. If 
> there is a problem then usually someone shows up with patches to address 
> these.
> 
> > People wasting time and the kernel becoming less robust is not a minor 
> > issue at all.
> 
> Well then I would have expected someone to show up with patches 
> following through on what was discussed. I am no expert on preemption.

If you don't understand the impact of your changes and the fragility it 
introduces then that's one more reason to not merge more patches from you 
until you rectify your omissions.

> > As a starting point it would be fine if you tested it on your own 
> > systems with all relevant debugging enabled...
> 
> Ok done that.
> 
> > > These two patches will allow this testing to be done. And I do not see
> > > any mention of technical issues with the code. [...]
> >
> > Here's the list of open technical problems:
> >
> >  - Lack of testing - you have not stated it whether any warnings 
> >    trigger with those two patches applied and debugging enabled, on 
> >    your systems.
> 
> I have posted an earlier patchset which includes fixes for the warnings 
> that were triggered. It described the testing that was done.

That 'earlier' patch set was with a different version of the preemption 
checks, and it's not at all clear whether the same warnings still trigger 
with your latest series.

> >  - I pointed out in detail how your last submission was broken in 
> >    several places which show lack of time and care on the patch 
> >    series.
> 
> This is regarding the garbled subject line in your inbox? So you want me 
> to fix the quilt tool now? I can just make this a single patch if that 
> helps?

Other people are able to submit patch series with non-garbled subject 
lines using Quilt and other tools. You should not blame Quilt for your 
messed up submission.

> >  - Your statement in the discussion that warnings will trigger with
> >    the debug option enabled points to an obvious technical problem as 
> >    well - all warnings known to trigger by you should be fixed by you, 
> >    as part of the series.
> 
> The problem is that you raised more issues related to the fixes that I 
> posted. I dont think this can be handled in one patchset.

I disagree - but in any case the patch set is not acceptable for upstream 
in its current form and my NAK stands, until this is fixed.

Thanks,

	Ingo
