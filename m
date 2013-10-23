Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3JWHyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:54:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3JWHyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:17 -0400
Date: Wed, 23 Oct 2013 00:53:54 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-9402802a416c96b48b2bd9331c070ba2d7550b36@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382099356-4918-12-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-12-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix test_on_exit for 32-bit build
Git-Commit-ID: 9402802a416c96b48b2bd9331c070ba2d7550b36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:54:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9402802a416c96b48b2bd9331c070ba2d7550b36
Gitweb:     http://git.kernel.org/tip/9402802a416c96b48b2bd9331c070ba2d7550b36
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 18 Oct 2013 15:29:08 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 11:19:42 -0300

perf tools: Fix test_on_exit for 32-bit build

builtin-record.c:42:12: error: static declaration of 'on_exit' follows non-static declaration
In file included from util/util.h:51:0,
                 from builtin.h:4,
                 from builtin-record.c:8:
/usr/include/stdlib.h:536:12: note: previous declaration of 'on_exit' was here

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382099356-4918-12-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-checks/test-on-exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
index 8f64ed3..8e88b16 100644
--- a/tools/perf/config/feature-checks/test-on-exit.c
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <stdlib.h>
 
 static void exit_fn(int status, void *__data)
 {
