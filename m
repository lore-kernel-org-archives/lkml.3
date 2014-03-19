Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaCSHya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:54:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaCSHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:54:29 -0400
Date: Wed, 19 Mar 2014 00:54:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] blk-mq: replace blk_mq_init_commands with a
 ->init_request method
Message-ID: <20140319075428.GA25529@infradead.org>
References: <20140317131827.793657833@bombadil.infradead.org>
 <20140317131941.297853893@bombadil.infradead.org>
 <CACVXFVMsFzyiR5gqyGk6jc0pRZP-3CZSvxr+oi36umVWJPjWZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMsFzyiR5gqyGk6jc0pRZP-3CZSvxr+oi36umVWJPjWZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 11:08:20AM +0800, Ming Lei wrote:
> > +               blk_rq_init(q, q->flush_rq);
> > +               if (reg->cmd_size)
> > +                       q->flush_rq->special =
> > +                               blk_mq_rq_to_pdu(q->flush_rq);
> > +
> > +               if (reg->ops->init_request(driver_data,
> > +                               NULL, q->flush_rq, -1))
> > +                       goto err_flush_rq;
> > +       }
> 
> The above looks a bit weird because q->flush_rq is invisible to
> driver and should always be initialized no matter if driver defines
> its .init_request callback or not.

You mean the blk_rq_init?  We already do a real initialization before
actually using it, it's just there to prevent passing a half-initialized
one to the driver.

