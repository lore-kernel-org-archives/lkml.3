Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3IYRVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:21:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54945 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3IYRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:20:45 -0400
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
Subject: [PATCH 5/6] perf machine: Fix path unpopulated in machine__create_modules()
Date: Wed, 25 Sep 2013 14:20:27 -0300
Message-Id: <1380129628-16808-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380129628-16808-1-git-send-email-acme@infradead.org>
References: <1380129628-16808-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

In machine__create_modules() the 'path' char array was used in a call to
symbol__restricted_filename() without always being populated.

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
[ Split patch removing unrelated conversion of sprintf to snprintf to perf/core ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 933d14f..6188d28 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -792,7 +792,7 @@ static int machine__create_modules(struct machine *machine)
 		modules = path;
 	}
 
-	if (symbol__restricted_filename(path, "/proc/modules"))
+	if (symbol__restricted_filename(modules, "/proc/modules"))
 		return -1;
 
 	file = fopen(modules, "r");
-- 
1.8.1.4

