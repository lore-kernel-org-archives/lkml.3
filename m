Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3JXJuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:50:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3JXJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:50:11 -0400
Date: Thu, 24 Oct 2013 02:50:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 01/11] Export __smp_call_function_single()
Message-ID: <20131024095010.GA17914@infradead.org>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-2-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-2-git-send-email-axboe@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:25:54AM +0100, Jens Axboe wrote:
> The blk-mq core and the blk-mq null driver uses it.

Can't say I really like exporting it as all users will need a major
ifdef mess.  If at all we'd expose the higher level add to llist and ipi
abstraction that both blk-mq and the null_blk driver use.

For now I'd just suggest removing the NULL_IRQ_SOFTIRQ mode from
null_blk and decouple that from blk-mq itself.  I'll try to cook up such
an abstraction in the meantime.
