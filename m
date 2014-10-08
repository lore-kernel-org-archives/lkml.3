Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbaJHWiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:38:16 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:57492 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJHWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:38:14 -0400
Message-ID: <5435BCD5.9050306@kernel.dk>
Date: Wed, 08 Oct 2014 16:38:13 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        martin.petersen@oracle.com
Subject: Re: block: fix alignment_offset math that assumes io_min is a power-of-2
References: <1412805952-15316-1-git-send-email-snitzer@redhat.com> <5435B6C0.8020704@kernel.dk> <20141008222841.GA15345@redhat.com>
In-Reply-To: <20141008222841.GA15345@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 04:28 PM, Mike Snitzer wrote:
> On Wed, Oct 08 2014 at  6:12pm -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 10/08/2014 04:05 PM, Mike Snitzer wrote:
>>> The math in both blk_stack_limits() and queue_limit_alignment_offset()
>>> assume that a block device's io_min (aka minimum_io_size) is always a
>>> power-of-2.  Fix the math such that it works for non-power-of-2 io_min.
>>>
>>> This issue (of alignment_offset != 0) became apparent when testing
>>> dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
>>> 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
>>> block size") unlocked the potential for alignment_offset != 0 due to
>>> the dm-thin-pool's io_min possibly being a non-power-of-2.
>>
>> Well that sucks, AND with a mask is considerably cheaper than a MOD...
> 
> Yeah, certainly does suck (please note v2 that I just sent).  The MODs
> shouldn't kill us, these functions aren't called in any real hot path.
> A storm at boot maybe.. or SCSI rescan but...

I had it mixed up with the recent blk_max_size_offset() - you are right,
this is not in a hot path. For that case, I don't really care, it's fine.

Is v2 runtime tested?

-- 
Jens Axboe

