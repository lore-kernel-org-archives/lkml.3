Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3IYScB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:32:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3IYSb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:31:57 -0400
Date: Wed, 25 Sep 2013 11:31:22 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-aa7fe3b0c499fb7987245ac40295af03546f2bd2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1379845338-29637-2-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine:
  Fix path unpopulated in machine__create_modules()
Git-Commit-ID: aa7fe3b0c499fb7987245ac40295af03546f2bd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 11:31:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa7fe3b0c499fb7987245ac40295af03546f2bd2
Gitweb:     http://git.kernel.org/tip/aa7fe3b0c499fb7987245ac40295af03546f2bd2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Sun, 22 Sep 2013 13:22:09 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Sep 2013 12:48:24 -0300

perf machine: Fix path unpopulated in machine__create_modules()

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
