Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3EYXyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 19:54:10 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58457 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab3EYXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 19:54:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] perf: fix printing of perf_event_paranoid message
Date: Sat, 25 May 2013 17:54:00 -0600
Message-Id: <1369526040-1368-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

message is currently shown as:

  Error:
  You may not have permission to collect %sstats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:

Note the %sstats. With patch this becomes:

  Error:
  You may not have permission to collect stats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 07b1a3a..63b6f8c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1514,7 +1514,7 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel,
 	switch (err) {
 	case EPERM:
 	case EACCES:
-		return scnprintf(msg, size, "%s",
+		return scnprintf(msg, size,
 		 "You may not have permission to collect %sstats.\n"
 		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		 " -1 - Not paranoid at all\n"
-- 
1.7.10.1

