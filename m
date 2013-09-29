Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab3I2UX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:23:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56936 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab3I2UXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:23:53 -0400
Date: Sun, 29 Sep 2013 13:23:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 08/11] rcu: Micro-optimize
 rcu_cpu_has_callbacks()
Message-ID: <20130929202342.GE19582@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1380072561-31134-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <524250A2.3050502@asianux.com>
 <20130925201640.GZ9093@linux.vnet.ibm.com>
 <5243A2A3.1050402@asianux.com>
 <20130926183329.GL9093@linux.vnet.ibm.com>
 <5244ED9D.5010105@asianux.com>
 <5247AB94.4080407@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5247AB94.4080407@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092920-5806-0000-0000-000022E49F8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 12:24:52PM +0800, Chen Gang wrote:
> On 09/27/2013 10:29 AM, Chen Gang wrote:
> > On 09/27/2013 02:33 AM, Paul E. McKenney wrote:
> >> On Thu, Sep 26, 2013 at 10:57:39AM +0800, Chen Gang wrote:
> >>> On 09/26/2013 04:16 AM, Paul E. McKenney wrote:
> >>>> On Wed, Sep 25, 2013 at 10:55:30AM +0800, Chen Gang wrote:
> >>>>>
> >>>>> Thank you for your whole work, firstly  :-).
> >>>>>
> >>>>> And your suggestion about testing (in our discussion) is also valuable
> >>>>> to me.
> >>>>>
> >>>>> I need start LTP in q4. After referenced your suggestion, my first step
> >>>>> for using/learning LTP is not mainly for finding kernel issues, but for
> >>>>> testing kernel (to improve my kernel testing efficiency).
> >>>>>
> >>>>> When I want to find issues by reading code, I will consider about LTP
> >>>>> too (I will try to find issues which can be tested by LTP).
> >>>>
> >>>> Doing more testing will be good!  You will probably need more tests
> >>>> than just LTP, but you must of course start somewhere.
> >>>
> >>> Give more testing is good, but also mean more time resources cost. If
> >>> spend the 'cost', also need get additional 'contributions' (not only
> >>> prove an issue), or the 'efficiency' can not be 'acceptable'.
> >>>
> >>> When "I need more tests than just LTP", firstly I need perform this
> >>> test, and then, also try to send "test case" to LTP (I guess, these
> >>> kinds of mails are welcomed by LTP).
> >>>
> >>> And LTP is also a way to find kernel issues, although I will not mainly
> >>> depend on it now (but maybe in future), it is better to familiar with it
> >>> step by step.
> >>>
> >>> LTP (Linux Test Project) is one of main kernel mad user at downstream.
> >>> Tool chain (GCC/Binutils) is one of kernel main mad tools at upstream.
> >>> If we face to the whole kernel, suggest to use them. ;-)
> >>
> >> Yep, starting with just LTP is OK.  But if by this time next year you
> >> really should be using more than just LTP.
> >>
> 
> What I have done is trying to fully use other members contributions, not trying to instead of them.
> 
> 
> And the reason why I want/try to 'open' my 'ideas' to public:
> 
>   get more suggestions, and completions from other members.
> 
>   share my ideas, it can let other members provide more contributions (e.g. I am glad, if find other members also try 'allmodconfig' on all architectures).
> 
>   If some members replicate me, I will save my current time resources and devote them to another things (which also based on other members contributions).
> 
> 
> In my opinion:
> 
>   "Open and Share" are both important and urgent to everyone, although it may not be noticed directly. Like "Air and Water" which God have blessed to everyone.

In a general sense, of course.

In many specific cases, effective sharing can require quite a bit of
preparation.  For but one example, in Dipankar's and my case, it took
about two years of work (mostly Dipankar's work) to get the initial
implementation of RCU accepted into the Linux kernel.

In your case, you can invest an average of three days per accepted
patch if you are to achieve your goal of ten patches accepted per month
(if I remember correctly).  Of course, not every patch will be accepted,
which reduces your per-patch time.  For example, if 50% of your patches
are accepted, you can invest an average of about 1.5 days per patch.

Of course, investing in learning about test frameworks or specific
kernel subsystems further reduces your time available per patch.

But if you don't invest in your learning, you will be limited in what
you can effectively contribute.  This might be OK, for all I know.
After all, in the 15 million lines of Linux kernel code, there is
probably a very large number of point-problems waiting to be fixed.

But suppose that you run out of easily found point problems?  Or that
you want to do something more wide-ranging than fixes for point problems?
What can you do?

Here are a few options.  If you think more about it, I am sure that you
can come up with others.

1.	Put the ten-patches-per-month quota aside for a month (or two or
	three or whatever is required and appropriate).  Spend this time
	studying a given kernel subsystem or a given test framework.
	(Which kernel subsystem?  The best candidates would be those
	having bugs but no active maintainer, but which you have the
	hardware needed to adequately test.)

2.	Add a review and/or test component to your monthly quota, so
	that a given patch could be substituted for by some number of
	Reviewed-by or Tested-by flags.  Of course, this gives your
	a chicken-and-egg problem because you cannot adequately review
	or test without some understanding of the subsystem in question.
	(At least not efficiently enough to get enough Tested-by or
	Reviewed-by flags.)

3.	Set aside a fixed amount of time each week (or each month) to
	learn.  This time needs to be a contiguous block of at least
	four hours.  If you focus your learning appropriately, you might
	be able to contribute more deeply to whatever you learned about
	over time.

	For whatever it is worth, just staring at code is for most people
	an inefficient way to learn.  Exercising the code using tools
	like ftrace or userspace scaffolding can help speed up the
	learning.

4.	Your idea here...

Your current approach seems to be to submit patches and hope that the
maintainer takes it upon himself or herself to teach you.  Unfortunately,
as you might have noticed, a given maintainer might not have the time
or energy to take on full responsibility for your education.

							Thanx, Paul

