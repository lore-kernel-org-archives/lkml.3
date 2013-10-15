Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3JOFRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:17:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3JOFRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:17:04 -0400
Date: Mon, 14 Oct 2013 22:16:50 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-7a10822a30060eceddda16c051086c00acb449c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf: Clean up util/include/linux/
 compiler.h
Git-Commit-ID: 7a10822a30060eceddda16c051086c00acb449c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:16:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a10822a30060eceddda16c051086c00acb449c9
Gitweb:     http://git.kernel.org/tip/7a10822a30060eceddda16c051086c00acb449c9
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 11:26:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:48 +0200

tools/perf: Clean up util/include/linux/compiler.h

Use the standard CPP style we use in the kernel:

 #ifndef foo
 # define foo bar
 #endif

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-iqyVrrHqpn0eiwenvgwrh8lf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/include/linux/compiler.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 96b919d..bef4d3d 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -2,20 +2,25 @@
 #define _PERF_LINUX_COMPILER_H_
 
 #ifndef __always_inline
-#define __always_inline	inline
+# define __always_inline	inline __attribute__((always_inline))
 #endif
+
 #define __user
+
 #ifndef __attribute_const__
-#define __attribute_const__
+# define __attribute_const__
 #endif
 
 #ifndef __maybe_unused
-#define __maybe_unused		__attribute__((unused))
+# define __maybe_unused		__attribute__((unused))
+#endif
+
+#ifndef __packed
+# define __packed		__attribute__((__packed__))
 #endif
-#define __packed	__attribute__((__packed__))
 
 #ifndef __force
-#define __force
+# define __force
 #endif
 
 #endif
