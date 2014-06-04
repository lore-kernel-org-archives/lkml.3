Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaFDO6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:58:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaFDO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:58:05 -0400
Date: Wed, 4 Jun 2014 07:58:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604145803.GA7826@infradead.org>
References: <20140509120733.GA27918@kernel.org>
 <20140509150018.GA26215@infradead.org>
 <20140510040023.GA13788@kernel.org>
 <5388912F.7010609@kernel.dk>
 <20140604111133.GA7826@infradead.org>
 <538F2A11.4060800@kernel.dk>
 <20140604142012.GA20056@infradead.org>
 <538F331F.60101@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F331F.60101@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:54:23AM -0600, Jens Axboe wrote:
> >It's not as simple as the added code wants to get a queue from the
> >hwctx, which we can't get at.  I was planning to look into this, but
> >there are various other regressions in the recent block updates that I
> >need to fix before I can even test a tree with this one reverted.
> 
> Which regressions? Performance or crashes?

Both.  I've tracked down the SCSI boot crash and you'll have a patch for
that soon, still working on bisecting the performance crawl, but I'm
getting close.

> >If you can get to sorting this out soon I'd love you to handle it,
> >otherwise I'll look into it as soon as I can.
> 
> Just took a look at it, but I don't see the problematic path. I'm
> looking at wip-9.

scsi_mq_find_tag only gets the scsi host, which may have multiple
queues.  When called from scsi_find_tag we actually have a scsi device,
so that's not an issue, but when called from scsi_host_find_tag the
driver only provides the host.

