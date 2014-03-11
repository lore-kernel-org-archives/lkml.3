Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaCKFBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:01:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbaCKFBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:01:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676433"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 05/15] tools/mq_perf_tests: Replace hardcoding of -20 with MIN_NICE.
Date: Tue, 11 Mar 2014 12:59:20 +0800
Message-Id: <b4247face203ea66153bca72f63f630b270c9d7e.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 12:58:50,
	Serialize complete at 2014/03/11 12:58:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/testing/selftests/mqueue/mq_perf_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
index 2fadd4b..09dce51 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -527,9 +527,9 @@ void increase_limits(void)
 	while (try_set(max_msgsize, cur_max_msgsize += 1024))
 		;
 	cur_max_msgsize = get(max_msgsize);
-	if (setpriority(PRIO_PROCESS, 0, -20) != 0)
+	if (setpriority(PRIO_PROCESS, 0, MIN_NICE) != 0)
 		shutdown(2, "setpriority()", __LINE__);
-	cur_nice = -20;
+	cur_nice = MIN_NICE;
 }
 
 int main(int argc, char *argv[])
-- 
1.8.2.1

