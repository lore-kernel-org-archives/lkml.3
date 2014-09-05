Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaIEFrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:47:37 -0400
Received: from ozlabs.org ([103.22.144.67]:49470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaIEFrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:47:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
In-Reply-To: <20140903121902.7a9f5a5a@tom-ThinkPad-T410>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com> <20140902162146.GA28741@infradead.org> <5405EF38.60007@kernel.dk> <20140903121902.7a9f5a5a@tom-ThinkPad-T410>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 05 Sep 2014 15:13:49 +0930
Message-ID: <87bnquk4fe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:
> On Tue, 02 Sep 2014 10:24:24 -0600
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 09/02/2014 10:21 AM, Christoph Hellwig wrote:
>> > Btw, one thing we should reconsider is where we set
>> > QUEUE_FLAG_NO_SG_MERGE.  At least for virtio-blk it seems to me that
>> > doing the S/G merge should be a lot cheaper than fanning out into the
>> > indirect descriptors.
>
> Indirect is always considered first no matter SG merge is off or on,
> at least from current virtio-blk implementation.
>
> But it is a good idea to try direct descriptor first, the below simple
> change can improve randread(libaio, O_DIRECT, multi-queue) 7% in my test,
> and 77% transfer starts to use direct descriptor, and almost all transfer
> uses indirect descriptor only in current upstream implementation.

Hi Ming!

        In general, we want to use direct descriptors of we have plenty
of descriptors, and indirect if the ring is going to fill up.  I was
thinking about this just yesterday, in fact.

I've been trying to use EWMA to figure out how full the ring gets, but
so far it's not working well.  I'm still hacking on a solution though,
and your thoughts would be welcome.

Cheers,
Rusty.
