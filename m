Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030394AbaGPTSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:18:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaGPTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:18:37 -0400
Date: Wed, 16 Jul 2014 12:18:27 -0700
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-962e310af5dff432745ae7494096ed54b752e63e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Conditionally update start_time on fork
Git-Commit-ID: 962e310af5dff432745ae7494096ed54b752e63e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  962e310af5dff432745ae7494096ed54b752e63e
Gitweb:     http://git.kernel.org/tip/962e310af5dff432745ae7494096ed54b752e63e
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Tue, 8 Jul 2014 20:03:42 +0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 10 Jul 2014 00:22:54 +0200

perf timechart: Conditionally update start_time on fork

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
