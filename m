Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3JWHyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:54:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3JWHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:50 -0400
Date: Wed, 23 Oct 2013 00:54:39 -0700
From: tip-bot for Pekka Enberg <tipbot@zytor.com>
Message-ID: <tip-f11cfc6f294dbd83b0d58037404df2bd16066238@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, tglx@linutronix.de
In-Reply-To: <1381867647-8594-1-git-send-email-penberg@kernel.org>
References: <1381867647-8594-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list:
  Show error if tracepoints not available
Git-Commit-ID: f11cfc6f294dbd83b0d58037404df2bd16066238
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:54:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f11cfc6f294dbd83b0d58037404df2bd16066238
Gitweb:     http://git.kernel.org/tip/f11cfc6f294dbd83b0d58037404df2bd16066238
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 15 Oct 2013 23:07:27 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 17:33:22 -0300

perf list: Show error if tracepoints not available

Tracepoints are not visible in "perf list" on Fedora 19 because regular
users have no permission to /sys/kernel/debug by default. Show an error
message so that the user knows about it instead of assuming that
tracepoints are not supported on the system.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1381867647-8594-1-git-send-email-penberg@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9812531..c90e55c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -998,8 +998,10 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (debugfs_valid_mountpoint(tracing_events_path))
+	if (debugfs_valid_mountpoint(tracing_events_path)) {
+		printf("  [ Tracepoints not available: %s ]\n", strerror(errno));
 		return;
+	}
 
 	sys_dir = opendir(tracing_events_path);
 	if (!sys_dir)
