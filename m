Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3JVO2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:28:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3JVO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/26] perf list: Show error if tracepoints not available
Date: Tue, 22 Oct 2013 11:28:27 -0300
Message-Id: <1382452114-1243-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

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
index 98125319b158..c90e55cf7e82 100644
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
-- 
1.8.1.4

