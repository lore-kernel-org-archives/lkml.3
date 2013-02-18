Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3BRQMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:12:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41144 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3BRQMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:12:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724939"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 02/15] workqueue: allow more work_pool id space
Date: Tue, 19 Feb 2013 00:12:03 +0800
Message-Id: <1361203940-6300-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:11:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:11:56,
	Serialize complete at 2013/02/19 00:11:56
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
index a3d7556..0be57d4 100644
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

