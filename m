Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbaEIPAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:00:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55044 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaEIPAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:00:19 -0400
Date: Fri, 9 May 2014 08:00:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140509150018.GA26215@infradead.org>
References: <20140509120733.GA27918@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509120733.GA27918@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:07:33PM +0800, Shaohua Li wrote:
> 
> flush request is special, which borrows tag from other request. Need a special
> handling to get it from tag.

Thanks, we probably need this one.  But I think you can simply test
REQ_FLUSH_SEQ the passed in request instead of the flush_rq_tag_valid
flag/

