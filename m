Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3I3U3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:29:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:45245 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab3I3U3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="367903923"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk
Subject: [PATCH 04/11] block: Return error code of elevator init function
Date: Mon, 30 Sep 2013 13:29:05 -0700
Message-Id: <1380572952-30729-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The error code was ignored, which I assume is a mistake.

Cc: axboe@kernel.dk
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 block/elevator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 2bcbd8c..6c2a8ee 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -184,7 +184,6 @@ static void elevator_release(struct kobject *kobj)
 int elevator_init(struct request_queue *q, char *name)
 {
 	struct elevator_type *e = NULL;
-	int err;
 
 	if (unlikely(q->elevator))
 		return 0;
@@ -222,8 +221,7 @@ int elevator_init(struct request_queue *q, char *name)
 		}
 	}
 
-	err = e->ops.elevator_init_fn(q, e);
-	return 0;
+	return e->ops.elevator_init_fn(q, e);
 }
 EXPORT_SYMBOL(elevator_init);
 
-- 
1.8.3.1

