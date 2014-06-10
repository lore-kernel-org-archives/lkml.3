Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaFJPFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:05:11 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:49667 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbaFJPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:05:06 -0400
X-Yandex-Uniq: 56db4a11-7d1a-4d43-9edf-502571a9f584
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perf timechart: conditionally update start_time on fork
Date: Tue, 10 Jun 2014 19:04:53 +0400
Message-Id: <1402412694-5996-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
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
index 447ef0a77f85..6941da0cb302 100644
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

