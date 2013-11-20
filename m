Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3KTIEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:04:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTIEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:04:44 -0500
Date: Wed, 20 Nov 2013 00:04:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131120080440.GA13147@infradead.org>
References: <20131119080218.GJ11434@dastard>
 <20131119201531.GA4094@kernel.dk>
 <20131119212042.GB4094@kernel.dk>
 <20131119213429.GQ11434@dastard>
 <528BDB97.8090608@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528BDB97.8090608@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:43:51PM -0700, Jens Axboe wrote:
> No, the nr_requests isn't actually relevant in the blk-mq context, the
> driver sets its own depth. For the above, it's 64 normal commands, and 2
> reserved. The reserved would be for a flush, for instance. If someone
> attempts to queue more than the allocated number of requests, it'll stop
> the blk-mq queue and kick things into gear on the virtio side. Then when
> requests complete, we start the queue again.

Btw, any reason we lowerered the queue depth from 128 to 64 in
virtio-blk?

