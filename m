Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaBKHft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:35:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaBKHfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505335"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/9] sched: prio: Add 3 macros of MAX_NICE, MIN_NICE and NICE_WIDTH in prio.h.
Date: Tue, 11 Feb 2014 15:34:46 +0800
Message-Id: <3994e89327b2b15f992277cdf9f409c516f87d1b.1392103744.git.yangds.fnst@cn.fujitsu.com>
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

Currently, there are lots of hard coding of 19 and -20 to represent
maximum and minimum of nice value.

This patch add three macros in prio.h for maximum, minimum and width
of nice value.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/prio.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 1ceaaa1..c6974c4 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -1,6 +1,10 @@
 #ifndef _SCHED_PRIO_H
 #define _SCHED_PRIO_H
 
+#define MAX_NICE	19
+#define MIN_NICE	-20
+#define NICE_WIDTH	(MAX_NICE - MIN_NICE + 1)
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
-- 
1.8.2.1

