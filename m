Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBGOTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:19:18 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBGOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:19:16 -0500
Date: Fri, 7 Feb 2014 06:19:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140207141915.GA24176@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <20140207011827.GA4735@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207011827.GA4735@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:18:27AM +0800, Shaohua Li wrote:
> Reusing the tag for flush request is considered before. The problem is driver
> need get a request from a tag, reusing tag breaks this. The possible solution
> is we provide a blk_mq_tag_to_request, and force driver uses it. And in this
> function, if tag equals to flush_rq tag, we return flush_request.

If we want to support tag to request reverse mapping we defintively
need to do this in the core, at which point special casing flush_rq
there is easy.

Which driver needs the reverse mapping? Neither virtio_blk nor null_blk
seem to and I've not seen any other conversions submitted except for the
scsi work.

