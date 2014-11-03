Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKCIYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:24:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:54716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKCIXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:23:19 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: Richard Weinberger <richard@nod.at>, Ming Lei <tom.leiming@gmail.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: blk-mq: allow to defer ->queue_rq invocations to workqueue
Date: Mon,  3 Nov 2014 09:23:26 +0100
Message-Id: <1415003008-16683-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that need to do synchronous, blocking operations to do I/O generally
want to defer all I/O to a drіver-private workqueue.  Examples for that are
the loop driver, rbd, or ubi block driver, and probably lots more that haven't
been evaluated yet.

