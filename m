Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaHNIvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:51:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaHNIvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:51:07 -0400
Date: Thu, 14 Aug 2014 01:50:07 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f247fb8191aa7f10d3f6c987e8ef0853ae789a02@git.kernel.org>
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
In-Reply-To: <1406786474-9306-4-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix missing label symbols
Git-Commit-ID: f247fb8191aa7f10d3f6c987e8ef0853ae789a02
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

Commit-ID:  f247fb8191aa7f10d3f6c987e8ef0853ae789a02
Gitweb:     http://git.kernel.org/tip/f247fb8191aa7f10d3f6c987e8ef0853ae789a02
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:46 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:20:39 -0300

perf symbols: Fix missing label symbols

Label symbols are missing because elf_sec__is_a() fails to find the
section because the section strings do not match the section headers
because the sections headers are from the 'runtime' object and the
sections strings are from the 'symbol source' object.

Fix by getting the section strings from the 'runtime' object so that
they match the section headers.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index ec5ec1c..9fb5e9e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -736,7 +736,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	if (symstrs == NULL)
 		goto out_elf_end;
 
-	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	sec_strndx = elf_getscn(runtime_ss->elf, runtime_ss->ehdr.e_shstrndx);
 	if (sec_strndx == NULL)
 		goto out_elf_end;
 
