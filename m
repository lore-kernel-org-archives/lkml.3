Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbaCSIsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:48:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58924 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501AbaCSIss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140319075428.GA25529@infradead.org>
References: <20140317131827.793657833@bombadil.infradead.org>
	<20140317131941.297853893@bombadil.infradead.org>
	<CACVXFVMsFzyiR5gqyGk6jc0pRZP-3CZSvxr+oi36umVWJPjWZw@mail.gmail.com>
	<20140319075428.GA25529@infradead.org>
Date: Wed, 19 Mar 2014 16:48:47 +0800
Message-ID: <CACVXFVMgZUDjCLWOj-D3UfpmuX3hUHDLydc6FQY4qCzUyeupWw@mail.gmail.com>
Subject: Re: [PATCH 3/4] blk-mq: replace blk_mq_init_commands with a
 ->init_request method
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 3:54 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Mar 19, 2014 at 11:08:20AM +0800, Ming Lei wrote:
>> > +               blk_rq_init(q, q->flush_rq);
>> > +               if (reg->cmd_size)
>> > +                       q->flush_rq->special =
>> > +                               blk_mq_rq_to_pdu(q->flush_rq);
>> > +
>> > +               if (reg->ops->init_request(driver_data,
>> > +                               NULL, q->flush_rq, -1))
>> > +                       goto err_flush_rq;
>> > +       }
>>
>> The above looks a bit weird because q->flush_rq is invisible to
>> driver and should always be initialized no matter if driver defines
>> its .init_request callback or not.
>
> You mean the blk_rq_init?  We already do a real initialization before
> actually using it, it's just there to prevent passing a half-initialized
> one to the driver.
>

OK.

Actually it doesn't matter because flush_rq will be reinitialized
before using, not like common request. And driver should only
initialize req->special instead of the request itself, maybe it is
better to document the fact.


Thanks,
-- 
Ming Lei
