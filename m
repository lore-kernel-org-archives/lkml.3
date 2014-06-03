Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaFCBau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:30:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23000 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752610AbaFCBat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:30:49 -0400
Date: Mon, 2 Jun 2014 21:30:45 -0400
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
Message-ID: <20140602213045.26219ddb@gandalf.local.home>
In-Reply-To: <20140603011125.GW14410@dastard>
References: <1401731968.7323.4.camel@joe-AO725>
	<20140602181658.GX22231@linux.vnet.ibm.com>
	<1401734669.7323.20.camel@joe-AO725>
	<20140602145020.400d4e0c@gandalf.local.home>
	<20140602185504.GA13569@cloud>
	<1401735917.7323.23.camel@joe-AO725>
	<20140602190951.GA13648@cloud>
	<1401736666.7323.25.camel@joe-AO725>
	<20140602231949.GV14410@dastard>
	<20140602235915.GB14801@cloud>
	<20140603011125.GW14410@dastard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 11:11:25 +1000
Dave Chinner <david@fromorbit.com> wrote:


> You've ignored the (c).(2) "free of known issues" criteria there.
> You cannot say a patch is free of issues if you haven't applied,
> compiled and tested it.
> 
> > We should not, for instance, prevent someone from providing a
> > Reviewed-by (as opposed to an Acked-by) for a driver whose hardware few
> > people actually have.  There's significant value in code review even
> > without the ability to test.
> 
> I don't disagree with you that there's value in code review, but
> that's not the only part of what "reviewed-by" means.
> 
> You can test that the code is free of known issues without reviewing
> it (i.e. tested-by). You can read the code and note that you can't
> see any technical issues without testing it (Acked-by).

Unless you run every test imaginable on all existing hardware, you are
not stating that it is free of known issues. I say your logic is flawed
right there.

I find that review finds more bugs than testing does.

> 
> But you can't say that is it both free of techical and known
> issues without both reading the code and testing it (Reviewed-by).

I disagree. Testing only tests what you run. It's useless otherwise.
Most code I review, and find bugs for in that review, will not be
caught by tests unless you ran it on a 1024 CPU box for a week.

I value looking hard at code much more than booting it and running some
insignificant micro test.


> 
> > > Anyone using Reviewed-by without having actually applied and tested
> > > the patch is mis-using the tag - they should be using Acked-by: if
> > > all they have done is read the code in their mail program....
> > 
> > Acked-by and Reviewed-by mean two different things (Reviewed-by being a
> > superset of Acked-by), and the difference is not "I've applied and
> > tested this"; that's Tested-by.
> 
> Right, the difference is more than that - Reviewed-by is a
> superset of both Acked-by and Tested-by.

I disagree.

> 
> And, yes, this is the definition we've been using for "reviewed-by"
> for XFS code since, well, years before the "reviewed-by" tag even
> existed...

Fine, just like all else. That is up to the maintainer to decide. You
may require people to run and test it as their review, but I require
that people understand the code I write and look for those flaws that
99% of tests wont catch.

I run lots of specific tests on the code I write, I don't expect those
that review my code to do the same. In fact that's never what I even
ask for when I ask someone to review my code. Note, I do ask for
testers when I want people to test it, but those are not the same
people that review my code.

I find the reviewers of my code to be the worse testers. That's because
those that I ask to review my code know what it's suppose to do, and
those are the people that are not going to stumble over bugs. It's the
people that have no idea how your code works that will trigger the most
bugs in testing it. My best testers would be my worse reviewers.

What do you require as a test anyway? I could boot your patches, but
since I don't have an XFS filesystem, I doubt that would be much use
for you.

-- Steve
