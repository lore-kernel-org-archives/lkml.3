Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3GLIu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:50:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab3GLIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:50:22 -0400
Date: Fri, 12 Jul 2013 01:49:59 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-756bbc84e30b57ca1010b550ea30594fd0b0494f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de, iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, iamjoonsoo.kim@lge.com,
        tglx@linutronix.de
In-Reply-To: <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Include termios.h explicitly
Git-Commit-ID: 756bbc84e30b57ca1010b550ea30594fd0b0494f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:50:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  756bbc84e30b57ca1010b550ea30594fd0b0494f
Gitweb:     http://git.kernel.org/tip/756bbc84e30b57ca1010b550ea30594fd0b0494f
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Wed, 19 Jun 2013 10:02:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:36:05 -0300

perf tools: Include termios.h explicitly

Building perf for android fails because it can't find the definition of
struct winsize.

This definition is in termios.h, so I add this header to util.h to solve
the problem.

It is missed by commit '2c803e52' which moves get_term_dimensions() from
builtin-top.c to util.c, but missed to move termios.h header.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1371603750-15053-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7a484c9..2732fad 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -72,6 +72,7 @@
 #include "types.h"
 #include <sys/ttydefaults.h>
 #include <lk/debugfs.h>
+#include <termios.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
@@ -274,6 +275,5 @@ void dump_stack(void);
 
 extern unsigned int page_size;
 
-struct winsize;
 void get_term_dimensions(struct winsize *ws);
 #endif /* GIT_COMPAT_UTIL_H */
