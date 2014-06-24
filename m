Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaFXATl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:19:41 -0400
Received: from mail.phunq.net ([184.71.0.62]:49889 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaFXATj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:19:39 -0400
From: Daniel Phillips <daniel@phunq.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Mon, 23 Jun 2014 17:19:28 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <82382fd8-ba91-4e32-899e-53210c7678f6@phunq.net>
In-Reply-To: <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 21, 2014 12:29:01 PM PDT, James Bottomley wrote:
> On Thu, 2014-06-19 at 14:58 -0700, Daniel Phillips wrote:
>> On Thursday, June 19, 2014 2:26:48 AM PDT, Lukáš Czerner wrote:
>  ...
>
> the concern has always been how page forking interacted with 
> writeback.

More accurately, that is just one of several concerns that Tux3
necessarily addresses in order to benefit from this powerful
optimization. We are pleased that the details continue to be of
general interest.

>> Direct IO is a spurious issue. To recap: direct IO does 
>> notintroduce any new page forking issues. All of the page forking
>> issues already exist with normal buffered IO and mmap. We have 
>> little interest and scant available time for heading off on a 
>> tangent to implement direct IO at this point just as a 
>> precondition for merging.
>  ...
>
> The specific concern is that page forking cannot be made to work
> with direct io. Asserting that it doesn't cause any additional
> problems isn't an answer to that concern. 

Yes it is. We are satisfied that direct IO introduces no new issues
with page forking. If you are concerned about a specific issue then 
the onus is on you to specify it.

> Direct IO isn't actually a huge issue for most filesystems (I mean
> even vfat has it).

You might consider asking Hirofumi about that (VFAT maintainer).

> ...The fact that you think it is such a huge deal...

(Surely you could have found a less disparaging way to express
yourself...)

> ...to implement for tux3 tends to lend credence to this viewpoint.

It is purely a matter of concentrating on what is actually 
important, as opposed to imagined or manufactured. We do not wish 
to spend time on direct IO at this point in time. If you have 
identified a specific issue then please raise it.

For the record, there is a genuine reason why direct IO requires
extra work for Tux3, which has nothing to do with page forking. 
Tux3 has an asynchronous backend, unlike any other local Linux 
filesystem (but like Matt Dillon's Hammer, from which we took 
inspiration). Direct IO thus requires implementing a new 
synchronization mechanism to allow frontend direct IO to use the 
backend allocation and writeback mechanisms, because direct IO is 
synchronous. There is nothing new, magical or particularly 
challenging about that, it is just time consuming work that we do 
not intend to do right now because other more important things need 
to be done.

In the fullness of time, Tux3 will have direct IO just like VFAT,
however that work is a good candidate for post-merge development. 
For example, it could be a good ramp-up project for a new team 
member or a student looking to make their mark on the kernel world.

The bottom line is that direct IO has nothing to do with compiling
the kernel or operating a cell phone efficiently, so it is not 
interesting to us right now. It will become more interesting when 
Tux3 is ready to scale to servers running Oracle and the like.

> The point is that if page forking won't work with direct IO at
> all, then it's a broken design and there's no point merging it.

You can rest assured that direct IO will work with page forking,
given that buffered IO does. We are now discussing details of how 
to make core Linux a more hospitable environment for page forking, 
not whether page forking can be made to work at all, a question that 
was settled by example some time ago.

>> On the other hand, page forking itself has a number of
>> interesting issues. Hirofumi is currently preparing a set of 
>> core kernel patches for review. These patches explicitly do 
>> not attempt to package page forking up into a nice and easy 
>> API that other filesystems could patch in tomorrow. That would 
>> be an unreasonable research burden on our small development 
>> team. 
>  ...
>
> OK, can we take a step back and ask why you're so keen to push
> this into the tree?

If you mean, why are we keen to merge Tux3, I should not need to
explain that to you.

If you mean, why are we keen to push page forking per se into
mainline, then the answer is, we are by no means keen to push page 
forking into core kernel. Rather, that request comes from other 
filesystem developers who recognize it as a plausible way to avoid 
the pain of stable pages.

Based on our experience, page forking is properly implemented within
the filesystem, not core kernel, and we are keen only to push the 
requisite hooks into core. If somebody disagrees and feels the need 
to prove their point by implementing page forking entirely in core, 
then they should post patches and we will be the first to applaud.

> The usual reason is ease of maintenance because in-tree
> filesystems get updated as the vfs and mm APIs change.  However,
> the reciprocal side of that is using standard VFS and MM APIs to 
> make this update and maintenance easy.  The reason no-one wants
> an in-tree filesystem that implements its own writeback by 
> hacking into the current writeback system is that it's a huge 
> maintenance burden.

Every filesystem is a maintenance burden. Core kernel simply must
provide the mechanisms that are required to make the kernel a good 
place for filesystems to exist. The fact that some ancient core 
hackery needs to be tweaked to better accommodate the requirements 
of a modern filesystem is not unusual in any way. Essentially, that 
is the entire story of Linux kernel development.

> Every time writeback gets tweaked, tux3 will break meaning either 
> we double the burden on people updating writeback (to try to 
> figure out how to replicate the change in tux3) or we just accept 
> that tux3 gets broken.

No. Tux3 will be less of a burden for writeback maintenance than
other filesystems because it hooks in above the messy writepages 
machinery and therefore is not sensitive to subtle changes in that 
creaky code.

> The former is unacceptable to the filesystem and mm people and the
> latter would mean there's not really much point merging tux3 if we
> just keep breaking it ... it's better to keep it out of tree
> where the breakages can be fixed by people who understand them on 
> their own timescales.

On the face of it you are arguing the case that Tux3 should be 
blocked from merging forever, as should every new filesystem, as 
Pavel succinctly pointed out. That is less than helpful. But if 
your goal is to buttress the public perception that LKML has
become a toxic forum for contributors then you do an admirable
job.

By the way, after reading your polemic an observer might draw the 
conclusion that I am not one of the "filesystem and mm people". When 
did that change?

>>> ...
>> That was already fixed as noted above, and all the relevant
>> changes were already posted as an independent patch set. After
>> that, some developers weighed in with half formed ideas about 
>> how the same thing could be done better, but without concrete 
>> suggestions. There is nothing wrong with half formed ideas, 
>> except when they turn into a way of blocking forward progress
>  ...
>
> Could you post the url to the new series, please, I must have  
> missed it; seeing the patches that implement the API for 
> insertion into the writeback code would certainly help frame
> this discussion.

We think that our most recently posted patch is the best approach 
at this time. Which is to say that it relies on exactly the 
existing writeback scheduling heuristics. We think that Dave Chinner 
and others are wrong to advocate experimental development of a new 
writeback mechanism at this juncture while the current scheme 
already works perfectly well for Tux3, either with our writeback 
hack or with the new hook.

We further suggest that the new hook is easy to understand and
imposes insignificant new maintenance burden. In any case we will be 
happy to assume whatever maintenance burden might arise. Obviously, 
that is entirely academic while we are the only user.

>> It is worth noting that we (the kernel community) have been
>> thrashing away at the writeback problem for more than twenty 
>> years, and the current solution still leaves much to be 
>> desired. It is unfair to expect us, the Tux3 team, to fix that 
>> mess in a week or two, just to merge our filesystem. We prefer 
>> to adapt the existing infrastructure for now, as expressed in 
>> the currently proposed patch set. With that, we allow core to 
>> mark our inodes dirty just as it has always done, and we 
>> continue to use the usual inode writeback lists for writeback
>> scheduling, which work just fine.
>
> So that's a misunderstanding of expectations...

I did not misunderstand. It is clear from the context you deleted
that we are being pushed to engineer a new core writeback mechanism 
instead of adapting the existing one.

> ...the actual expectation is that you won't make the writeback
> problem more difficult to tackle.

We do not make the writeback problem more difficult, which is 
obvious from the patch.

> Reimplementing writeback within your code in a way that's hacked
> into the system is fragile and burdensome ... it becomes double 
> the code to maintain ... and tux3 breaks if its not updated.

You are preaching to the converted. As you know, we posted a patch
set that eliminates this particular instance of core duplication. 
Upcoming patches will eliminate the remaining core duplication. It 
is unnecessary to belabor that point further.

Regards,

Daniel

