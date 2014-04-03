Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaDCSBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:01:49 -0400
Received: from verein.lst.de ([213.95.11.211]:42441 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaDCSBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:01:46 -0400
Date: Thu, 3 Apr 2014 20:01:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matias Bjorling <m@bjorling.me>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] blk-mq: support for shared tags
Message-ID: <20140403180143.GA23473@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de> <533CDF24.9030902@bjorling.me> <20140403073631.GA26921@lst.de> <533D9017.4070609@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D9017.4070609@bjorling.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:45:11AM -0700, Matias Bjorling wrote:
> > I'd still create a request_queue for the internal queue, just not register
> > a block device for it.  For example SCSI sets up queues for each LUN
> > found, but only a subset actually is exposed as a block device.
> > 
> 
> Ok. That is good enough for now. A little heavy on the overhead side, if
> only the tag logic is needed.
> 
> What about the following suggestions for shared tags:
> 
> 1. Rename it from blk_mq_shared_tags to blk_mq_tag_group. A driver can
> have several tag groups that it maintains.

I was going to rename it to tag_set, but tag_group sounds fine to me as well.

> 2. Instead of blk_mq_shared_tags structure in blk_mq_reg. Have  function
> pointer for getting the tags structure during hctx initialization. This
> is interesting for nvme, because it has as set of tags for each hardware
> queue it exposes.

The current code also has an array of blk_mq_tags structures, one for
each queue.  Do you need a more complicated mapping than that?

Btw, I was also going to siply split out the tag allocation from the
queue registration unconditionally.  While this adds a little more
boilerplate to simple drivers it avoids unconditional code pathes and should
make the model much easier to understand.  I should have a new version
of the patches soon.

