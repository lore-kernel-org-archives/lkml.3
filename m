Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3J3QeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:34:10 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64640 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3J3QeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:34:07 -0400
Message-ID: <527133AD.4030003@gmail.com>
Date: Wed, 30 Oct 2013 10:28:29 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
CC: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf list: Add usage
References: <1383149707-1008-1-git-send-email-dsahern@gmail.com> <1383149707-1008-2-git-send-email-dsahern@gmail.com>
In-Reply-To: <1383149707-1008-2-git-send-email-dsahern@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000402040305090504040109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000402040305090504040109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/13, 10:15 AM, David Ahern wrote:
> Currently perf list is not very helpful if you forget the syntax:
>    $ perf list -h
>
>    List of pre-defined events (to be used in -e):
>
> After:
>    $ perf list -h
>
>     usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]

gah, this version breaks perf-list. Updated patch attached.



--------------000402040305090504040109
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0002-perf-list-Add-usage-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-perf-list-Add-usage-v2.patch"

>From d08747060ba5af3507831e0265044be17636869d Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@gmail.com>
Date: Wed, 30 Oct 2013 10:26:45 -0600
Subject: [PATCH 2/2] perf list: Add usage - v2

Currently perf list is not very helpful if you forget the syntax:
  $ perf list -h

  List of pre-defined events (to be used in -e):

After:
  $ perf list -h

   usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]

v2: reset index counter based on option parsing.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-list.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 45000e7d4398..011195e38f21 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -14,20 +14,31 @@
 #include "util/parse-events.h"
 #include "util/cache.h"
 #include "util/pmu.h"
+#include "util/parse-options.h"
 
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	const struct option list_options[] = {
+		OPT_END()
+	};
+	const char * const list_usage[] = {
+		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, list_options, list_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	setup_pager();
 
-	if (argc == 1) {
+	if (argc == 0) {
 		print_events(NULL, false);
 		return 0;
 	}
 
-	for (i = 1; i < argc; ++i) {
-		if (i > 2)
+	for (i = 0; i < argc; ++i) {
+		if (i)
 			putchar('\n');
 		if (strncmp(argv[i], "tracepoint", 10) == 0)
 			print_tracepoint_events(NULL, NULL, false);
-- 
1.8.3.4 (Apple Git-47)


--------------000402040305090504040109--
