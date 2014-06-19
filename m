Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbaFSVOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:34092 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbaFSVOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/11] perf evlist: Add suggestion of how to set perf_event_paranoid sysctl
Date: Thu, 19 Jun 2014 18:13:44 -0300
Message-Id: <1403212433-2714-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Minor hint to speed up problem resolution and get 'trace' working for
non root users.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-abdqi8km4fj9osrn70q2zj9v@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 59ef2802fcf6..c51223ac25f4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1214,10 +1214,11 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 					     "For your workloads it needs to be <= 1\nHint:\t");
 		}
 		printed += scnprintf(buf + printed, size - printed,
-				     "For system wide tracing it needs to be set to -1");
+				     "For system wide tracing it needs to be set to -1.\n");
 
 		printed += scnprintf(buf + printed, size - printed,
-				    ".\nHint:\tThe current value is %d.", value);
+				    "Hint:\tTry: 'sudo sh -c \"echo -1 > /proc/sys/kernel/perf_event_paranoid\"'\n"
+				    "Hint:\tThe current value is %d.", value);
 		break;
 	default:
 		scnprintf(buf, size, "%s", emsg);
-- 
1.9.3

