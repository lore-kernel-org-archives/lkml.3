Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3JXKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:16:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3JXKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:16:57 -0400
Date: Thu, 24 Oct 2013 11:16:53 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 01/11] Export __smp_call_function_single()
Message-ID: <20131024101653.GV14598@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-2-git-send-email-axboe@kernel.dk>
 <20131024095010.GA17914@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024095010.GA17914@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24 2013, Christoph Hellwig wrote:
> On Thu, Oct 24, 2013 at 10:25:54AM +0100, Jens Axboe wrote:
> > The blk-mq core and the blk-mq null driver uses it.
> 
> Can't say I really like exporting it as all users will need a major
> ifdef mess.  If at all we'd expose the higher level add to llist and ipi
> abstraction that both blk-mq and the null_blk driver use.
> 
> For now I'd just suggest removing the NULL_IRQ_SOFTIRQ mode from
> null_blk and decouple that from blk-mq itself.  I'll try to cook up such
> an abstraction in the meantime.

Agree, lets get a proper interface exported for this from kernel/smp.c
instead. I've killed this patch and the softirq mode in null_blk for
now.

-- 
Jens Axboe

