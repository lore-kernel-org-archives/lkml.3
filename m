Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaIIPij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:38:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaIIPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:38:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140909152028.GA13699@lst.de>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
	<20140909152028.GA13699@lst.de>
Date: Tue, 9 Sep 2014 23:38:32 +0800
Message-ID: <CACVXFVN3tTJGJqcykwBhS6fzRuQd-9kYmFQqKC_39Hdb9=N9GA@mail.gmail.com>
Subject: Re: [PATCH 0/8] block: per-distpatch_queue flush machinery
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 11:20 PM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Ming,
>
> thanks for doing this work!
>
> I've only taken a very cursory look at the series and I like most of it.
>
> But can you explain why you're not simply incrementing the number of
> allocated requests in the blk-mq request allocation code instead of
> allocating the flush request separately in the last patch?

Requests in tag_set may be shared by more than one queues, but flush
rq per hctx can't be shared by request queues at all.

Also it is simple to put it inside the introduce blk_flush_queue.

Thanks,
