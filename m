Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab3CULqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:46:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3CULqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:46:49 -0400
Date: Thu, 21 Mar 2013 04:45:16 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9b5b7cdc5139fdcc30ee56d9cd162da60453f6d8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363326533-3310-5-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Fixup return path of open-syscall-tp-fields test case
Git-Commit-ID: 9b5b7cdc5139fdcc30ee56d9cd162da60453f6d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:45:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b5b7cdc5139fdcc30ee56d9cd162da60453f6d8
Gitweb:     http://git.kernel.org/tip/9b5b7cdc5139fdcc30ee56d9cd162da60453f6d8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 15 Mar 2013 14:48:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:12 -0300

perf tests: Fixup return path of open-syscall-tp-fields test case

Add missing evlist cleanup functions.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363326533-3310-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/open-syscall-tp-fields.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 02cb741..fc5b9fc 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -48,13 +48,13 @@ int test__syscall_open_tp_fields(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_close_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -110,6 +110,10 @@ out_ok:
 	err = 0;
 out_munmap:
 	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
