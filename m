Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaDYHgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:36:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaDYHgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:36:38 -0400
Date: Fri, 25 Apr 2014 00:36:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/1] random: export add_disk_randomness
Message-ID: <20140425073637.GB2143@infradead.org>
References: <20140425073610.GA2143@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425073610.GA2143@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be needed for pending changes to the scsi midlayer that now calls
lower level block APIs, as well as any blk-mq driver that wants to contribute
to the random pool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6b75713..0a19d86 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -902,6 +902,7 @@ void add_disk_randomness(struct gendisk *disk)
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
 	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS(&input_pool));
 }
+EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
 
 /*********************************************************************
-- 
1.7.10.4

