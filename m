Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaAGIvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:51:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:29271 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaAGIvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:51:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="462792533"
Subject: [PATCH 3/3] dm snapshot: Calling destroy_work_on_stack() to pair
 with INIT_WORK_ONSTACK()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: agk@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1389084605.3650.66.camel@cliu38-desktop-build>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jan 2014 16:56:18 +0800
Message-ID: <1389084978.3650.73.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
call destroy_work_on_stack() which frees the debug object to pair
with INIT_WORK_ONSTACK().

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/md/dm-snap-persistent.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 2d2b1b7..2f5a9f8 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -257,6 +257,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
 	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
 	flush_workqueue(ps->metadata_wq);
+	destroy_work_on_stack(&req.work);
 
 	return req.result;
 }
-- 
1.7.9.5



