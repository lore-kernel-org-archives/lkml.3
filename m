Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab3FRVYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:24:32 -0400
Received: from hancock.steeleye.com ([66.162.12.4]:56399 "EHLO
	hancock.steeleye.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932799Ab3FRVYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:24:31 -0400
X-Greylist: delayed 1244 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jun 2013 17:24:31 EDT
From: Paul Clements <paul.clements@steeleye.com>
CC: <linux-kernel@vger.kernel.org>, <paul.clements@steeleye.com>,
        <belczyk@bsd.krakow.pl>
Subject: [PATCH] nbd: remove bogus BUG_ON in NBD_CLEAR_QUE
To: <akpm@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.2)
Message-Id: <20130618210346.659F0222D8@clements>
Date: Tue, 18 Jun 2013 17:03:46 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Belczyk <belczyk@bsd.krakow.pl>

The NBD_CLEAR_QUE ioctl has been deprecated for quite some time (its job
is now done by two other ioctls). We should stop trying to make bogus
assertions in it. Also, user-level code should remove calls to
NBD_CLEAR_QUE, ASAP.

Signed-off-by: Michal Belczyk <belczyk@bsd.krakow.pl>
Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 nbd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7fecc78..21ba264 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -750,7 +750,6 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		 * This is for compatibility only.  The queue is always cleared
 		 * by NBD_DO_IT or NBD_CLEAR_SOCK.
 		 */
-		BUG_ON(!nbd->sock && !list_empty(&nbd->queue_head));
 		return 0;
 
 	case NBD_PRINT_DEBUG:
