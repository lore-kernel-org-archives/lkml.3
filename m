Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3JOFzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:55:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3JOFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:34 -0400
Date: Mon, 14 Oct 2013 22:12:50 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8b6eb56a9570001634df1d2c7f38e7179a357362@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Add 'autodep' functionality,
  generate feature test dependencies automatically
Git-Commit-ID: 8b6eb56a9570001634df1d2c7f38e7179a357362
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:12:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b6eb56a9570001634df1d2c7f38e7179a357362
Gitweb:     http://git.kernel.org/tip/8b6eb56a9570001634df1d2c7f38e7179a357362
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 13:51:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:29 +0200

tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically

Use GCC's -MD feature to generate a dependency file for each feature test .c file,
and include that .d file in the config/feature-checks/Makefile.

This allows us to do two things:

 - speed up feature tests
 - detect removal or changes in build dependencies - including system libraries/headers

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-Jfma8pmPnnqzpxjbs3hpgmsj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index b3f6372..4708cca 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,16 +1,20 @@
 
 FILES=test-hello
 
+CC := $(CC) -MD
+
 all: $(FILES)
 
 BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 
 ###############################
 
-test-hello: test-hello.c
+test-hello:
 	$(BUILD)
 
+-include *.d */*.d
+
 ###############################
 
 clean:
-	rm -f $(FILES)
+	rm -f $(FILES) *.d
