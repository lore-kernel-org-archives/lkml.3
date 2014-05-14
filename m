Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaENMyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:54:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49555 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaENMyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:54:39 -0400
Date: Wed, 14 May 2014 15:54:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@fb.com>
Cc: Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] mtip32xx: blk_mq_init_queue() returns an ERR_PTR
Message-ID: <20140514125418.GA14571@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed this from blk_alloc_queue_node() to blk_mq_init_queue() so
the check needs to be updated as well.

Fixes: ee5036035df1 ('mtip32xx: convert to use blk-mq')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 3a0882e..5979ab3 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3890,7 +3890,7 @@ skip_create_disk:
 
 	/* Allocate the request queue. */
 	dd->queue = blk_mq_init_queue(&dd->tags);
-	if (dd->queue == NULL) {
+	if (IS_ERR(dd->queue)) {
 		dev_err(&dd->pdev->dev,
 			"Unable to allocate request queue\n");
 		rv = -ENOMEM;
