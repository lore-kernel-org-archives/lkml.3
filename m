Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235AbaLLIRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:17:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832AbaLLIRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:17:15 -0500
Date: Fri, 12 Dec 2014 00:16:50 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-cfd31d85bb42b96449157bd57c638dc779070753@git.kernel.org>
Cc: namhyung@kernel.org, acme@redhat.com, fweisbec@gmail.com,
        eranian@google.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, jolsa@kernel.org, cjashfor@linux.vnet.ibm.com,
        mingo@kernel.org, paulus@samba.org
Reply-To: jolsa@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
        cjashfor@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, eranian@google.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, namhyung@kernel.org,
        acme@redhat.com, fweisbec@gmail.com
In-Reply-To: <1417460789-13874-2-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Use single strcmp call instead of two
Git-Commit-ID: cfd31d85bb42b96449157bd57c638dc779070753
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfd31d85bb42b96449157bd57c638dc779070753
Gitweb:     http://git.kernel.org/tip/cfd31d85bb42b96449157bd57c638dc779070753
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 1 Dec 2014 20:06:22 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 09:14:33 -0300

perf tools: Use single strcmp call instead of two

There's no need to use 2 strcmp calls, one is enough.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1417460789-13874-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 57ff826..c802236 100644
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
