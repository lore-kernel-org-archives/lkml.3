Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaLJKVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:21:21 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58164 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaLJKVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:21:19 -0500
Message-ID: <54881E99.3000309@gmail.com>
Date: Wed, 10 Dec 2014 19:21:13 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: snitzer@redhat.com, gregkh@linuxfoundation.org
CC: dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org,
        ejt@redhat.com
Subject: Re: staging: writeboost: Add dm-writeboost
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com> <5484C0E9.3060707@gmail.com> <20141209151253.GA17660@debian> <20141209154859.GC26238@redhat.com>
In-Reply-To: <20141209154859.GC26238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> BUT if you'd still like dm-writeboost to go into staging
> _without_ any of these 5 work items being completed I'll ack it but to
> be very clear: dm-writeboost will not migrate out of staging until these
> items are resolved.
Yes. I will go into staging.
Greg, I will send you a patch with some fixes on TODO.

I agree with the 5 work times to be done for md.
I add some comments below,

>> i) Get this test so it's performance is similar to raw spindle.
Yes.

>> ii) Write good documentation in Documentation/device-mapper/.  eg. How
>>     do I remove a cache?  When should I use dm-writeboost rather than
>>     bcache or dm-cache?
>>
>> iii) Provide an equivalent to the fsck tool to repair a damaged cache.
OK. I took a look at tools for DM-cache.
I will implement something similar.
But please remember, since Writeboost is log-structured fsck tools aren't essentially needed.
On power failure, some logs at the head may be half done and discarding these logs can roll the state back.

>  iv) perform full code review to catch various implementation issues,
>      any style nits, etc.
>  v) explore/implement read caching support (could the lack of read
>     caching be contributing to why the git_extract test is so poor?)
This will be my first work in staging.

- Akira

On 12/10/14 12:48 AM, Mike Snitzer wrote:
> On Tue, Dec 09 2014 at 10:12am -0500,
> Joe Thornber <thornber@redhat.com> wrote:
> 
>> On Mon, Dec 08, 2014 at 06:04:41AM +0900, Akira Hayakawa wrote:
>>> Mike and Alasdair,
>>> I need your ack
>>
>> Hi Akira,
>>
>> I just spent some time playing with your latest code.  On the positive
>> side I am seeing some good performance with the fio tests.  Which is
>> great, we know your design should outperform dm-cache with small
>> random io.
>>
>> However I'm still getting v. poor results with the git-extract test,
>> which clones a linux kernel repo, and then checks out 5 revisions, all
>> with drop_caches in between.
> 
> Thanks for re-evaluating dm-writeboost performance Joe.
> 
>> It's fine to have different benefits of the caching software depending
>> on the load.  But I think the worst case should always be close to the
>> performance of the raw spindle device.
>>
>> If you get the following work items done I will ack to go upstream:
>>
>> i) Get this test so it's performance is similar to raw spindle.
>>
>> ii) Write good documentation in Documentation/device-mapper/.  eg. How
>>     do I remove a cache?  When should I use dm-writeboost rather than
>>     bcache or dm-cache?
>>
>> iii) Provide an equivalent to the fsck tool to repair a damaged cache.
> 
> I agree with this TODO list.  But I'd also add:
>  iv) perform full code review to catch various implementation issues,
>      any style nits, etc.
> 
>  v) explore/implement read caching support (could the lack of read
>     caching be contributing to why the git_extract test is so poor?)
> 
> Item iv) would be a task for myself and anyone else interested in
> getting dm-writeboost ready for inclusion.  Akira, I can start working
> on dm-writeboost code review once I complete review of the dm-dedup
> target (my current priority) -- but realistically that likely won't be
> until the new year.
> 
> BTW, I'm really not seeing much point putting dm-writeboost in staging.
> I'd be happy to take dm-writeboost into drivers/md/ once the above list
> is resolved.  BUT if you'd still like dm-writeboost to go into staging
> _without_ any of these 5 work items being completed I'll ack it but to
> be very clear: dm-writeboost will not migrate out of staging until these
> items are resolved.
> 
> Thanks,
> Mike
> 

