Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaDYHgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:36:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaDYHgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:36:13 -0400
Date: Fri, 25 Apr 2014 00:36:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/1] random vs blk-mq
Message-ID: <20140425073610.GA2143@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A tester found out that we need add_disk_randomness for my scsi-mq
branch.  The patch applied exports add_disk_randomness so that modular
scsi still works with a driver that either uses the low-level I/O
completion routines for the old block layer, or blk-mq, and I'd love
to get this in through Jens' tree which has all the other block work
scsi-mq requires.

But this also brings up an interesting question:  blk-mq currently
does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
simply converting a driver to blk-mq will mean it stops contributing
to the random pool.  Do we need a more fine grained way to control
this, especially for SCSI?
