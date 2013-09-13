Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3IMHzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:55:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51813 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3IMHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:55:38 -0400
Date: Fri, 13 Sep 2013 10:55:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/4] skd: use regular version of copy_from_user()
Message-ID: <20130913075523.GE19211@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other __copy_from_user() calls have access_ok() checks so they are
fine, but these two don't have the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 6fc0296..dfd05a9 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -1736,7 +1736,7 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		return -EINVAL;
 	}
 
-	if (__copy_from_user(sksgio->cdb, sgp->cmdp, sgp->cmd_len)) {
+	if (copy_from_user(sksgio->cdb, sgp->cmdp, sgp->cmd_len)) {
 		DPRINTK(skdev, "copy_from_user cmdp failed %p\n", sgp->cmdp);
 		return -EFAULT;
 	}
@@ -1767,7 +1767,7 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		sksgio->iov = iov;
 		sksgio->iovcnt = sgp->iovec_count;
 
-		if (__copy_from_user(iov, sgp->dxferp, nbytes)) {
+		if (copy_from_user(iov, sgp->dxferp, nbytes)) {
 			DPRINTK(skdev, "copy_from_user iovec failed %p\n",
 				sgp->dxferp);
 			return -EFAULT;
