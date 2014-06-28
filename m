Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaF1O3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 10:29:30 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40379 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaF1O33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 10:29:29 -0400
Message-ID: <53AED146.4080205@kernel.dk>
Date: Sat, 28 Jun 2014 08:29:26 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org
Subject: Re: [PATCHSET block/for-next] blk-mq: update freezing
References: <1403104872-22236-1-git-send-email-tj@kernel.org> <53A1BC0E.8040704@kernel.dk> <20140628121314.GD10829@htj.dyndns.org>
In-Reply-To: <20140628121314.GD10829@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-28 06:13, Tejun Heo wrote:
> On Wed, Jun 18, 2014 at 09:19:26AM -0700, Jens Axboe wrote:
>>>   percpu/for-3.17 6fbc07bbe2b5 ("percpu: invoke __verify_pcpu_ptr() from the generic part of accessors and operations")
>>> +[1] [PATCHSET percpu/for-3.17] percpu: implement percpu_ref_reinit()
>>>
>>> and available in the following git branch.
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-mq-percpu_ref
>>>
>>>   block/blk-core.c       |   13 ++++---
>>>   block/blk-mq.c         |   90 ++++++++++++++++---------------------------------
>>>   block/blk-mq.h         |    2 -
>>>   block/blk-sysfs.c      |    2 -
>>>   include/linux/blkdev.h |    4 +-
>>>   5 files changed, 44 insertions(+), 67 deletions(-)
>>
>> Thanks Tejun, this looks pretty good. I was worried the tryget_live() would
>> be too expensive, but that looks not to be the case. I like the cleanups to
>> using a general mechanism. I'll run this through some functional and
>> performance testing.
>
> FYI, the percpu_ref changes needed by this patchset are applied to
> percpu/for-3.17 branch which is stable and can be pulled into the
> block tree.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.17

Great, thanks! Was just mulling over this yesterday. I'll get it pulled 
in as a base.

-- 
Jens Axboe

