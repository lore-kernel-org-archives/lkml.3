Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaKTHiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:38:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbaKTHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:38:01 -0500
Date: Wed, 19 Nov 2014 23:37:12 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-162bcc17bb876772793ca070ebd6488cfdae09bf@git.kernel.org>
Cc: hpa@zytor.com, acme@redhat.com, bp@suse.de, eranian@google.com,
        dsahern@gmail.com, peterz@infradead.org, jolsa@redhat.com,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, dzickus@redhat.com, efault@gmx.de,
        namhyung@kernel.org, fweisbec@gmail.com, mingo@kernel.org
Reply-To: peterz@infradead.org, dsahern@gmail.com, adrian.hunter@intel.com,
        jolsa@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, efault@gmx.de, namhyung@kernel.org,
        fweisbec@gmail.com, mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        bp@suse.de, eranian@google.com
In-Reply-To: <20141111130326.GT18464@kernel.org>
References: <20141111130326.GT18464@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Fallback to kallsyms when using the minimal 'ELF' loader
Git-Commit-ID: 162bcc17bb876772793ca070ebd6488cfdae09bf
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

Commit-ID:  162bcc17bb876772793ca070ebd6488cfdae09bf
Gitweb:     http://git.kernel.org/tip/162bcc17bb876772793ca070ebd6488cfdae09bf
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Nov 2014 11:25:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:46 -0300

perf symbols: Fallback to kallsyms when using the minimal 'ELF' loader

The minimal ELF loader should not return 1 when it manages to read the
vmlinux build-id, it should instead return 0, meaning that it hasn't
loaded any symbols, since it doesn't parses ELF at all.

That way, the main symbol.c routines will understand that it is
necessary to continue looking for a file with symbols, and when no
libelf is linked, that means it will eventually try kallsyms.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20141111130326.GT18464@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-minimal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c9541fe..fa585c6 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -341,7 +341,6 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 
 	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
 		dso__set_build_id(dso, build_id);
-		return 1;
 	}
 	return 0;
 }
