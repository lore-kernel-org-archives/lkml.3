Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBKHgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:36:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaBKHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505337"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/9] sched: prio: Use NICE_WIDTH macro to avoid using of hard coding of 40 and 20 in prio.h.
Date: Tue, 11 Feb 2014 15:34:47 +0800
Message-Id: <72dc351df816a975e30b6320754fb52823d2aa3f.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:04,
	Serialize complete at 2014/02/11 15:33:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched/prio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index c6974c4..ac32258 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -21,8 +21,8 @@
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
 
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+#define MAX_PRIO		(MAX_RT_PRIO + NICE_WIDTH)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + NICE_WIDTH / 2)
 
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
-- 
1.8.2.1

