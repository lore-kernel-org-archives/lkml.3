Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbaCSNOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:14:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934035AbaCSNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:07:44 -0400
Date: Wed, 19 Mar 2014 06:07:24 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-11c9abf2270793bd1c1b8828edb4223f8010e56c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1393429527-167840-3-git-send-email-dzickus@redhat.com>
References: <1393429527-167840-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use tid in mmap/
 mmap2 events to find maps
Git-Commit-ID: 11c9abf2270793bd1c1b8828edb4223f8010e56c
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

Commit-ID:  11c9abf2270793bd1c1b8828edb4223f8010e56c
Gitweb:     http://git.kernel.org/tip/11c9abf2270793bd1c1b8828edb4223f8010e56c
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 26 Feb 2014 10:45:27 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:00 -0300

perf tools: Use tid in mmap/mmap2 events to find maps

Now that we can properly synthesize threads system-wide, make sure the
mmap and mmap2 events use tids instead of pids to locate their maps.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393429527-167840-3-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/hists_link.c | 1 +
 tools/perf/util/machine.c     | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 2b6519e..7ccbc7b 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -101,6 +101,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
 			.mmap = {
 				.header = { .misc = PERF_RECORD_MISC_USER, },
 				.pid = fake_mmap_info[i].pid,
+				.tid = fake_mmap_info[i].pid,
 				.start = fake_mmap_info[i].start,
 				.len = 0x1000ULL,
 				.pgoff = 0ULL,
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d280bf2..a53cd0b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1027,7 +1027,7 @@ int machine__process_mmap2_event(struct machine *machine,
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.pid);
+					event->mmap2.tid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1075,7 +1075,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap.pid,
-					 event->mmap.pid);
+					 event->mmap.tid);
 	if (thread == NULL)
 		goto out_problem;
 
