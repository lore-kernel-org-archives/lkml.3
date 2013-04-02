Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab3DBJ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:58:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924Ab3DBJ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:58:42 -0400
Date: Tue, 2 Apr 2013 02:58:18 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-62667746a6ded2a1fc8dac2e6258f46150b5e46c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1359040242-8269-19-git-send-email-eranian@google.com>
References: <1359040242-8269-19-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix output of symbol_daddr offset
Git-Commit-ID: 62667746a6ded2a1fc8dac2e6258f46150b5e46c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:58:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62667746a6ded2a1fc8dac2e6258f46150b5e46c
Gitweb:     http://git.kernel.org/tip/62667746a6ded2a1fc8dac2e6258f46150b5e46c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 24 Jan 2013 16:10:42 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:22:15 -0300

perf tools: Fix output of symbol_daddr offset

The symbol addresses in a dso have relative offsets from the start of a
mapping.  So in order to ouput correct offset value from @ip, one of
them should be converted.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1359040242-8269-19-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 32a1ef1..5f52d49 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -202,7 +202,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 		if (map->type == MAP__VARIABLE) {
 			ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
 			ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
-					ip - sym->start);
+					ip - map->unmap_ip(map, sym->start));
 			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
 				       width - ret, "");
 		} else {
