Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaDCEKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 00:10:18 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64314 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaDCEKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 00:10:16 -0400
Message-ID: <533CDF24.9030902@bjorling.me>
Date: Wed, 02 Apr 2014 21:10:12 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] blk-mq: support for shared tags
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de>
In-Reply-To: <20140402074632.GA11359@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 12:46 AM, Christoph Hellwig wrote:
> On Tue, Apr 01, 2014 at 05:16:21PM -0700, Matias Bjorling wrote:
>> Hi Christoph,
>>
>> Can you rebase it on top of 3.14. I have trouble applying it for testing.
> 
> Hi Martin,
> 
> the series is based on top of Jens' for-next branch.  I've also pushed out a
> git tree to the blk-mq-share-tags.2 branch of
> 
> 	git://git.infradead.org/users/hch/scsi.git
> 
> to make testing and reviewing easier.
>

Thanks.

Regarding the tags API. I think the best approach is a struct
blk_mq_tags_reg. That'll make their parameters very visible in the
drivers. I'll send a patch with the change, using the nvme driver as an
example.

>> For nvme, there's need for two separate types of queues. The admin queue
>> (before initializing blk-mq) and the actual hardware queues.
>>
>> Should we allow the driver to get/put tags before initializing blk-mq?
>> Or let drivers implement their own framework?
> 
> What do you mean with initializing blk-mq?  We need to allocate data
> structures for sure, and I don't see much else in terms of initialization
> in blk-mq.
> 

For the nvme driver, there's a single admin queue, which is outside
blk-mq's control, and the X normal queues. Should we allow the shared
tags structure to be used (get/put) for the admin queue, without
initializing blk-mq? or should the drivers simply implement their own
tags for their admin queue?



