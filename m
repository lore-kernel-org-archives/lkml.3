Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaCKJZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:25:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19362 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbaCKJXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:23:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677985"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 12/16] sched/prio: Add an inline function named rlimit_to_nice in prio.h.
Date: Tue, 11 Mar 2014 17:20:33 +0800
Message-Id: <c0e060484242fd6d5ff3fd29d241805b47ac70ac.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:15,
	Serialize complete at 2014/03/11 17:20:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an inline function named rlimit_to_nice to convert
rlimit style value in [1, 40] to nice value in [-20, 19].

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched/prio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index c15cbda..b8d729e 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -49,4 +49,12 @@ static inline nice_to_rlimit(long nice)
 	return (MAX_NICE - nice + 1);
 }
 
+/*
+ * Convert rlimit style value [1,40] to nice value [-20, 19].
+ */
+static inline rlimit_to_nice(long prio)
+{
+	return (MAX_NICE - prio + 1);
+}
+
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

