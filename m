Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3GSHqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:46:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935048Ab3GSHqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:46:11 -0400
Date: Fri, 19 Jul 2013 00:43:48 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ic53wabwmmgvvwve2ymv3yf7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove callchain_cursor_reset call
Git-Commit-ID: fa1531fdd7b6332aa61bcc9fda495583acba460d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:43:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa1531fdd7b6332aa61bcc9fda495583acba460d
Gitweb:     http://git.kernel.org/tip/fa1531fdd7b6332aa61bcc9fda495583acba460d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 10 Jun 2013 16:31:28 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:45:58 -0300

perf tools: Remove callchain_cursor_reset call

Removing callchain_cursor_reset call as it is called in subsequent
machine__resolve_callchain_sample function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ic53wabwmmgvvwve2ymv3yf7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..93527af 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1242,8 +1242,6 @@ int machine__resolve_callchain(struct machine *machine,
 {
 	int ret;
 
-	callchain_cursor_reset(&callchain_cursor);
-
 	ret = machine__resolve_callchain_sample(machine, thread,
 						sample->callchain, parent);
 	if (ret)
