Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3J2T11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:27:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3J2T1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:27:25 -0400
Date: Tue, 29 Oct 2013 12:27:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel: use lockless list for
 smp_call_function_single
Message-ID: <20131029192720.GA24089@infradead.org>
References: <20131024151921.537751910@bombadil.infradead.org>
 <20131024152314.204817634@bombadil.infradead.org>
 <20131029192536.GB9568@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029192536.GB9568@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:25:36PM +0100, Jan Kara wrote:
>   I'm wondering: Who's still using the normal list_head? I was grepping for
> a while and I couldn't find any user. Otherwise the patch looks good to me.

The block/blk-softirq.c code is abusing it in a fairly ugly way.

