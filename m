Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3CSTdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:33:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab3CST2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:43 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904498"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/21] workqueue: simplify current_is_workqueue_rescuer()
Date: Wed, 20 Mar 2013 03:28:03 +0800
Message-Id: <1363721306-2030-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:17,
	Serialize complete at 2013/03/20 03:27:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current_is_workqueue_rescuer() <-> current is worker and worker->rescue_wq

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 298cefe..e1b31fc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3936,7 +3936,7 @@ bool current_is_workqueue_rescuer(void)
 {
 	struct worker *worker = current_wq_worker();
 
-	return worker && worker == worker->current_pwq->wq->rescuer;
+	return worker && worker->rescue_wq;
 }
 
 /**
-- 
1.7.7.6

