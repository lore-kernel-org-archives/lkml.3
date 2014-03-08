Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaCHPwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:52:46 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHPwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:52:44 -0500
Date: Sat, 8 Mar 2014 07:52:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        linux-kernel@vger.kernel.org, msnitzer@redhat.com,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140308155240.GA32297@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 03:45:09PM -0500, Jeff Moyer wrote:
> Hi, Christoph,
> 
> Did you mean to switch from list_add to list_add_tail?  That seems like
> a change that warrants mention.

No, that wasn't intentional and should be fixed.  Btw, there was another
issue with that commit, in that dm-multipath also needs to allocate
->flush_rq.  I saw a patch from Hannes fixing it in the SuSE tree, and
would really love to see him submit that for mainline as well.

Unfortunately SuSE seems to have lots of block and dm fixes and even
features that they don't submit upstream.

