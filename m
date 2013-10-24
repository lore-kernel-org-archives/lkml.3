Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3JXMud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:50:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3JXMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:50:33 -0400
Date: Thu, 24 Oct 2013 05:50:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 01/11] Export __smp_call_function_single()
Message-ID: <20131024125032.GA21286@infradead.org>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-2-git-send-email-axboe@kernel.dk>
 <20131024095010.GA17914@infradead.org>
 <20131024101653.GV14598@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024101653.GV14598@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:16:53AM +0100, Jens Axboe wrote:
> On Thu, Oct 24 2013, Christoph Hellwig wrote:
> > On Thu, Oct 24, 2013 at 10:25:54AM +0100, Jens Axboe wrote:
> > > The blk-mq core and the blk-mq null driver uses it.
> > 
> > Can't say I really like exporting it as all users will need a major
> > ifdef mess.  If at all we'd expose the higher level add to llist and ipi
> > abstraction that both blk-mq and the null_blk driver use.
> > 
> > For now I'd just suggest removing the NULL_IRQ_SOFTIRQ mode from
> > null_blk and decouple that from blk-mq itself.  I'll try to cook up such
> > an abstraction in the meantime.
> 
> Agree, lets get a proper interface exported for this from kernel/smp.c
> instead. I've killed this patch and the softirq mode in null_blk for
> now.

Turns out the proper interface is __smp_call_function_single as long as
we make sure it's always available.  I've got a series that allows us to
use it directly without the llist wrapping, but it probably won't be
ready for the next merge window.

So I'll take my earlier objection back, instead please add a:

Reviewed-by: Christoph Hellwig <hch@lst.de>
