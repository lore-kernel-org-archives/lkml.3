Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaFDVp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:45:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64376 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaFDVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:45:24 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: parse-events.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:46:18 +0200
Message-Id: <1401918378-3842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/parse-events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1e15df1..fad2976 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1216,8 +1216,10 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 
 		if (strlen(syms->alias))
 			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
-		else
+		else {
 			strncpy(name, syms->symbol, MAX_NAME_LEN);
+			name[sizeof(name) - 1] = '\0';
+		}
 
 		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
 
-- 
1.7.10.4

