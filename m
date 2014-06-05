Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbaFEEBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:01:25 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59306 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbaFEEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:01:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMOAF3qj1N5La4v/2dsb2JhbABZgwerdAEBAQEBBpgnAYELF3SCJQEBBAE6HBUHBwULCAMYCSUPBSUDIRMUiCYH0lwXFoU/iBFsB4MrgRUEmhKTOoNKK4E5
Date: Thu, 5 Jun 2014 14:01:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: josh@joshtriplett.org, Joe Perches <joe@perches.com>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140605040107.GA4453@dastard>
References: <20140602185504.GA13569@cloud>
 <1401735917.7323.23.camel@joe-AO725>
 <20140602190951.GA13648@cloud>
 <1401736666.7323.25.camel@joe-AO725>
 <20140602231949.GV14410@dastard>
 <20140602235915.GB14801@cloud>
 <20140603011125.GW14410@dastard>
 <20140602213045.26219ddb@gandalf.local.home>
 <20140603071654.GC14410@dastard>
 <20140603134347.6e39f946@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603134347.6e39f946@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:43:47PM -0400, Steven Rostedt wrote:
> On Tue, 3 Jun 2014 17:16:54 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> 
> > If you take it to an extremes. Think about what you can test in 15
> > minutes. Or for larger patchsets, how long it takes you to read the
> > patchset?
> 
> Yeah, what about that?

That testing a patch for obvious, common regressions takes no longer
than it does to read and review the logic. 

> > IMO, every reviewer has their own developement environment and they
> > should be at least testing that the change they are reviewing
> > doesn't cause problems in that environment, just like they do for
> > their own code before they post it for review.
> 
> Let me ask you this. In the scientific community, when someone posts a
> research project and asks their peers to review their work. Are all
> those reviewers required to test out that paper?
> Or are they to review it, check the math, look for cases that are
> missed, see common errors, and other checks? I'm sure some
> reviewers may do various tests, but others will just check the
> logic. I'm having a very hard time seeing where Reviewed-by means
> tested-by. I see those as two completely different tags.

We are not conducting a scientific research experiment here. We are
conduting a very large software *engineering* project here.

So perhaps we should be using robust software engineering processes
rather than academic peer review as the model for our code review
process?

> > > I find the reviewers of my code to be the worse testers.
> > > That's because those that I ask to review my code know what
> > > it's suppose to do, and those are the people that are not
> > > going to stumble over bugs. It's the people that have no idea
> > > how your code works that will trigger the most bugs in testing
> > > it. My best testers would be my worse reviewers.
> > 
> > "Reviewers are the worst testers".
> > 
> > Yet you accept the code they write as sufficiently well tested
> > for merging? :/
> 
> Heh, that's why I have a full test suite. Yes, I run my tests on
> every single patch (to make sure it's fully bisectable, this is
> why I wrote ktest.pl).
> 
> And yes, I find bugs and then send the patches back to be fixed. I
> never blindly accept anyone's patches and just merge it.

IOWs, part of your patch acceptance requirement is that patches are
fully bisectable and mostly pass your own tests. Isn't that exactly
what I've been saying Reviewed-by is supposed to mean?

Anyway, let's not split hairs over the testing levels anymore, we
can agree to disagree there. Why? Because that disagreement is the
most important point here: reviewed-by means different things to
different people, and that's a big problem from a software
engineering process point of view.

> > > patches, but since I don't have an XFS filesystem, I doubt
> > > that would be much use for you.
> > 
> > I don't want you to review XFS code - you have no domain
> > specific knowledge nor a test environment for XFS changes. IOWs,
> > you meet none of the requirements to give a "reviewed-by" for an
> > XFS change, and so to say you reviewed a change makes a mockery
> > of the expectations outlines in the SubmittingPatches
> > guidelines.
> 
> Actually, I would be able to review tracing changes in XFS. I've
> given tags like "Revieved-by: Steven Rostedt <rostedt@goodmis.org>
> # for the tracing part". before.

But in that case you are reviewing tracing code - not XFS code -
which is within your field of expertise. However, I wouldn't expect
your review to tell me that the tracepoints are accessing some
internal XFS state unsafely or not providing the information that
the patch submitter expects to provide. That side of things still
needs XFS expertise to determine....

> > Reviewed-by only has value when it is backed by process and
> > domain specific knowledge. If the person giving that tag doesn't
> > have either of these, then it's worthless and they need to be
> > taught what the correct thing to do is. Most people (even
> > projects) don't learn proper software engineering processes
> > until after they have been at the pointy end of a pile of crap
> > at least once. :/
> 
> This last paragraph I totally agree with. There's a few people
> that I trust very much so for a review. I don't expect them to
> test my code, but they are usually good enough to see something
> that may break under certain conditions. I don't add any review-by
> tags from anyone I don't already have a working relationship with
> and trust their judgment.

Again, you're demonstrating exactly the problem I see: Reviewed-by
has no meaning unless the maintainer trusts the developer and knows
they have the necessary processes in place to perform a reliable
review.

> What I'm saying is that to most, Reviewed-by means just that. The
> patch was reviewed. I think the person adding their reviewed-by
> tag is placing their reputation on the line. I know I am every
> time I add it.  That's why I give a lot more "Acked-by" than
> "Reviewed-by". Those acks are me saying "I skimmed the patch, and
> there's nothing in there that bothers me". I does not mean that I
> looked over every change in detail.

That's exactly how I use the two tags as well. If I'm not going to
(or can't) fully commit to a review, Acked-by is what I use. But you
or I are not the problem here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
