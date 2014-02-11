Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaBKHfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:35:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBKHfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505336"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/9] sched: Prio: Use DEFAULT_PRIO to define NICE_TO_PRIO and PRIO_TO_NICE.
Date: Tue, 11 Feb 2014 15:34:45 +0800
Message-Id: <4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com>
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

There is already a macro named DEFAULT_PRIO in prio.h, we can use it
to define NICE_TO_PRIO and PRIO_TO_NICE rather than use hard coding
of (MAX_RT_PRIO + 20).

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/prio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 410ccb7..1ceaaa1 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -25,8 +25,8 @@
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
  * and back.
  */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
+#define NICE_TO_PRIO(nice)	((nice) + DEFAULT_PRIO)
+#define PRIO_TO_NICE(prio)	((prio) - DEFAULT_PRIO)
 
 /*
  * 'User priority' is the nice value converted to something we
-- 
1.8.2.1

