Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaAGPrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:47:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAGPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:47:45 -0500
Date: Tue, 7 Jan 2014 07:47:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3 v2] Use lockless lists for smp_call_function_single()
Message-ID: <20140107154743.GA17462@infradead.org>
References: <1387387418-10005-1-git-send-email-jack@suse.cz>
 <20131219153154.GI30200@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219153154.GI30200@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:31:54AM -0700, Jens Axboe wrote:
> On Wed, Dec 18 2013, Jan Kara wrote:
> >   Hello,
> > 
> >   these three patches make smp_call_function_single() use lockless lists and
> > cleanup abuse of csd.list in the block layer. I have some use for lockless
> > smp_call_function_single() in printk code and that's why I've picked up
> > Christoph's patch. Jens, can you have a look at the series please?
> > 
> > Changes since v1:
> > * Reordered patches to a more sensible order.
> 
> Thanks Jan, I'll throw this into the testing mix for 3.14. Will be a
> little delayed over christmas, with holidays and family visiting.

Did you make any progress?  Btw, I'd love if you could queue up the
patch to use __smp_call_function_single directly in the block layer
for 3.14.  Independent of wether a llist using
__smp_call_function_single is faster than one using the lock we get
down from a list plus llist to just one of them, so I can't see how
that patch will cause an issue.  With all the prep patches already in
it can be queue up independently of Jan's series as well.
