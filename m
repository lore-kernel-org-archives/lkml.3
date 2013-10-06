Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3JFSPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 14:15:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48656 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3JFSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 14:15:09 -0400
Date: Sun, 6 Oct 2013 12:15:08 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] block: use a separate plug list for blk-mq requests
Message-ID: <20131006181508.GF8252@kernel.dk>
References: <20131006160430.GA5959@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006160430.GA5959@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06 2013, Christoph Hellwig wrote:
> blk_flush_plug_list became a bit of a mess with the introduction of blk-mq,
> so I started looking into separating the blk-mq handling from it.  Turns
> out that by doing this we can streamline the blk-mq submission path a lot.
> 
> If we branch out to a blk-mq specific code path early we can do the list sort
> based on the hw ctx instead of the queue and thus avoid the later improvised
> loop to sort again.  In addition we can also remove the hw irq disabling in
> the submission path entirely and collapse a couple of functions in blk-mq.c,
> all at the cost of an additional list_head in struct blk_plug which can go
> away again as soon as we remove old-school request_fn based drivers.

Thanks, I'll take a look at this. The plugging was done mostly hacky
when implementing it, it was meant to be revisited. So definitely room
for improvement there.

-- 
Jens Axboe

