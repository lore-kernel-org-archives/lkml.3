Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3J1Qqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:46:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab3J1Qqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:46:48 -0400
Date: Mon, 28 Oct 2013 09:46:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
Message-ID: <20131028164641.GA1046@infradead.org>
References: <20131026114612.GA8576@infradead.org>
 <20131026153124.GA22227@infradead.org>
 <20131027222914.GG22549@kernel.dk>
 <20131028084821.GA31270@infradead.org>
 <526E90D7.1070604@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E90D7.1070604@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:29:11AM -0600, Jens Axboe wrote:
> It's not that I think the existing patch is THAT bad, it fits in alright
> with the reserved tagging and works regardless of whether a driver uses
> reserved tags or not. And it does have the upside of not requiring
> special checks or logic for this special non-tagged request that using
> the preallocated would might need.

The problem with it is that it will pass a tag number to the low level
driver which it doesn't expect.  In case the tags are used 1:1 as
hardware tags that would lead to nasy bugs.

At vefy least we'd need to mess with ->tag for this special request.

