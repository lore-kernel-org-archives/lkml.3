Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaCHRsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 12:48:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaCHRsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 12:48:19 -0500
Message-ID: <531B74B6.4070004@suse.de>
Date: Sat, 08 Mar 2014 20:51:18 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
In-Reply-To: <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 06:33 PM, Mike Snitzer wrote:
> On Sat, Mar 8, 2014 at 10:52 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, Mar 07, 2014 at 03:45:09PM -0500, Jeff Moyer wrote:
>>> Hi, Christoph,
>>>
>>> Did you mean to switch from list_add to list_add_tail?  That seems like
>>> a change that warrants mention.
>>
>> No, that wasn't intentional and should be fixed.  Btw, there was another
>> issue with that commit, in that dm-multipath also needs to allocate
>> ->flush_rq.  I saw a patch from Hannes fixing it in the SuSE tree, and
>> would really love to see him submit that for mainline as well.
>
> Ugh, rq-based DM calls blk_init_allocated_queue.. (ah, looks like best
> to move q->flush_rq allocation from blk_init_queue_node to
> blk_alloc_queue_node?).  Anyway, this all makes sense given the
> crashes we've been dealing with.. we couldn't immediately understand
> how the q->flush_rq would be NULL... grr.  I guess I should've checked
> with you sooner.  I reverted commit 1874198 "blk-mq: rework flush
> sequencing logic" from RHEL7 just yesterday because we were seeing
> crashes on flush with dm-mpath.  But can easily re-apply for RHEL7.1
> (since the request_queue's embedded flush_rq takes up so much space we
> get ample kABI padding).
>
> Not overly proud of the revert, but I deemed easier to revert than
> hunt down the fix given RHEL7 won't actually be providing any blk-mq
> enabled drivers.  That'll change for RHEL7.1.
>
>> Unfortunately SuSE seems to have lots of block and dm fixes and even
>> features that they don't submit upstream.
>
> Yeah, it is certainly disturbing.  No excuse for sitting on fixes like this.
>
> Hannes, _please_ get this dm-mpath flush_rq fix for 3.14 posted ASAP.
> Jens or I will need to get it to Linus next week.
>
Hey, calm down.
I've made the fix just two days ago. And was quite surprised that I've 
been the first hitting that; should've crashed for everybody using 
dm-multipath.
And given the pushback I've gotten recently from patches I would have 
thought that it would work for most users; sure the author would've done 
due diligence on the original patchset ...
Plus I've gotten the reports from S/390, so I put it down to mainframe 
weirdness.

BTW, it not _my_ decision to sit on tons of SUSE specific patches.
I really try to get things upstream. But I cannot do more than sending 
patches upstream, answer patiently any questions, and redo the patchset.
Which I did. Frequently, But, alas, it's up to the maintainer to apply 
them. And I can only ask and hope. The usual story...

I'll be sending the patch soon, Monday at latest.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
