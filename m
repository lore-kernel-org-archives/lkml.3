Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaDCVrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:47:36 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51992 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbaDCVr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:47:29 -0400
Message-ID: <533DD6EE.8030000@bjorling.me>
Date: Thu, 03 Apr 2014 14:47:26 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] blk-mq: support for shared tags
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de> <533CDF24.9030902@bjorling.me> <20140403073631.GA26921@lst.de> <533D9017.4070609@bjorling.me> <20140403180143.GA23473@lst.de>
In-Reply-To: <20140403180143.GA23473@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 11:01 AM, Christoph Hellwig wrote:
> On Thu, Apr 03, 2014 at 09:45:11AM -0700, Matias Bjorling wrote:
>>> I'd still create a request_queue for the internal queue, just not register
>>> a block device for it.  For example SCSI sets up queues for each LUN
>>> found, but only a subset actually is exposed as a block device.
>>>
>>
>> Ok. That is good enough for now. A little heavy on the overhead side, if
>> only the tag logic is needed.
>>
>> What about the following suggestions for shared tags:
>>
>> 1. Rename it from blk_mq_shared_tags to blk_mq_tag_group. A driver can
>> have several tag groups that it maintains.
> 
> I was going to rename it to tag_set, but tag_group sounds fine to me as well.
>

tag_set is shorter. tag_set it is.

>> 2. Instead of blk_mq_shared_tags structure in blk_mq_reg. Have  function
>> pointer for getting the tags structure during hctx initialization. This
>> is interesting for nvme, because it has as set of tags for each hardware
>> queue it exposes.
> 
> The current code also has an array of blk_mq_tags structures, one for
> each queue.  Do you need a more complicated mapping than that?
> 

No, that's great. Had misinterpreted the arrays, now that I look at it
again. Thanks

> Btw, I was also going to siply split out the tag allocation from the
> queue registration unconditionally.  While this adds a little more
> boilerplate to simple drivers it avoids unconditional code pathes and should
> make the model much easier to understand.  I should have a new version
> of the patches soon.
> 

ack, good idea.

