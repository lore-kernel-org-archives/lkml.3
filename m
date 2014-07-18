Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbaGRE0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:26:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651AbaGRE0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:26:03 -0400
Date: Thu, 17 Jul 2014 21:25:11 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-bdac0bcf779250e89b96d4a3f381ebaf02c2f4a9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-20-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-20-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Do not attempt to read data from kallsyms
Git-Commit-ID: bdac0bcf779250e89b96d4a3f381ebaf02c2f4a9
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

Commit-ID:  bdac0bcf779250e89b96d4a3f381ebaf02c2f4a9
Gitweb:     http://git.kernel.org/tip/bdac0bcf779250e89b96d4a3f381ebaf02c2f4a9
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:43 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:35 -0300

perf symbols: Do not attempt to read data from kallsyms

Record kallsyms binary type so that tools will not
attempt to read binary data from it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-20-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ae2e446..156ae36 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1664,6 +1664,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
+		dso->binary_type = DSO_BINARY_TYPE__KALLSYMS;
 		dso__set_long_name(dso, "[kernel.kallsyms]", false);
 		map__fixup_start(map);
 		map__fixup_end(map);
@@ -1711,6 +1712,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	if (err > 0 && !dso__is_kcore(dso)) {
+		dso->binary_type = DSO_BINARY_TYPE__GUEST_KALLSYMS;
 		machine__mmap_name(machine, path, sizeof(path));
 		dso__set_long_name(dso, strdup(path), true);
 		map__fixup_start(map);
