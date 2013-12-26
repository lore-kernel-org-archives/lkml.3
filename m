Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3LZKxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:53:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3LZKxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:53:21 -0500
Date: Thu, 26 Dec 2013 02:53:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] block: blk-mq: support draining mq queue
Message-ID: <20131226105316.GA16268@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
 <1387815539-12257-2-git-send-email-tom.leiming@gmail.com>
 <20131223162442.GA9383@infradead.org>
 <CACVXFVN=sxHxUY_0c9xWKw3nXhj60UeSjvFTHs52zHNEAg__4w@mail.gmail.com>
 <20131226094518.GA22894@infradead.org>
 <CACVXFVOOEGPt7JXKmk=dTz3H6TgadBoOx1_D_hksi6J1L7OjYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOOEGPt7JXKmk=dTz3H6TgadBoOx1_D_hksi6J1L7OjYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 06:12:30PM +0800, Ming Lei wrote:
> IMO, if one block API can serve for both non-MQ and MQ cases, why do
> we have to split it into blk_foo() and blk_mq_foo()?

To make the usage obvious and to allow killing the old code more
easily.  Looking back I have to see I'd actually prefer it the MQ
code simply used different data structures.

> 
> IMO it is very possible that parallel path might keep for a while, and at least
> the current scsi-mq patches do so.

That might be okay for the current prototype, but there's not point in
merging it if it can't replace the old legacy request code.  And yes,
this will require a lot more work.

