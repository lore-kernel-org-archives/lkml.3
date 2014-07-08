Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaGHQEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:04:05 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:42396 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbaGHQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:03:59 -0400
X-Yandex-Uniq: acb248e4-8119-45fd-bf68-6811aa8345f2
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, rusty@rustcorp.com.au,
        bp@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] perf timechart: conditionally update start_time on fork
Date: Tue,  8 Jul 2014 20:03:42 +0400
Message-Id: <1404835423-23098-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404835423-23098-1-git-send-email-stfomichev@yandex-team.ru>
References: <1404835423-23098-1-git-send-email-stfomichev@yandex-team.ru>
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
index 4079062d25b0..37bf1eb0755f 100644
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
1.9.1

