Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaCKKPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:15:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaCKKLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678279"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 13/17] sched/prio: Add an inline function named rlimit_to_nice in prio.h.
Date: Tue, 11 Mar 2014 18:09:21 +0800
Message-Id: <b686cdc4dfa14914ccaf247de51ccce59dc00151.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:37,
	Serialize complete at 2014/03/11 18:08:37
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
index 29756f8..d9cf5a5 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -49,4 +49,12 @@ static inline long nice_to_rlimit(long nice)
 	return (MAX_NICE - nice + 1);
 }
 
+/*
+ * Convert rlimit style value [1,40] to nice value [-20, 19].
+ */
+static inline long rlimit_to_nice(long prio)
+{
+	return (MAX_NICE - prio + 1);
+}
+
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

