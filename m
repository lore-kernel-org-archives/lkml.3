Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaJSPLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:11:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:40610 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJSPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:11:33 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: fix blk-mq for SPI hosts
Date: Sun, 19 Oct 2014 17:13:56 +0200
Message-Id: <1413731638-28305-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the assumption that we can treat all blk-mq requests as tagged.  For
traditional SCSI that's wrong, as being tagged has a very explicit meaning
on the wire.

This is a little bit different from the version Meelis tested earlier, but
the concept is the same.  I didn't want to add a Tested-by tag as it's
different enough, though.

