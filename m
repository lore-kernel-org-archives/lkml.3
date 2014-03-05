Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaCEMis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:38:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaCEMid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:38:33 -0500
X-IronPort-AV: E=Sophos;i="4.97,592,1389715200"; 
   d="scan'208";a="9649260"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
        mingo@redhat.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] sched/prio: Replace hardcoding of 40 with NICE_WIDTH.
Date: Wed, 5 Mar 2014 20:36:42 +0800
Message-Id: <1d7cbeaa53561339ddf3b987fce6a7302d7405a3.1394022835.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 20:35:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 20:35:55,
	Serialize complete at 2014/03/05 20:35:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5273037..7ed08ad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3070,7 +3070,7 @@ SYSCALL_DEFINE1(nice, int, increment)
 	 * We don't have to worry. Conceptually one call occurs first
 	 * and we have a single winner.
 	 */
-	increment = clamp(increment, -40, 40);
+	increment = clamp(increment, -NICE_WIDTH, NICE_WIDTH);
 	nice = task_nice(current) + increment;
 
 	nice = clamp_val(nice, MIN_NICE, MAX_NICE);
-- 
1.8.2.1

