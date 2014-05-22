Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaEVIjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:39:44 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:47077 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752822AbaEVIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:39:41 -0400
X-IronPort-AV: E=Sophos;i="4.98,885,1392134400"; 
   d="scan'208";a="30863978"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove unused work_clear_pending()
Date: Thu, 22 May 2014 16:43:56 +0800
Message-ID: <1400748236-14097-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 8930caba, setting last CPU and clearing PENDING got merged into a single
operation (set_work_cpu_and_clear_pending()), which resulted that the
internal routine work_clear_pending() is not used any more.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 860fcca..89b662b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -273,13 +273,6 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 #define delayed_work_pending(w) \
 	work_pending(&(w)->work)
 
-/**
- * work_clear_pending - for internal use only, mark a work item as not pending
- * @work: The work item in question
- */
-#define work_clear_pending(work) \
-	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
-
 /*
  * Workqueue flags and constants.  For details, please refer to
  * Documentation/workqueue.txt.
-- 
1.7.4.4

