Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaFDPFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:05:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaFDPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:05:09 -0400
Date: Wed, 4 Jun 2014 08:05:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604150508.GA21551@infradead.org>
References: <20140509120733.GA27918@kernel.org>
 <20140509150018.GA26215@infradead.org>
 <20140510040023.GA13788@kernel.org>
 <5388912F.7010609@kernel.dk>
 <20140604111133.GA7826@infradead.org>
 <538F2A11.4060800@kernel.dk>
 <20140604142012.GA20056@infradead.org>
 <538F331F.60101@kernel.dk>
 <20140604145803.GA7826@infradead.org>
 <538F34FB.7050003@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F34FB.7050003@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
> OK strange, there hasn't been that much churn since the last rebase.
> In my for-linus, there's a patch for a single queue crash, but that
> should just hit for the removal case. And then there's the atomic
> schedule patch, but that issue was actually in the code base for
> about a month, so not a new one either.

You're request initializaion optimization doesn't set up req->cmd and
thus causes all BLOCK_PC I/O (including the SCSI LUN scan) to crash and
burn.  The trivial fix is on your way.

The performance regression is caused by "blk-mq: avoid code
duplication", but I don't really understand why yet.

