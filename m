Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3A2HMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:12:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab3A2HMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:12:05 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/9] dasd: Clarify comment
Date: Tue, 29 Jan 2013 08:11:53 +0100
Message-Id: <1359443521-24670-2-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359443521-24670-1-git-send-email-hare@suse.de>
References: <1359443521-24670-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dasd_cancel_req will never return 1, only 0.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/s390/block/dasd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 29225e1..09ddf70 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2313,8 +2313,7 @@ int dasd_sleep_on_immediatly(struct dasd_ccw_req *cqr)
  * Cancels a request that was started with dasd_sleep_on_req.
  * This is useful to timeout requests. The request will be
  * terminated if it is currently in i/o.
- * Returns 1 if the request has been terminated.
- *	   0 if there was no need to terminate the request (not started yet)
+ * Returns 0 if request termination was successful
  *	   negative error code if termination failed
  * Cancellation of a request is an asynchronous operation! The calling
  * function has to wait until the request is properly returned via callback.
@@ -2351,7 +2350,6 @@ int dasd_cancel_req(struct dasd_ccw_req *cqr)
 	return rc;
 }
 
-
 /*
  * SECTION: Operations of the dasd_block layer.
  */
-- 
1.7.4.2

