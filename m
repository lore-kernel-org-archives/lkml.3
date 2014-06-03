Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaFCSIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:08:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41033 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaFCSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:08:14 -0400
Message-ID: <538E0E7D.2080301@infradead.org>
Date: Tue, 03 Jun 2014 11:05:49 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Dave Chinner <david@fromorbit.com>
CC: josh@joshtriplett.org, Joe Perches <joe@perches.com>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
References: <1401734669.7323.20.camel@joe-AO725>	<20140602145020.400d4e0c@gandalf.local.home>	<20140602185504.GA13569@cloud>	<1401735917.7323.23.camel@joe-AO725>	<20140602190951.GA13648@cloud>	<1401736666.7323.25.camel@joe-AO725>	<20140602231949.GV14410@dastard>	<20140602235915.GB14801@cloud>	<20140603011125.GW14410@dastard>	<20140602213045.26219ddb@gandalf.local.home>	<20140603071654.GC14410@dastard> <20140603134347.6e39f946@gandalf.local.home>
In-Reply-To: <20140603134347.6e39f946@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 10:43 AM, Steven Rostedt wrote:
> On Tue, 3 Jun 2014 17:16:54 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> 
>>>> But you can't say that is it both free of techical and known
>>>> issues without both reading the code and testing it (Reviewed-by).
>>>
>>> I disagree. Testing only tests what you run. It's useless otherwise.
>>> Most code I review, and find bugs for in that review, will not be
>>> caught by tests unless you ran it on a 1024 CPU box for a week.
>>>
>>> I value looking hard at code much more than booting it and running some
>>> insignificant micro test.
>>
>> Running "insignficant micro tests" is exactly that - insignificant -
>> and it's not a robust code review if that is all that is done.
>> Runing *regression tests*, OTOH....
> 
> I really think you are bending the definition of Reviewed-by. Perhaps
> Regression-tested-by would be more appropriate?

If the XFS community wants to have a stricter or stronger meaning for
Reviewed-by:, I think that's OK, but for the kernel in general, it just
means what SubmittingPatches says, and that does not imply Tested-by:.

>>
>> I know from experience that a "quick" 15 minute run on xfstests on a
>> ramdisk will catch 99% of typical problems a filesystem patch might
>> introduce. Code coverage reporting (done recently by RH QE
>> engineers) tells me that this covers between 50-70% of the
>> filesystem, VFS and MM subsystems (numbers vary with fs being
>> tested), and so that's a pretty good, fast smoke test that I can run
>> on any patch or patchset that is sent for review.
> 
> Testing is fine, but I think you are undervaluing true review. Seems to
> me, all you ask for others to do is to run their test suite on the code
> to give a reviewed-by. I ask for people to look at the logic and spend
> a lot more time on seeing if something strange is there. I found people
> find things that tests usually don't. That's because before I post code
> for review, I usually run it under a lot of tests myself that weeds out
> most of those bugs.

Ack. Review is lots of cogitation.

>> Any significant patch set requires longer to read and digest than a
>> full xfstests run across all my test machines (about 80 minutes for
>> a single mkfs/mount option configuration). So by the time I've
>> actually read the code and commented on it, it's been through a full
>> test cycle and it's pretty clear if there are problems or not..
>>
>> And so when I say "reviewed-by" I'm pretty certain that there aren't
>> any known issues.  Sure, it's not going to catch the "ran it on a
>> 1024 CPU box for a week" type of bug, but that's the repsonsibility
>> of the bug reporter to give you a "tested-by" for that specific
>> problem.
> 
> But a good review *can* catch a bug that would trigger on a 1024 CPU
> box! Really, I've had people point things out that I said, oh! but that
> would be a really hard race to get to. And then go and fix it.
> Sometimes, people will find things that have been broken for years in a
> review of a patch that touches code around the broken part.
> 
> 
>>
>> And really, that points out *exactly* the how "reviewed-by" is a far
>> more onerous than "tested-by". Tested-by only means the patch fixes
>> the *specific problem* that was reported.  Reviewed-by means that,
>> as far as the reviewer can determine, it doesn't cause regressions
>> or other problems. It may or may not imply "tested-by" depending on
>> the nature of the bug being fixed, but it certainly implies "no
>> obvious regressions".  They are two very different meanings, and
>> reviewed-by has a much, much wider scope than "tested-by".
> 
> I don't see reviewed-by as a wider scope than tested-by, I seem them
> under two completely different scopes.
> 
> To me, a reviewed-by is someone spent time agonizing over every single
> change, and how that change affects the code. I remember spending a
> full week on a couple of patches for RCU that Paul submitted a while
> ago. I may have run the code, but there's really no test I have that
> would trigger the changes. I went back and forth with Paul and we found
> a few minor issues and when it was done, I gave my Reviewed-by for it.
> I was exhausted, but I learned a lot. I really did understand how that
> code worked. Unfortunately, I forgot everything I learned since then ;-)
> 
> 
>>
>>>> And, yes, this is the definition we've been using for "reviewed-by"
>>>> for XFS code since, well, years before the "reviewed-by" tag even
>>>> existed...
>>>
>>> Fine, just like all else. That is up to the maintainer to decide. You
>>> may require people to run and test it as their review, but I require
>>> that people understand the code I write and look for those flaws that
>>> 99% of tests wont catch.
>>>
>>> I run lots of specific tests on the code I write, I don't expect those
>>> that review my code to do the same. In fact that's never what I even
>>> ask for when I ask someone to review my code. Note, I do ask for
>>> testers when I want people to test it, but those are not the same
>>> people that review my code.
>>
>> Very few subsystems have dedicated testers and hence rely on the
>> test environments that the subsystem developers use every day to
>> test their own code. IOWs, in most cases "tester" and the "reviewer"
>> roles are performed by the same people.
> 
> Again, you are limiting you supply of reviewers with this requirement.
> 
>>
>>> I find the reviewers of my code to be the worse testers. That's because
>>> those that I ask to review my code know what it's suppose to do, and
>>> those are the people that are not going to stumble over bugs. It's the
>>> people that have no idea how your code works that will trigger the most
>>> bugs in testing it. My best testers would be my worse reviewers.

> I'm not saying that you can't have your own meaning of Reviewed-by. You
> are in charge of a filesystem, and to me, that's one of the most
> crucial parts of the kernel, as a corrupt filesystem can lead to huge
> loss of data.
> 
> What I'm saying is that to most, Reviewed-by means just that. The patch
> was reviewed. I think the person adding their reviewed-by tag is
> placing their reputation on the line. I know I am every time I add it.
> That's why I give a lot more "Acked-by" than "Reviewed-by". Those acks
> are me saying "I skimmed the patch, and there's nothing in there that
> bothers me". I does not mean that I looked over every change in detail.

Agreed.

-- 
~Randy
