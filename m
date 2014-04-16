Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaDPHmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:42:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:56260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaDPHmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:42:49 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: next round of blk-mq updates
Date: Wed, 16 Apr 2014 09:44:51 +0200
Message-Id: <1397634299-7466-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

these are the final blk-mq changes for a fully working SCSI midlayer
using blk-mq.

Summary of the changes:

 - a new split I/O completion handler that allow the driver to free
   ressources when it knows a request will be fully completed, but
   before it has been freed
 - support for bidirectional requests, which is very trivial when
   used with the above split I/O completion handler.
 - support to requeue a request that already entered the driver,
   which is needed by the SCSI midlayer to support partial completions
   as well as various error conditions.
 - a couple of new ways to poke a queue:
	- an equivalent to blk_delay_queue to wake a stopped
	  queue after a delay
	- a new function to kick a queue that might be stopped or not
	- a parameter to blk_mq_start_stopped_hw_queues so that it can
	  be called from (soft)irq context

