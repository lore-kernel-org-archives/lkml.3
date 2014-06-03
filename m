Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaFCH1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:27:52 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28088 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932329AbaFCH1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:27:49 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368499"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: use schedule_timeout_interruptible() instead of open code
Date: Tue, 3 Jun 2014 15:32:17 +0800
Message-ID: <1401780737-12195-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_timeout_interruptible(CREATE_COOLDOWN) is exactly the same as
the original code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a1c2c10..6b6e9f2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1917,8 +1917,7 @@ restart:
 		if (!need_to_create_worker(pool))
 			break;
 
-		__set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(CREATE_COOLDOWN);
+		schedule_timeout_interruptible(CREATE_COOLDOWN);
 
 		if (!need_to_create_worker(pool))
 			break;
-- 
1.7.4.4

