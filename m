Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaASMYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:24:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55888 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaASMYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:24:47 -0500
Date: Sun, 19 Jan 2014 04:24:28 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-a7077234d240f16ead29ffeb3cc17ceada50ea5f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1389837173-3632-1-git-send-email-namhyung@kernel.org>
References: <1389837173-3632-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add 'build-test' make target
Git-Commit-ID: a7077234d240f16ead29ffeb3cc17ceada50ea5f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:24:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7077234d240f16ead29ffeb3cc17ceada50ea5f
Gitweb:     http://git.kernel.org/tip/a7077234d240f16ead29ffeb3cc17ceada50ea5f
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Jan 2014 10:52:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:26:26 -0300

perf tools: Add 'build-test' make target

Currently various build test can be performed using a Makefile named
tests/make, so one needs to remember and specify it with -f option on
command line.

Add the 'build-test' target in the main Makefile as a shortcut.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389837173-3632-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index eefb9fb..cb2e586 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -75,6 +75,12 @@ clean:
 	$(make)
 
 #
+# The build-test target is not really parallel, don't print the jobs info:
+#
+build-test:
+	@$(MAKE) -f tests/make --no-print-directory
+
+#
 # All other targets get passed through:
 #
 %:
