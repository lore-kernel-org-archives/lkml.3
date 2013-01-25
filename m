Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3AYLMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:12:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3AYLMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:12:12 -0500
Date: Fri, 25 Jan 2013 03:11:59 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-h1hzfyfcdxjnuq9fin2cjwlr@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Fix PYTHONPATH for python-use test tracepoints
Git-Commit-ID: 09ecbb07a5c9fa31dc72ee8fb1c3fbd1145448dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:12:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09ecbb07a5c9fa31dc72ee8fb1c3fbd1145448dd
Gitweb:     http://git.kernel.org/tip/09ecbb07a5c9fa31dc72ee8fb1c3fbd1145448dd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Dec 2012 09:52:21 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:12 -0300

perf tests: Fix PYTHONPATH for python-use test tracepoints

If there's not OUTPUT variable defined the PYTHONPATH ends up with
/python. We need to remove the extra '/'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-h1hzfyfcdxjnuq9fin2cjwlr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3158f45..1539eb4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -958,7 +958,7 @@ $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 
 $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		-DPYTHONPATH='"$(OUTPUT)/python"' \
+		-DPYTHONPATH='"$(OUTPUT)python"' \
 		-DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
