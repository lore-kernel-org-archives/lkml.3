Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaHZVT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:19:28 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35650 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaHZVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:19:26 -0400
Message-ID: <53FCF9DB.6010501@kernel.dk>
Date: Tue, 26 Aug 2014 15:19:23 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, Joe Lawrence <joe.lawrence@stratus.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com> <x49egw36u55.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49egw36u55.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 11:24 AM, Jeff Moyer wrote:
> Joe Lawrence <joe.lawrence@stratus.com> writes:
> 
>> v2->v3: rebase to 3.16-rc2, consider return values from the
>>         blk_mq_alloc_request leg of the blk_get_request callchain
>>         (noted by Jeff), noted in the second patch changelog.
>>
>> 	blk_mq_queue_enter may return 0 or errno, which
>>         blk_mq_alloc_request can propogate out via ERR_PTR.
>> 	__blk_mq_alloc_request doesn't include any blk_queue_dying
>> 	checks, so I'm assuming that its failures can be attributed
>>         to -EWOULDBLOCK under !GFP_WAIT conditions.
>>
>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>>         tags.
>>
>> Joe Lawrence (2):
>>   block,scsi: verify return pointer from blk_get_request
>>   block,scsi: fixup blk_get_request dead queue scenarios
> 
> Jens,
> 
> Did this patch set fall through the cracks again?

Falling through the cracks implies that I meant to apply it and did not,
which was not the case. But I think we're at the point now where I'm
finally comfortable with applying it. So, Joe, could you ensure that it
applies to 3.17-rc2, then I will roll it in to the updates for 3.18.

-- 
Jens Axboe

