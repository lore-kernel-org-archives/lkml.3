Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3CRKws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:52:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33893 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3CRKwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:52:46 -0400
Date: Mon, 18 Mar 2013 03:51:23 -0700
From: tip-bot for Michael Ellerman <tipbot@zytor.com>
Message-ID: <tip-5f7439e07822942f32b9e0a66f4a3cc9c3e29e67@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, michael@ellerman.id.au, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, michael@ellerman.id.au, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <1361854923-1814-2-git-send-email-michael@ellerman.id.au>
References: <1361854923-1814-2-git-send-email-michael@ellerman.id.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report: Fix build with NO_NEWT=1
Git-Commit-ID: 5f7439e07822942f32b9e0a66f4a3cc9c3e29e67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:51:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f7439e07822942f32b9e0a66f4a3cc9c3e29e67
Gitweb:     http://git.kernel.org/tip/5f7439e07822942f32b9e0a66f4a3cc9c3e29e67
Author:     Michael Ellerman <michael@ellerman.id.au>
AuthorDate: Tue, 26 Feb 2013 16:02:03 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 16:55:17 -0300

perf report: Fix build with NO_NEWT=1

Commit ad0de09 "Enable the runtime switching of perf data file" broke
the build with NO_NEWT=1:

    CC builtin-report.o
builtin-report.c: In function '__cmd_report':
builtin-report.c:479:15: error: 'K_SWITCH_INPUT_DATA' undeclared (first use in this function)
builtin-report.c:479:15: note: each undeclared identifier is reported only once for each function it appears in
builtin-report.c: In function 'cmd_report':
builtin-report.c:823:13: error: 'K_SWITCH_INPUT_DATA' undeclared (first use in this function)
make: *** [builtin-report.o] Error 1

Fix it by adding a dummy definition of K_SWITCH_INPUT_DATA.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1361854923-1814-2-git-send-email-michael@ellerman.id.au
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 609a115..226a4ae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -210,6 +210,7 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 
 #define K_LEFT  -1000
 #define K_RIGHT -2000
+#define K_SWITCH_INPUT_DATA -3000
 #endif
 
 #ifdef GTK2_SUPPORT
