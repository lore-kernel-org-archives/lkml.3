Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab3LWQ0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:26:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab3LWQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:26:50 -0500
Date: Mon, 23 Dec 2013 08:26:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] block: null_blk: fix queue leak inside removing
 device
Message-ID: <20131223162650.GC9383@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
 <1387815539-12257-4-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815539-12257-4-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:18:58AM +0800, Ming Lei wrote:
>  	del_gendisk(nullb->disk);
> -	if (queue_mode == NULL_Q_MQ)
> -		blk_mq_free_queue(nullb->q);
> -	else
> -		blk_cleanup_queue(nullb->q);
> +	blk_cleanup_queue(nullb->q);

All exported users of blk_mq_free_queue go away with this change, so
make sure it's not available anymore.  I have to say the one in
blk-sysfs.c also looks suspicious.

