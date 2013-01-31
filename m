Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3AaSnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:43:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63106 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab3AaSmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:42:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672842"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 11/13] workqueue: allow more work_pool id space
Date: Fri, 1 Feb 2013 02:41:34 +0800
Message-Id: <1359657696-2767-12-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:53,
	Serialize complete at 2013/02/01 02:40:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

color bits is not used when offq, so we reuse them for pool IDs.
thus we will have more pool IDs.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index db1782b..cb8e69d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -68,7 +68,7 @@ enum {
 				  WORK_STRUCT_COLOR_BITS,
 
 	/* data contains off-queue information when !WORK_STRUCT_CWQ */
-	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_FLAG_BITS,
+	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_COLOR_SHIFT,
 
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
 
-- 
1.7.7.6

