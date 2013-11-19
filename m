Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3KSQJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:09:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3KSQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:09:51 -0500
Date: Tue, 19 Nov 2013 08:09:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119160949.GA24191@infradead.org>
References: <20131119080218.GJ11434@dastard>
 <20131119103635.GA9223@infradead.org>
 <20131119160509.GB21343@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119160509.GB21343@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:05:09AM -0700, Jens Axboe wrote:
> I have queued up the below.

I don't think that will work.  We only set QUEUE_FLAG_IO_STAT in
blk_init_allocated_queue, which doesn't get called from
blk_mq_init_queue.  That being said I really don't understand why we
need to have the QUEUE_FLAG_IO_STAT flag at all.

