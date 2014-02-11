Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaBKHfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:35:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaBKHfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:09 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505340"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 8/9] workqueue: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
Date: Tue, 11 Feb 2014 15:34:52 +0800
Message-Id: <6d85138180c00ce86975addab6e34b24b84f00a5.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:05,
	Serialize complete at 2014/02/11 15:33:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..e4f5905 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3218,7 +3218,7 @@ static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
 		return -ENOMEM;
 
 	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
-	    attrs->nice >= -20 && attrs->nice <= 19)
+	    attrs->nice >= MIN_NICE && attrs->nice <= MAX_NICE)
 		ret = apply_workqueue_attrs(wq, attrs);
 	else
 		ret = -EINVAL;
-- 
1.8.2.1

