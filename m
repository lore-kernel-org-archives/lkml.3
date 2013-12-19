Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3LSJmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:42:43 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48829 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3LSJmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:42:36 -0500
Date: Thu, 19 Dec 2013 15:12:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 07/13] drivers: block: Mark functions as static in drbd_req.c
Message-ID: <bed1e9bacd23651dac1fdcc20049fe9f930c804b.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions drbd_request_prepare() and find_oldest_request() as
static in drbd/drbd_req.c because they are not used outside this file.

This eliminates the following warnings in drbd/drbd_req.c:
drivers/block/drbd/drbd_req.c:1037:1: warning: no previous prototype for ‘drbd_request_prepare’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_req.c:1323:22: warning: no previous prototype for ‘find_oldest_request’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_req.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index fec7bef..771697b 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1033,7 +1033,7 @@ static void drbd_queue_write(struct drbd_conf *mdev, struct drbd_request *req)
  * request on the submitter thread.
  * Returns ERR_PTR(-ENOMEM) if we cannot allocate a drbd_request.
  */
-struct drbd_request *
+static struct drbd_request *
 drbd_request_prepare(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
 {
 	const int rw = bio_data_dir(bio);
@@ -1320,7 +1320,7 @@ int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct
 	return limit;
 }
 
-struct drbd_request *find_oldest_request(struct drbd_tconn *tconn)
+static struct drbd_request *find_oldest_request(struct drbd_tconn *tconn)
 {
 	/* Walk the transfer log,
 	 * and find the oldest not yet completed request */
-- 
1.7.9.5

