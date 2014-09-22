Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaIVN5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:57:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:54538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaIVN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:57:10 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: two more fixes for block/for-linus
Date: Mon, 22 Sep 2014 15:59:29 +0200
Message-Id: <1411394371-16254-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two regressions with the timer/blk_mq_start_request changes found
when using scsi-mq on an ATA device.

Note that given how late we are in the cycle I wonder if we really should
push the changes in block/for-linus to Linus in this cycle.  The race
part of the timer fixes is extremly narrow, and the reserved request
part of it requires an out of tree driver update to trigger it, so it
doesn't sound super criticial.

