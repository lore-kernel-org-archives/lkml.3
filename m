Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab3DGJhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:37:21 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:59961 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab3DGJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:37:19 -0400
From: chenggang qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] perf/core: Fix a warning in util/trace-event-parse.c
Date: Sun,  7 Apr 2013 17:36:58 +0800
Message-Id: <1365327418-6617-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <chenggang.qcg@taobao.com>

While I compile the perf in Red Hat Enterprise Linux Server release 5.4 (Tikanga),
I got a warning:

CC util/trace-event-parse.o
cc1: warnings being treated as errors
util/trace-event-parse.c: In function 'parse_proc_kallsyms':
util/trace-event-parse.c:232: warning: 'fmt' may be used uninitialized in this function
make: *** [util/trace-event-parse.o] Error 1

The version of gcc is:  4.1.2

The reason is that the local variable 'fmt' is not initialized before we use it.
It is fixed in this patch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/util/trace-event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 3aabcd6..630e331 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -229,7 +229,7 @@ void parse_proc_kallsyms(struct pevent *pevent,
 	char *next = NULL;
 	char *addr_str;
 	char *mod;
-	char *fmt;
+	char *fmt = NULL;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
-- 
1.5.5.6

