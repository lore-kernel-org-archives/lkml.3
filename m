Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbaCSNIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:08:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934083AbaCSNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:08:09 -0400
Date: Wed, 19 Mar 2014 06:07:47 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b9ce0c99d820b7680fdb4dc39bc7b5ff79d6b5b0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1395124359-11744-2-git-send-email-namhyung@kernel.org>
References: <1395124359-11744-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Use ui__has_annotation()
Git-Commit-ID: b9ce0c99d820b7680fdb4dc39bc7b5ff79d6b5b0
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

Commit-ID:  b9ce0c99d820b7680fdb4dc39bc7b5ff79d6b5b0
Gitweb:     http://git.kernel.org/tip/b9ce0c99d820b7680fdb4dc39bc7b5ff79d6b5b0
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 18 Mar 2014 15:32:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:02 -0300

perf report: Use ui__has_annotation()

Since we introduced the ui__has_annotation() for that, don't open code
it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1395124359-11744-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a74059f..c8f2113 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -928,7 +928,7 @@ repeat:
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser == 1 && sort__has_sym) {
+	if (ui__has_annotation()) {
 		symbol_conf.priv_size = sizeof(struct annotation);
 		machines__set_symbol_filter(&session->machines,
 					    symbol__annotate_init);
