Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaFCRnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:43:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:44871 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751221AbaFCRnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:43:50 -0400
Date: Tue, 3 Jun 2014 13:43:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: josh@joshtriplett.org, Joe Perches <joe@perches.com>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603134347.6e39f946@gandalf.local.home>
In-Reply-To: <20140603071654.GC14410@dastard>
References: <1401734669.7323.20.camel@joe-AO725>
	<20140602145020.400d4e0c@gandalf.local.home>
	<20140602185504.GA13569@cloud>
	<1401735917.7323.23.camel@joe-AO725>
	<20140602190951.GA13648@cloud>
	<1401736666.7323.25.camel@joe-AO725>
	<20140602231949.GV14410@dastard>
	<20140602235915.GB14801@cloud>
	<20140603011125.GW14410@dastard>
	<20140602213045.26219ddb@gandalf.local.home>
	<20140603071654.GC14410@dastard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 17:16:54 +1000
Dave Chinner <david@fromorbit.com> wrote:


> If you take it to an extremes. Think about what you can test in 15
> minutes. Or for larger patchsets, how long it takes you to read the
> patchset?

Yeah, what about that?

> 
> IMO, every reviewer has their own developement environment and they
> should be at least testing that the change they are reviewing
> doesn't cause problems in that environment, just like they do for
> their own code before they post it for review.

Let me ask you this. In the scientific community, when someone posts a
research project and asks their peers to review their work. Are all
those reviewers required to test out that paper? Or are they to review
it, check the math, look for cases that are missed, see common errors,
and other checks? I'm sure some reviewers may do various tests, but
others will just check the logic. I'm having a very hard time seeing
where Reviewed-by means tested-by. I see those as two completely
different tags.

> 
> Code being reviewed should pass the same testing bar that the
> developer uses for code they write and send for review. A maintainer
> quickly learns whose test environments are up to scratch or not. :/

This very much limits your review base. Maybe you're this paranoid
because for filesystems, if something goes wrong, people's data is
gone. If something goes wrong with tracing or even the scheduler,
people may get pissed but seldom do they lose a lot of work.

> 
> > > But you can't say that is it both free of techical and known
> > > issues without both reading the code and testing it (Reviewed-by).
> > 
> > I disagree. Testing only tests what you run. It's useless otherwise.
> > Most code I review, and find bugs for in that review, will not be
> > caught by tests unless you ran it on a 1024 CPU box for a week.
> > 
> > I value looking hard at code much more than booting it and running some
> > insignificant micro test.
> 
> Running "insignficant micro tests" is exactly that - insignificant -
> and it's not a robust code review if that is all that is done.
> Runing *regression tests*, OTOH....

I really think you are bending the definition of Reviewed-by. Perhaps
Regression-tested-by would be more appropriate?

> 
> I know from experience that a "quick" 15 minute run on xfstests on a
> ramdisk will catch 99% of typical problems a filesystem patch might
> introduce. Code coverage reporting (done recently by RH QE
> engineers) tells me that this covers between 50-70% of the
> filesystem, VFS and MM subsystems (numbers vary with fs being
> tested), and so that's a pretty good, fast smoke test that I can run
> on any patch or patchset that is sent for review.

Testing is fine, but I think you are undervaluing true review. Seems to
me, all you ask for others to do is to run their test suite on the code
to give a reviewed-by. I ask for people to look at the logic and spend
a lot more time on seeing if something strange is there. I found people
find things that tests usually don't. That's because before I post code
for review, I usually run it under a lot of tests myself that weeds out
most of those bugs.

> 
> Any significant patch set requires longer to read and digest than a
> full xfstests run across all my test machines (about 80 minutes for
> a single mkfs/mount option configuration). So by the time I've
> actually read the code and commented on it, it's been through a full
> test cycle and it's pretty clear if there are problems or not..
> 
> And so when I say "reviewed-by" I'm pretty certain that there aren't
> any known issues.  Sure, it's not going to catch the "ran it on a
> 1024 CPU box for a week" type of bug, but that's the repsonsibility
> of the bug reporter to give you a "tested-by" for that specific
> problem.

But a good review *can* catch a bug that would trigger on a 1024 CPU
box! Really, I've had people point things out that I said, oh! but that
would be a really hard race to get to. And then go and fix it.
Sometimes, people will find things that have been broken for years in a
review of a patch that touches code around the broken part.


> 
> And really, that points out *exactly* the how "reviewed-by" is a far
> more onerous than "tested-by". Tested-by only means the patch fixes
> the *specific problem* that was reported.  Reviewed-by means that,
> as far as the reviewer can determine, it doesn't cause regressions
> or other problems. It may or may not imply "tested-by" depending on
> the nature of the bug being fixed, but it certainly implies "no
> obvious regressions".  They are two very different meanings, and
> reviewed-by has a much, much wider scope than "tested-by".

I don't see reviewed-by as a wider scope than tested-by, I seem them
under two completely different scopes.

To me, a reviewed-by is someone spent time agonizing over every single
change, and how that change affects the code. I remember spending a
full week on a couple of patches for RCU that Paul submitted a while
ago. I may have run the code, but there's really no test I have that
would trigger the changes. I went back and forth with Paul and we found
a few minor issues and when it was done, I gave my Reviewed-by for it.
I was exhausted, but I learned a lot. I really did understand how that
code worked. Unfortunately, I forgot everything I learned since then ;-)


> 
> > > And, yes, this is the definition we've been using for "reviewed-by"
> > > for XFS code since, well, years before the "reviewed-by" tag even
> > > existed...
> > 
> > Fine, just like all else. That is up to the maintainer to decide. You
> > may require people to run and test it as their review, but I require
> > that people understand the code I write and look for those flaws that
> > 99% of tests wont catch.
> > 
> > I run lots of specific tests on the code I write, I don't expect those
> > that review my code to do the same. In fact that's never what I even
> > ask for when I ask someone to review my code. Note, I do ask for
> > testers when I want people to test it, but those are not the same
> > people that review my code.
> 
> Very few subsystems have dedicated testers and hence rely on the
> test environments that the subsystem developers use every day to
> test their own code. IOWs, in most cases "tester" and the "reviewer"
> roles are performed by the same people.

Again, you are limiting you supply of reviewers with this requirement.

> 
> > I find the reviewers of my code to be the worse testers. That's because
> > those that I ask to review my code know what it's suppose to do, and
> > those are the people that are not going to stumble over bugs. It's the
> > people that have no idea how your code works that will trigger the most
> > bugs in testing it. My best testers would be my worse reviewers.
> 
> "Reviewers are the worst testers".
> 
> Yet you accept the code they write as sufficiently well tested for
> merging? :/

Heh, that's why I have a full test suite. Yes, I run my tests on every
single patch (to make sure it's fully bisectable, this is why I wrote
ktest.pl).

And yes, I find bugs and then send the patches back to be fixed. I never
blindly accept anyone's patches and just merge it.

> 
> > What do you require as a test anyway? I could boot your patches, but
> > since I don't have an XFS filesystem, I doubt that would be much use
> > for you.
> 
> I don't want you to review XFS code - you have no domain specific
> knowledge nor a test environment for XFS changes. IOWs, you meet
> none of the requirements to give a "reviewed-by" for an XFS change,
> and so to say you reviewed a change makes a mockery of the
> expectations outlines in the SubmittingPatches guidelines.

Actually, I would be able to review tracing changes in XFS. I've given
tags like "Revieved-by: Steven Rostedt <rostedt@goodmis.org> # for the
tracing part". before.

I may not test them. I may compile it, but not boot it. I understand
tracing enough to know what will work and what wont. When I give
reviews for other archs, I seldom even compile their code.


> 
> Similarly, I would expect any other maintainer to give me the same
> "go read the guidelines - you know better than that" line if I did
> the same thing for a patch that I clearly don't have a clue about or
> are able to test.
> 
> Reviewed-by only has value when it is backed by process and domain
> specific knowledge. If the person giving that tag doesn't have
> either of these, then it's worthless and they need to be taught what
> the correct thing to do is. Most people (even projects) don't learn
> proper software engineering processes until after they have been at
> the pointy end of a pile of crap at least once. :/

This last paragraph I totally agree with. There's a few people that I
trust very much so for a review. I don't expect them to test my code,
but they are usually good enough to see something that may break under
certain conditions. I don't add any review-by tags from anyone I don't
already have a working relationship with and trust their judgment.

I'm not saying that you can't have your own meaning of Reviewed-by. You
are in charge of a filesystem, and to me, that's one of the most
crucial parts of the kernel, as a corrupt filesystem can lead to huge
loss of data.

What I'm saying is that to most, Reviewed-by means just that. The patch
was reviewed. I think the person adding their reviewed-by tag is
placing their reputation on the line. I know I am every time I add it.
That's why I give a lot more "Acked-by" than "Reviewed-by". Those acks
are me saying "I skimmed the patch, and there's nothing in there that
bothers me". I does not mean that I looked over every change in detail.

-- Steve
