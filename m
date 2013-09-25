Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3IYS1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:27:00 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59184 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3IYS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:26:58 -0400
Date: Wed, 25 Sep 2013 20:26:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130925182654.GB16693@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
 <20130924080347.GH28538@gmail.com>
 <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
 <20130924151847.GB8494@gmail.com>
 <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com>
 <20130924172600.GD10261@gmail.com>
 <000001415604292f-63d4c50d-23e2-43ea-af60-f0e385c71661-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000001415604292f-63d4c50d-23e2-43ea-af60-f0e385c71661-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 24 Sep 2013, Ingo Molnar wrote:
> 
> > > > > >
> > > > > > Your lack of cooperation is getting ridiculous!
> > > > >
> > > > > And this kind of insulting behavior is really discouraging 
> > > > > people to do work on the kernel.
> >
> > You can stop playing the victim card: you are not a newbie anymore by 
> > any definition, you've been hacking the Linux kernel for how long, 10+ 
> > years, writing hundreds of patches? People expect higher quality 
> > series from you and you need to learn to address criticism of your 
> > workflow as well.
> >
> > You won't find a _single_ mail in the last 15+ years of lkml where I 
> > reacted strongly to a newbie being dense or abusive. Newbies can make 
> > all sorts of mistakes, it's part of the learning process - but after 
> > 10 years you are not a newbie anymore...
> 
> This has nothing to do with newbieness but with general communication 
> behavior. I am not a full time kernel developer (nor would I want to be 
> because it seems to cause some sort of cabin fever) and need to take 
> time off my other duties in order to work on these patches. Time is 
> limited.
> 
> And then instead of thanks I get insults sprinkled with some paranoia.

Pointing out your lack of cooperation (such as repeatedly ignoring 
maintainer feedback) is not an "insult" - it's my duty as a maintainer to 
protect other submitters who do their homework and it's also my duty as a 
maintainer to keep crappy patches from entering the kernel. Resisting 
low-quality patches like yours and pointing out patch submission errors 
and inefficiencies is my job.

For example lets just take your latest submission from yesterday to see 
sloppiness in action:

63175   C Sep 24 Christoph Lamet ( 121) ┬─>[pchecks v2 1/2] Subject; percpu: Add raw_cpu_ops
63176   C Sep 24 Christoph Lamet ( 206) └─>[pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
63178   C Sep 24 Christoph Lamet (  14) [pchecks v2 0/2] percpu v2: Implement Preemption checks for __this_cpu operatio

The 0/2 mail arrived before the 1/2 and 2/2 mails, because you did not use 
git-send-email threading options properly to thread them all together...

Furthermore, your first patch's subject line was mangled in a weird way, 
mentioning 'Subject;' twice:

  Subject: [pchecks v2 1/2] Subject; percpu: Add raw_cpu_ops

Patch submissions are expected to have such a coherent format:

63346   T Sep 25 Arnaldo Carvalh (  70) [GIT PULL 0/6] perf/urgent fixes
63347   T Sep 25 Arnaldo Carvalh (  37) ├─>[PATCH 1/6] perf kmem: Make it work again on non NUMA machines
63348   T Sep 25 Arnaldo Carvalh (  31) ├─>[PATCH 2/6] perf trace: Add mmap2 handler
63349   T Sep 25 Arnaldo Carvalh ( 218) ├─>[PATCH 3/6] perf probe: Fix probing symbols with optimization suffix
63350   T Sep 25 Arnaldo Carvalh (  27) ├─>[PATCH 4/6] perf tools: Explicitly add libdl dependency
63351   T Sep 25 Arnaldo Carvalh (  37) ├─>[PATCH 5/6] perf machine: Fix path unpopulated in machine__create_modules()
63352   T Sep 25 Arnaldo Carvalh (  56) └─>[PATCH 6/6] perf symbols: Demangle cloned functions

It's not rocket science - and in fact it takes less time to submit patches 
properly and consistently.

All that can be ignored if the submitter is a newbie who is struggling 
with his first few submissions - but you with 10+ years of experience and 
hundreds of patches track record are held to a higher standard.

Such kind of trivial quality problems does not give me any confidence at 
all to consider your patches for inclusion - which modify the core kernel 
after all. There are tons of part-time developers who get their 
submissions right.

If you have limited time to contribute I'd suggest you work on each 
submission a bit more before sending them, to make sure it has the 
expected quality, to make sure you've addressed all review feedback, etc. 
- this will waste less time of everyone involved and will generally result 
in fewer complaints as well.

Thanks,

	Ingo
