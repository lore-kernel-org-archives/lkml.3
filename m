Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3IMH4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:56:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16483 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab3IMH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:56:35 -0400
Date: Fri, 13 Sep 2013 10:56:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/4] skd: use after free bugs in debug code
Message-ID: <20130913075625.GF19211@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've freed "skdev" but the debug code dereferences it.  I've just
removed the printk() entirely.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index dfd05a9..f892d95 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4919,8 +4919,6 @@ static void skd_destruct(struct skd_device *skdev)
 
 	VPRINTK(skdev, "skdev\n");
 	kfree(skdev);
-
-	DPRINTK(skdev, "VICTORY\n");
 }
 
 static void skd_free_skcomp(struct skd_device *skdev)
