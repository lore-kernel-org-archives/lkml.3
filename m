Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3JYKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:32:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3JYKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:32:14 -0400
Date: Fri, 25 Oct 2013 03:31:07 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8cazc2fpmk70jcbww8c0cobx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        efault@gmx.de, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Clarify the "sample parsing"
  test entry
Git-Commit-ID: 11a4d435a2d75918039540f08b259969c63b8635
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:31:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11a4d435a2d75918039540f08b259969c63b8635
Gitweb:     http://git.kernel.org/tip/11a4d435a2d75918039540f08b259969c63b8635
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 22 Oct 2013 15:24:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 09:55:37 -0300

perf test: Clarify the "sample parsing" test entry

Before:

  [root@sandy ~]# perf test -v 22
  22: Test sample parsing                                    :
  --- start ---
  sample format has changed - test needs updating
  ---- end ----
  Test sample parsing: FAILED!
  [root@sandy ~]#

After:

  [root@sandy ~]# perf test -v 22
  22: Test sample parsing                                    :
  --- start ---
  sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating
  ---- end ----
  Test sample parsing: FAILED!
  [root@sandy ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8cazc2fpmk70jcbww8c0cobx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sample-parsing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 77f598d..17d000c 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -276,7 +276,7 @@ int test__sample_parsing(void)
 	 * were added.
 	 */
 	if (PERF_SAMPLE_MAX > PERF_SAMPLE_IDENTIFIER << 1) {
-		pr_debug("sample format has changed - test needs updating\n");
+		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
 		return -1;
 	}
 
