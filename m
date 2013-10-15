Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3JOUHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:07:36 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:54693 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3JOUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:07:34 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf list: Show error if tracepoints not available
Date: Tue, 15 Oct 2013 23:07:27 +0300
Message-Id: <1381867647-8594-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracepoints are not visible in "perf list" on Fedora 19 because regular
users have no permission to /sys/kernel/debug by default. Show an error
message so that the user knows about it instead of assuming that
tracepoints are not supported on the system.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
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
-- 
1.8.3.1

