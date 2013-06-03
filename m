Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3FCPEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:04:25 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:58832 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3FCPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:19 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Stefan Weinhuber <wein@de.ibm.com>
Subject: [PATCH 1/9] dasd: Clarify comment
Date: Mon,  3 Jun 2013 17:03:14 +0200
Message-Id: <1370271802-30019-2-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
References: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060315-4966-0000-0000-000005EB29B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

dasd_cancel_req will never return 1, only 0.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/block/dasd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index d72a9216e..4985489 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2402,8 +2402,7 @@ int dasd_sleep_on_immediatly(struct dasd_ccw_req *cqr)
  * Cancels a request that was started with dasd_sleep_on_req.
  * This is useful to timeout requests. The request will be
  * terminated if it is currently in i/o.
- * Returns 1 if the request has been terminated.
- *	   0 if there was no need to terminate the request (not started yet)
+ * Returns 0 if request termination was successful
  *	   negative error code if termination failed
  * Cancellation of a request is an asynchronous operation! The calling
  * function has to wait until the request is properly returned via callback.
@@ -2440,7 +2439,6 @@ int dasd_cancel_req(struct dasd_ccw_req *cqr)
 	return rc;
 }
 
-
 /*
  * SECTION: Operations of the dasd_block layer.
  */
-- 
1.7.9.5

