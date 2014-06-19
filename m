Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaFSMXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:23:39 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:54736 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757963AbaFSMXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:23:36 -0400
X-Yandex-Uniq: 73bb85bd-5711-44d0-9922-92e73238d17a
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, rusty@rustcorp.com.au,
        bp@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perf timechart: conditionally update start_time on fork
Date: Thu, 19 Jun 2014 16:23:02 +0400
Message-Id: <1403180583-12309-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403180583-12309-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403180583-12309-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to overwrite current task start_time on fork, so update it
only if it's zero.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 7386e91de838..6ccc2ffa3156 100644
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
1.8.3.2

