Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaIXPHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:07:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49336 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140924102112.GC19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
	<1410786675-7761-9-git-send-email-ming.lei@canonical.com>
	<20140924102112.GC19078@lst.de>
Date: Wed, 24 Sep 2014 22:56:01 +0800
Message-ID: <CACVXFVNs5LF0UNqiugO3gwSCvm3muXg1h4W=7aMnZNy2Zkhe1g@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] block: introduce 'blk_mq_ctx' parameter to blk_get_flush_queue
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:21 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Sep 15, 2014 at 09:11:12PM +0800, Ming Lei wrote:
>> This patch adds 'blk_mq_ctx' parameter to blk_get_flush_queue(),
>> so that this function can find the corresponding blk_flush_queue
>> bound with current mq context since the flush queue will become
>> per hw-queue.
>>
>> For legacy queue, the parameter can be simply 'NULL'.
>>
>> For multiqueue case, the parameter should be set as the context
>> from which the related request is originated. With this context
>> info, the hw queue and related flush queue can be found easily.
>
> I think this should be merged into the patch introducing
> blk_get_flush_queue.

The 'blk_mq_ctx' parameter should be treated carefully for
the function, that is why the patch isn't merged to previous
one, and patch 5 is big enough.

Again, small patch is easier for review, and we should try to
do one thing in one patch.

Thanks,
