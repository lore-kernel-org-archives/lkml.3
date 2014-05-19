Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaESPSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:18:30 -0400
Received: from verein.lst.de ([213.95.11.211]:40446 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbaESPS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:18:27 -0400
Date: Mon, 19 May 2014 17:18:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
	flush worker
Message-ID: <20140519151824.GA21762@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:05:50PM +0800, Ming Lei wrote:
> Another simple fix is to disable ipi for flush request, but looks
> this one should be better.

I think the first thing is to bite the bullet and sort out and document
the various unions in struct request for real.

For example the first union has the call_single_data for the blk-mq
completions, while the second one has the ipi_list that is used by
the old blk-softirq code.

If we get this right with a single union that contains a struct for
each phase of the request we might find enough space to keep using
the current way.


