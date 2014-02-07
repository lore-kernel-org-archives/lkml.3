Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750706AbaBGBSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 20:18:44 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:32830 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBGBSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 20:18:39 -0500
Date: Fri, 7 Feb 2014 09:18:27 +0800
From: Shaohua Li <shli@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140207011827.GA4735@kernel.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130132630.GB6031@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 05:26:30AM -0800, Christoph Hellwig wrote:
> Witch to using a preallocated flush_rq for blk-mq similar to what's done
> with the old request path.  This allows us to set up the request properly
> with a tag from the actually allowed range and ->rq_disk as needed by
> some drivers.  To make life easier we also switch to dynamic allocation
> of ->flush_rq for the old path.
> 
> This effectively reverts most of
> 
>     "blk-mq: fix for flush deadlock"
> 
> and
> 
>     "blk-mq: Don't reserve a tag for flush request"

Reusing the tag for flush request is considered before. The problem is driver
need get a request from a tag, reusing tag breaks this. The possible solution
is we provide a blk_mq_tag_to_request, and force driver uses it. And in this
function, if tag equals to flush_rq tag, we return flush_request.

Thanks,
Shaohua
