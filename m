Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaBVSAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:00:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaBVSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:00:31 -0500
Date: Sat, 22 Feb 2014 09:59:40 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-sybihqycxrmssa4df9516jib@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: No need to export dso__first_symbol
Git-Commit-ID: c96626b1da589075b1b3e815239ceace11350662
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

Commit-ID:  c96626b1da589075b1b3e815239ceace11350662
Gitweb:     http://git.kernel.org/tip/c96626b1da589075b1b3e815239ceace11350662
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 14 Feb 2014 17:09:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:49 -0300

perf symbols: No need to export dso__first_symbol

There are no users outside the file that defines it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-sybihqycxrmssa4df9516jib@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 +-
 tools/perf/util/symbol.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a9d758a..46e2ede 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -410,7 +410,7 @@ struct symbol *dso__find_symbol(struct dso *dso,
 	return symbols__find(&dso->symbols[type], addr);
 }
 
-struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
+static struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
 {
 	return symbols__first(&dso->symbols[type]);
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fffe288..538d484 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -223,7 +223,6 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
-struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
