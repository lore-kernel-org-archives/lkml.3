Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3AYLRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:17:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3AYLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:17:14 -0500
Date: Fri, 25 Jan 2013 03:16:41 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-wtgs8rd7fjwfhx72pv4la127@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Don't fail if a matching vmlinux isn'
 t found, skip that test
Git-Commit-ID: 531f67bb9ff4069b629762dd5a560e23fc4c5478
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:16:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  531f67bb9ff4069b629762dd5a560e23fc4c5478
Gitweb:     http://git.kernel.org/tip/531f67bb9ff4069b629762dd5a560e23fc4c5478
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 19 Dec 2012 11:11:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:14 -0300

perf tests: Don't fail if a matching vmlinux isn't found, skip that test

Now that Jiri introduced TEST_SKIP, don't fail on the first test, just
skip it.

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wtgs8rd7fjwfhx72pv4la127@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index 0d1cdbe..a1a8442 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -101,7 +101,8 @@ int test__vmlinux_matches_kallsyms(void)
 	 */
 	if (machine__load_vmlinux_path(&vmlinux, type,
 				       vmlinux_matches_kallsyms_filter) <= 0) {
-		pr_debug("machine__load_vmlinux_path ");
+		pr_debug("Couldn't find a vmlinux that matches the kernel running on this machine, skipping test\n");
+		err = TEST_SKIP;
 		goto out;
 	}
 
