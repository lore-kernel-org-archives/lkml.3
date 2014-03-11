Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaCKFGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:06:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbaCKFBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676435"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 01/15] sched/prio: Add a macro named NICE_TO_RLIMIT in prio.h.
Date: Tue, 11 Mar 2014 12:59:16 +0800
Message-Id: <f475972d21de5738cf3302ab9c95c90fd4407815.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:50,
	Serialize complete at 2014/03/11 12:58:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a macro named NICE_TO_RLIMIT in prio.h to
convert nice value [19,-20] to rlimit style value [1,40].

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched/prio.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ac32258..8e78c47 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -41,4 +41,9 @@
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
+/*
+ * Convert nice value [19,-20] to rlimit style value [1,40].
+ */
+#define NICE_TO_RLIMIT(nice)	(MAX_NICE - nice + 1)
+
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

