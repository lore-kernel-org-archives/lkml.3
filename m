Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab3JOFcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3JOFb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:31:57 -0400
Date: Mon, 14 Oct 2013 22:31:43 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-cee972c0e6940ec75bab2d02f37e96d06ce143eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20131010054256.GA23716@gmail.com>
References: <20131010054256.GA23716@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix redirection printouts
Git-Commit-ID: cee972c0e6940ec75bab2d02f37e96d06ce143eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cee972c0e6940ec75bab2d02f37e96d06ce143eb
Gitweb:     http://git.kernel.org/tip/cee972c0e6940ec75bab2d02f37e96d06ce143eb
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 10 Oct 2013 07:42:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:04 -0300

perf tools: Fix redirection printouts

Fix the duplicate util/util printout Arnaldo reported:

       $ make V=1 O=/tmp/build/perf -C tools/perf/ util/srcline.o
   ...
       # Redirected target util/srcline.o =>     /tmp/build/perf/util/util/srcline.o

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20131010054256.GA23716@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2badb08..8bc6d0c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -600,11 +600,11 @@ ifneq ($(OUTPUT),)
 %.o: $(OUTPUT)%.o
 	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 util/%.o: $(OUTPUT)util/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 bench/%.o: $(OUTPUT)bench/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 tests/%.o: $(OUTPUT)tests/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 endif
 
 # These two need to be here so that when O= is not used they take precedence
