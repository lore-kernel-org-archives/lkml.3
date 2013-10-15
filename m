Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab3JOF3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:29:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33377 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3JOF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:11 -0400
Date: Mon, 14 Oct 2013 22:28:51 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f4be904d2fa7c65e230ed4b1008ebdf5f4053ac3@git.kernel.org>
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
Subject: [tip:perf/core] perf machine: Use snprintf instead of sprintf
Git-Commit-ID: f4be904d2fa7c65e230ed4b1008ebdf5f4053ac3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:28:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4be904d2fa7c65e230ed4b1008ebdf5f4053ac3
Gitweb:     http://git.kernel.org/tip/f4be904d2fa7c65e230ed4b1008ebdf5f4053ac3
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Sun, 22 Sep 2013 13:22:09 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:27 -0300

perf machine: Use snprintf instead of sprintf

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
index 6188d28..ddf917b 100644
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
 
