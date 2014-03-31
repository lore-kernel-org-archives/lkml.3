Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaCaOoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:44:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:38595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaCaOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:44:08 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC] blk-mq: support for shared tags
Date: Mon, 31 Mar 2014 16:46:11 +0200
Message-Id: <1396277175-21382-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for sharing tags (and thus requests) between
multiple request_queues.  We'll need this for SCSI, and I think Martin
also wants something similar for nvme.

Besides the mess with request contructors/destructors the major RFC here
is how the blk_mq_alloc_shared_tags API should look like.  For now I've
been lazy and reused struct blk_mq_reg, but that feels a bit cumbersome.
Either a separate blk_mq_tags_reg or just passing the few arguments directly
would work fine for me.

