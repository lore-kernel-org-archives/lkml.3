Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaHNIro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:47:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaHNIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:47:40 -0400
Date: Thu, 14 Aug 2014 01:47:24 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6fd6c6b462c55f33c20f38051f1116dc52054d67@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-9-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Move call to symbol__init()
  after creating session
Git-Commit-ID: 6fd6c6b462c55f33c20f38051f1116dc52054d67
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

Commit-ID:  6fd6c6b462c55f33c20f38051f1116dc52054d67
Gitweb:     http://git.kernel.org/tip/6fd6c6b462c55f33c20f38051f1116dc52054d67
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:34:06 -0300

perf lock: Move call to symbol__init() after creating session

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c8122d3..d73580b 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -865,6 +865,8 @@ static int __cmd_report(bool display_info)
 		return -ENOMEM;
 	}
 
+	symbol__init();
+
 	if (!perf_session__has_traces(session, "lock record"))
 		goto out_delete;
 
@@ -974,7 +976,6 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	unsigned int i;
 	int rc = 0;
 
-	symbol__init();
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
