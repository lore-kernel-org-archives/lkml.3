Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaDCQpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:45:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52622 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaDCQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:45:14 -0400
Message-ID: <533D9017.4070609@bjorling.me>
Date: Thu, 03 Apr 2014 09:45:11 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] blk-mq: support for shared tags
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de> <533CDF24.9030902@bjorling.me> <20140403073631.GA26921@lst.de>
In-Reply-To: <20140403073631.GA26921@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 12:36 AM, Christoph Hellwig wrote:
> On Wed, Apr 02, 2014 at 09:10:12PM -0700, Matias Bjorling wrote:
>> For the nvme driver, there's a single admin queue, which is outside
>> blk-mq's control, and the X normal queues. Should we allow the shared
>> tags structure to be used (get/put) for the admin queue, without
>> initializing blk-mq? or should the drivers simply implement their own
>> tags for their admin queue?
> 
> I'd still create a request_queue for the internal queue, just not register
> a block device for it.  For example SCSI sets up queues for each LUN
> found, but only a subset actually is exposed as a block device.
> 

Ok. That is good enough for now. A little heavy on the overhead side, if
only the tag logic is needed.

What about the following suggestions for shared tags:

1. Rename it from blk_mq_shared_tags to blk_mq_tag_group. A driver can
have several tag groups that it maintains.
2. Instead of blk_mq_shared_tags structure in blk_mq_reg. Have  function
pointer for getting the tags structure during hctx initialization. This
is interesting for nvme, because it has as set of tags for each hardware
queue it exposes.

Thanks,
Matias
