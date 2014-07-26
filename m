Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaGZWxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 18:53:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44543 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaGZWxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 18:53:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: parse-events.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 00:54:28 +0200
Message-Id: <1406415268-8429-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensures that the string is null-terminate in connection with the
use of strncpy. And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/parse-events.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1e15df1..e2cd8c4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -210,8 +210,12 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 				}
 				strncpy(path->system, sys_dirent.d_name,
 					MAX_EVENT_LENGTH);
+				path->system[MAX_EVENT_LENGTH - 1] = '\0';
+
 				strncpy(path->name, evt_dirent.d_name,
 					MAX_EVENT_LENGTH);
+				path->name[MAX_EVENT_LENGTH - 1] = '\0';
+
 				return path;
 			}
 		}
@@ -1216,8 +1220,10 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 
 		if (strlen(syms->alias))
 			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
-		else
+		else {
 			strncpy(name, syms->symbol, MAX_NAME_LEN);
+			name[MAX_NAME_LEN - 1] = '\0';
+		}
 
 		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
 
-- 
1.7.10.4

