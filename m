Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaCHTak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:30:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaCHTaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:30:39 -0500
Message-ID: <531B8CB1.2010502@suse.de>
Date: Sat, 08 Mar 2014 22:33:37 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        msnitzer <msnitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132620.GA6031@infradead.org> <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com>
In-Reply-To: <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 07:13 PM, Mike Snitzer wrote:
> On Sat, Mar 8, 2014 at 2:51 PM, Hannes Reinecke <hare@suse.de> wrote:
>> On 03/08/2014 06:33 PM, Mike Snitzer wrote:
>>>
>>> On Sat, Mar 8, 2014 at 10:52 AM, Christoph Hellwig <hch@infradead.org>
>>> wrote:
>>>>
>>>> On Fri, Mar 07, 2014 at 03:45:09PM -0500, Jeff Moyer wrote:
>>>>>
>>>>> Hi, Christoph,
>>>>>
>>>>> Did you mean to switch from list_add to list_add_tail?  That seems like
>>>>> a change that warrants mention.
>>>>
>>>>
>>>> No, that wasn't intentional and should be fixed.  Btw, there was another
>>>> issue with that commit, in that dm-multipath also needs to allocate
>>>> ->flush_rq.  I saw a patch from Hannes fixing it in the SuSE tree, and
>>>> would really love to see him submit that for mainline as well.
>>>
>>>
>>> Ugh, rq-based DM calls blk_init_allocated_queue.. (ah, looks like best
>>> to move q->flush_rq allocation from blk_init_queue_node to
>>> blk_alloc_queue_node?).
>
> The above suggestion would work.  But we'd lose the side-effect
> benefit to bio-based DM not needing q->flush_rq allocated at all.
>
> But I'm not immediately seeing a clean way to get that benefit (of not
> allocating for bio-based request_queue) while always allocating it for
> request-based queues.
>
> Actually, how about moving the flush_rq allocation to
> blk_init_allocated_queue(), it'd accomplish both.. what do others
> think of that?
>
>>>> Unfortunately SuSE seems to have lots of block and dm fixes and even
>>>> features that they don't submit upstream.
>>>
>>>
>>> Yeah, it is certainly disturbing.  No excuse for sitting on fixes like
>>> this.
>>>
>>> Hannes, _please_ get this dm-mpath flush_rq fix for 3.14 posted ASAP.
>>> Jens or I will need to get it to Linus next week.
>>>
>> Hey, calm down.
>
> I'm calm.. was just a bit frustrated.  But this isn't a big deal.
> I'll make an effort to reach out to relevant people sooner when
> similar stuff is reported against recently upstreamed code.  Would be
> cool if you did the same.  I can relate to needing to have the distro
> vendor hat on (first needing to determine/answer "is this issue
> specific to our hacked distro kernel?", etc).
>
The patch I made wasn't in the context of 'recently upstreamed code', it 
was due to a backport Jan Kara did for our next distro kernels (3.12-based).
I then made a fix just by code inspection, which _looked_ as if should 
work, and the asked the reporter to test.
I figured that the same issue would be upstream, too, that's right.
But as of now I'm still waiting for feedback on that patch.

I was about to test the patch next week and check for upstream 
application. But surely _NOT_ before I've got any proof that the patch 
fixes the issue.

Due diligence and all that.

I've just applied the code to our kernel tree because it
a) looks as if it would fix the issue
and
b) we're still in beta testing, so having the patch in-kernel makes 
thing easier for testing.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
