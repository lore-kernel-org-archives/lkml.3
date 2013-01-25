Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3AYLcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:32:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3AYLcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:32:08 -0500
Date: Fri, 25 Jan 2013 03:31:46 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-eec185ab603fab3b7b5021e840cf4b282c4c7e6b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356679009-32122-1-git-send-email-namhyung@kernel.org>
References: <1356679009-32122-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Include elf.h header regardless LIBELF_SUPPORT
Git-Commit-ID: eec185ab603fab3b7b5021e840cf4b282c4c7e6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:31:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eec185ab603fab3b7b5021e840cf4b282c4c7e6b
Gitweb:     http://git.kernel.org/tip/eec185ab603fab3b7b5021e840cf4b282c4c7e6b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Dec 2012 16:16:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:18 -0300

perf symbols: Include elf.h header regardless LIBELF_SUPPORT

The elf.h header file is used for NO_LIBELF build too so it should be
included anyway.  Also remove duplicated include of the header file in
symbol-*.c.  This patch fixes following build error on NO_LIBELF build:

    CC tests/hists_link.o
tests/hists_link.c: In function ‘setup_fake_machine’:
tests/hists_link.c:132:8: error: ‘STB_GLOBAL’ undeclared (first use in this function)
tests/hists_link.c:132:8: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1356679009-32122-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     | 3 ---
 tools/perf/util/symbol-minimal.c | 1 -
 tools/perf/util/symbol.h         | 2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index f63557b..54efcb5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1,6 +1,3 @@
-#include <libelf.h>
-#include <gelf.h>
-#include <elf.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 259f8f2..a7390cd 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,6 +1,5 @@
 #include "symbol.h"
 
-#include <elf.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <string.h>
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ec7b240..d97377a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -16,8 +16,8 @@
 #ifdef LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
-#include <elf.h>
 #endif
+#include <elf.h>
 
 #include "dso.h"
 
