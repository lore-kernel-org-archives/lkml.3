Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3J1PE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:04:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3J1PEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:04:25 -0400
Date: Mon, 28 Oct 2013 08:03:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-vrbo1wik997ahjzl1chm3bdm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        markus@trippelsdorf.de, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        markus@trippelsdorf.de, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix up /proc/PID/maps parsing
Git-Commit-ID: 2fd869f08aec5a8e4cbf01bc3fa345c4e53342d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 28 Oct 2013 08:03:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fd869f08aec5a8e4cbf01bc3fa345c4e53342d7
Gitweb:     http://git.kernel.org/tip/2fd869f08aec5a8e4cbf01bc3fa345c4e53342d7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Oct 2013 09:38:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Oct 2013 09:38:12 -0300

perf tools: Fix up /proc/PID/maps parsing

When introducing support for MMAP2 we considered more parts of each map
representation in /proc/PID/maps, and when disabling it we forgot to
reduce the number of expected parsed/assigned entries in the sscanf
call, fix it to expect the right number of desired fields, 5.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Based-on-a-patch-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vrbo1wik997ahjzl1chm3bdm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 63df031..49096ea 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -213,7 +213,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.pgoff,
 		       execname);
 
-		if (n != 8)
+		if (n != 5)
 			continue;
 
 		if (prot[2] != 'x')
