Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaLATHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:07:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbaLATHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:07:15 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/8] perf buildid cache: Fix -a segfault
Date: Mon,  1 Dec 2014 20:06:27 +0100
Message-Id: <1417460789-13874-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kcore_filename is uninitialized and trash value could
trigger build_id_cache__add_kcore function ending up with
segfault.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-buildid-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 184955ec8a83..7a3504a1b494 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -737,7 +737,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		   *remove_name_list_str = NULL,
 		   *missing_filename = NULL,
 		   *update_name_list_str = NULL,
-		   *kcore_filename;
+		   *kcore_filename = NULL;
 	char sbuf[STRERR_BUFSIZE];
 
 	struct perf_data_file file = {
-- 
1.9.3

