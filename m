Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaLATGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:06:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaLATGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:06:50 -0500
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
Subject: [PATCH 1/8] perf tools: Use single strcmp call instead of two
Date: Mon,  1 Dec 2014 20:06:22 +0100
Message-Id: <1417460789-13874-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to use 2 strcmp calls, one is enough.

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
 tools/perf/util/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 57ff826f150b..c802236b2bfe 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -522,7 +522,7 @@ static int buildid_dir_command_config(const char *var, const char *value,
 	const char *v;
 
 	/* same dir for all commands */
-	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
+	if (!strcmp(var, "buildid.dir")) {
 		v = perf_config_dirname(var, value);
 		if (!v)
 			return -1;
-- 
1.9.3

