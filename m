Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaCKKOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:14:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbaCKKLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678283"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 17/17] sched: Get rid of opened code implementation of funtion nice_to_rlimit().
Date: Tue, 11 Mar 2014 18:09:25 +0800
Message-Id: <220c27487540603b7af88ef327600804212a6706.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:40,
	Serialize complete at 2014/03/11 18:08:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee8004c..d2735eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3046,7 +3046,7 @@ EXPORT_SYMBOL(set_user_nice);
 int can_nice(const struct task_struct *p, const int nice)
 {
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
-	int nice_rlim = 20 - nice;
+	int nice_rlim = nice_to_rlimit(nice);
 
 	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
-- 
1.8.2.1

