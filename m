Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaEVIja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:39:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621AbaEVIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:39:29 -0400
X-IronPort-AV: E=Sophos;i="4.98,885,1392134400"; 
   d="scan'208";a="30863966"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove unused WORK_CPU_END
Date: Thu, 22 May 2014 16:43:44 +0800
Message-ID: <1400748224-14063-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WORK_CPU_END is totally unused since 4e8b22bd. It should be removed.

After it is removed, the comment "special cpu IDs" is not precise due to
there is only one special CPU ID (WORK_CPU_UNBOUND) left, so we also
change this comment to the description for WORK_CPU_UNBOUND.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7a8800c..860fcca 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -56,9 +56,8 @@ enum {
 	WORK_NR_COLORS		= (1 << WORK_STRUCT_COLOR_BITS) - 1,
 	WORK_NO_COLOR		= WORK_NR_COLORS,
 
-	/* special cpu IDs */
+	/* NOT bound to any CPU, the local CPU will be used if possible. */
 	WORK_CPU_UNBOUND	= NR_CPUS,
-	WORK_CPU_END		= NR_CPUS + 1,
 
 	/*
 	 * Reserve 7 bits off of pwq pointer w/ debugobjects turned off.
-- 
1.7.4.4

