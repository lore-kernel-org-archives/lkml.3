Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965368AbaLLIRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:17:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965325AbaLLIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:17:45 -0500
Date: Fri, 12 Dec 2014 00:17:20 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-eec5a688f426d6fe4097feb0b916ad41803d2ebb@git.kernel.org>
Cc: acme@redhat.com, jolsa@kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, mingo@kernel.org,
        fweisbec@gmail.com, eranian@google.com, cjashfor@linux.vnet.ibm.com,
        namhyung@kernel.org, hpa@zytor.com, adrian.hunter@intel.com
Reply-To: fweisbec@gmail.com, eranian@google.com, mingo@kernel.org,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, namhyung@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, acme@redhat.com,
        jolsa@kernel.org, tglx@linutronix.de, paulus@samba.org
In-Reply-To: <1417460789-13874-7-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-7-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid cache:
  Fix -a segfault related to kcore handling
Git-Commit-ID: eec5a688f426d6fe4097feb0b916ad41803d2ebb
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

Commit-ID:  eec5a688f426d6fe4097feb0b916ad41803d2ebb
Gitweb:     http://git.kernel.org/tip/eec5a688f426d6fe4097feb0b916ad41803d2ebb
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 1 Dec 2014 20:06:27 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 09:14:34 -0300

perf buildid cache: Fix -a segfault related to kcore handling

The kcore_filename is uninitialized and trash value could trigger
build_id_cache__add_kcore function ending up with segfault.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1417460789-13874-7-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 29f24c0..77d5cae 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -289,7 +289,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		   *remove_name_list_str = NULL,
 		   *missing_filename = NULL,
 		   *update_name_list_str = NULL,
-		   *kcore_filename;
+		   *kcore_filename = NULL;
 	char sbuf[STRERR_BUFSIZE];
 
 	struct perf_data_file file = {
