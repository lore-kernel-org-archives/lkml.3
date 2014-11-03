Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaKCIS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:18:29 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaKCIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:18:28 -0500
Date: Mon, 3 Nov 2014 00:18:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: axboe@fb.com, dedekind1@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
Message-ID: <20141103081821.GA5261@infradead.org>
References: <1414933255-3795-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414933255-3795-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 02:00:55PM +0100, Richard Weinberger wrote:
> +#define UBIBLOCK_SG_COUNT 64


Can you document why you choose this number? The default nr_request
for the old code would be 128.

Also I'll send a patch ASAP that allows drivers to ensure their
->queue_rq is always called from a driver-specific workqueue, which
should simplify the bui block driver a lot.
