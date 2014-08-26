Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaHZV1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbaHZV1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:27:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>
	<53FCF9DB.6010501@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 26 Aug 2014 17:27:33 -0400
In-Reply-To: <53FCF9DB.6010501@kernel.dk> (Jens Axboe's message of "Tue, 26
	Aug 2014 15:19:23 -0600")
Message-ID: <x49mwar54ca.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 08/26/2014 11:24 AM, Jeff Moyer wrote:
>> Joe Lawrence <joe.lawrence@stratus.com> writes:
>> 
>>> v2->v3: rebase to 3.16-rc2, consider return values from the
>>>         blk_mq_alloc_request leg of the blk_get_request callchain
>>>         (noted by Jeff), noted in the second patch changelog.
>>>
>>> 	blk_mq_queue_enter may return 0 or errno, which
>>>         blk_mq_alloc_request can propogate out via ERR_PTR.
>>> 	__blk_mq_alloc_request doesn't include any blk_queue_dying
>>> 	checks, so I'm assuming that its failures can be attributed
>>>         to -EWOULDBLOCK under !GFP_WAIT conditions.
>>>
>>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>>>         tags.
>>>
>>> Joe Lawrence (2):
>>>   block,scsi: verify return pointer from blk_get_request
>>>   block,scsi: fixup blk_get_request dead queue scenarios
>> 
>> Jens,
>> 
>> Did this patch set fall through the cracks again?
>
> Falling through the cracks implies that I meant to apply it and did not,
> which was not the case. 

Sorry, I was mislead by our earlier conversation on this (mail inline
below).

> But I think we're at the point now where I'm finally comfortable with
> applying it. So, Joe, could you ensure that it applies to 3.17-rc2,
> then I will roll it in to the updates for 3.18.

Joe, you will have one hunk to modify for sure, in scsi_ioctl.c.  A
previous patch added a check for null, but ended up returning the wrong
value (ENOMEM instead of ENODEV).

Cheers,
Jeff

---old mail below---

From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue scenarios
To: Jeff Moyer <jmoyer@redhat.com>, Joe Lawrence <joe.lawrence@stratus.com>
CC: linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 10:11:09 -0600 (8 weeks, 5 days, 5 hours ago)

On 2014-06-26 10:08, Jeff Moyer wrote:
> Joe Lawrence <joe.lawrence@stratus.com> writes:
>
>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>>          tags.
>>
>> Joe Lawrence (2):
>>    block,scsi: verify return pointer from blk_get_request
>>    block,scsi: convert and handle ERR_PTR from blk_get_request
>
> Jens,
>
> Can you pick this series up?  It actually fixes a NULL pointer
> dereference that can happen if (for example) a usb optical drive is
> removed while an application is using it.

Yeah I'll pick it up, opening up the 3.17 branches soon.

-- 
Jens Axboe



