Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734AbaEFL2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:28:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31327 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600AbaEFL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:28:45 -0400
Date: Tue, 6 May 2014 14:28:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] drbd: silence underflow warning in read_in_block()
Message-ID: <20140506112832.GA25561@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker warns that "data_size" could be negative and underflow
the limit check.  The code looks suspicious but I don't know if it is a
real bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b6c8aaf..15daf86d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1528,7 +1528,7 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 	struct drbd_peer_request *peer_req;
 	struct page *page;
 	int dgs, ds, err;
-	int data_size = pi->size;
+	unsigned int data_size = pi->size;
 	void *dig_in = peer_device->connection->int_dig_in;
 	void *dig_vv = peer_device->connection->int_dig_vv;
 	unsigned long *data;
