Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaAXTLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:11:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48025 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaAXTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:11:31 -0500
Date: Fri, 24 Jan 2014 11:11:29 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipi_redirect vs rq_affinity
Message-ID: <20140124191129.GG7483@kernel.dk>
References: <20140124132234.GA8553@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124132234.GA8553@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24 2014, Christoph Hellwig wrote:
> Hi Jens,
> 
> it seems like blk-mq uses the ipi_redirect attribute in pretty much the
> same way as the old blk-softirq code used the rq_affinity one, except
> that the old code has an additional option to direct into any core in
> the current package.
> 
> Is there any good reason to not reuse the old name and semantics?

It is pretty much the same. I don't like the semantics of the old one,
where it's 0/1/2 for off/on/different-on, though. Seems like now would
be a good time to clean it up.

-- 
Jens Axboe

