Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaKCLyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:54:52 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39532 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaKCLys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:54:48 -0500
MIME-Version: 1.0
In-Reply-To: <20141103101039.GA10128@lst.de>
References: <1415003008-16683-1-git-send-email-hch@lst.de>
	<1415003008-16683-3-git-send-email-hch@lst.de>
	<CACVXFVMrW-GSa1YMuvGx=vvxxP2ePwxvTAKzdyv=ZYh6yf+Z5g@mail.gmail.com>
	<20141103101039.GA10128@lst.de>
Date: Mon, 3 Nov 2014 19:54:48 +0800
Message-ID: <CACVXFVMrj_pnYYKzv7zBqQQFiKoE+gVjhNB6evqGUk7wic-i-Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] blk-mq: allow direct dispatch to a driver specific workqueue
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Richard Weinberger <richard@nod.at>,
        ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 6:10 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Nov 03, 2014 at 04:40:47PM +0800, Ming Lei wrote:
>> The above two aren't enough because the big problem is that
>> drivers need a per-request work structure instead of 'hctx->run_work',
>> otherwise there are at most NR_CPUS concurrent submissions.
>>
>> So the per-request work structure should be exposed to blk-mq
>> too for the kind of usage, such as .blk_mq_req_work(req) callback
>> in case of BLK_MQ_F_WORKQUEUE.
>
> Hmm.  Maybe a better option is to just add a flag to never defer
> ->queue_rq to a workqueue and let drivers handle the it?

That should work, but might lose potential merge benefit of defer.


Thanks,
