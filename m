Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaFDLLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:11:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaFDLLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:11:34 -0400
Date: Wed, 4 Jun 2014 04:11:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604111133.GA7826@infradead.org>
References: <20140509120733.GA27918@kernel.org>
 <20140509150018.GA26215@infradead.org>
 <20140510040023.GA13788@kernel.org>
 <5388912F.7010609@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5388912F.7010609@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 08:09:51AM -0600, Jens Axboe wrote:
> I have applied this one, but it irks me a little bit since we have
> to touch q->flush_rq->stuff from a potential hot path. I haven't
> thought much about this yet, but it would be a lot better if we
> could fold in the flush tag somehow.

This one also breaks scsi-mq by changing the first parameter of
blk_mq_tag_to_rq.  With host-wide tags we won't have a hardware context
easily available when looking for a request by tag.

