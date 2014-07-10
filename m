Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaGJVIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGJVHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:07:12 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/4] perf timechart: Conditionally update start_time on fork
Date: Thu, 10 Jul 2014 23:06:56 +0200
Message-Id: <1405026417-9094-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405026417-9094-1-git-send-email-jolsa@kernel.org>
References: <1405026417-9094-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

We don't need to overwrite current task start_time on fork, so update it
only if it's zero.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1404835423-23098-4-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-timechart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 4079062..37bf1eb 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -242,7 +242,7 @@ static void pid_fork(struct timechart *tchart, int pid, int ppid, u64 timestamp)
 		pid_set_comm(tchart, pid, pp->current->comm);
 
 	p->start_time = timestamp;
-	if (p->current) {
+	if (p->current && !p->current->start_time) {
 		p->current->start_time = timestamp;
 		p->current->state_since = timestamp;
 	}
-- 
1.8.3.1

