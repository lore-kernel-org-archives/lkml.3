Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBJL0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:26:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaBJL0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:26:49 -0500
Message-Id: <20140210112437.858399303@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 03:24:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] blk-mq: rework I/O completions
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series reworks how the blk-mq core handles I/O completion.  The
prime motivation was that the current code does not work when using
a timeout handler that needs to complete requests after doing error
handling.  A fallout from fixing that by making the completions more
similar to the old request model is that we now can use the remote
IPIs for driver-internal completions as well instead of just the final
completion and thus get rid of duplicate code both in null_blk and
the pending scsi work.
