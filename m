Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab3JNUSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:18:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3JNUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 112/161] perf machine: Use snprintf instead of sprintf
Date: Mon, 14 Oct 2013 17:01:41 -0300
Message-Id: <1381780950-25642-113-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

To avoid buffer overruns.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1379845338-29637-2-git-send-email-adrian.hunter@intel.com
[ Split from aa7fe3b ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6188d2876a71..ddf917b787fa 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -785,10 +785,10 @@ static int machine__create_modules(struct machine *machine)
 	const char *modules;
 	char path[PATH_MAX];
 
-	if (machine__is_default_guest(machine))
+	if (machine__is_default_guest(machine)) {
 		modules = symbol_conf.default_guest_modules;
-	else {
-		sprintf(path, "%s/proc/modules", machine->root_dir);
+	} else {
+		snprintf(path, PATH_MAX, "%s/proc/modules", machine->root_dir);
 		modules = path;
 	}
 
-- 
1.8.1.4

