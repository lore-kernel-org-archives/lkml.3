Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaGJQKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:10:17 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:53167 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591AbaGJQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:10:15 -0400
X-IronPort-AV: E=Sophos;i="5.00,869,1396972800"; 
   d="scan'208";a="33108119"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: reuse the calculated pwq in try_to_grab_pending()
Date: Fri, 11 Jul 2014 00:11:13 +0800
Message-ID: <1405008673-12805-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsitute the get_work_pwq(work) to pwq since it is calculated.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c820057..7fc3df3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1225,7 +1225,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			pwq_activate_delayed_work(work);
 
 		list_del_init(&work->entry);
-		pwq_dec_nr_in_flight(get_work_pwq(work), get_work_color(work));
+		pwq_dec_nr_in_flight(pwq, get_work_color(work));
 
 		/* work->data points to pwq iff queued, point to pool */
 		set_work_pool_and_keep_pending(work, pool->id);
-- 
1.7.4.4

