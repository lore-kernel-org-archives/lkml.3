Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaEVIia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:38:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:36827 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751066AbaEVIi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:38:28 -0400
X-IronPort-AV: E=Sophos;i="4.98,885,1392134400"; 
   d="scan'208";a="30863929"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: declare system_highpri_wq
Date: Thu, 22 May 2014 16:42:41 +0800
Message-ID: <1400748162-13984-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system_highpri_wq is exported to modules via EXPORT_SYMBOL_GPL(),
but it was forgotten to be declared in workqueue.h. So we add the declaration
and a short description for it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index d93d28b..7a8800c 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -340,6 +340,9 @@ enum {
  * short queue flush time.  Don't queue works which can run for too
  * long.
  *
+ * system_highpri_wq is similar to system_wq but services for work items
+ * which need to be processed with high priority.
+ *
  * system_long_wq is similar to system_wq but may host long running
  * works.  Queue flushing might take relatively long.
  *
@@ -358,6 +361,7 @@ enum {
  * 'wq_power_efficient' is disabled.  See WQ_POWER_EFFICIENT for more info.
  */
 extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_highpri_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
-- 
1.7.4.4

