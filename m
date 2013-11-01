Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3KAPuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:50:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3KAPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:50:34 -0400
Date: Fri, 1 Nov 2013 08:50:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        linux-kernel@vger.kernel.org
Subject: Re: stec skd block driver needs updating for immutable biovec
Message-ID: <20131101155027.GA5665@infradead.org>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
 <20131101154338.GA23501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101154338.GA23501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 11:43:39AM -0400, Mike Snitzer wrote:
> All the bi_sector ones are low hanging fruit, but the conversion for
> skd_preop_sg_list_bio()'s bio_vec code is more involved.
> 
> Kent, any chance you could crank through it?
> 
> If not I can come back to trying to fix this later.. but I'm working
> through a test merge of linux-dm.git's 'for-next' with linux-block.git's
> 'for-next'.

The right thing for 3.13 is to rip out the bio base code path, and
for 3.14 to convert it to blk-mq.
