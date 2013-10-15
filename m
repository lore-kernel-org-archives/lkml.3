Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3JOFlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:41:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab3JOF3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:35 -0400
Date: Mon, 14 Oct 2013 22:28:59 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e2137086be7bc52893a790292635cfafc475b693@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add missing -ldl for gtk build
Git-Commit-ID: e2137086be7bc52893a790292635cfafc475b693
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:29:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2137086be7bc52893a790292635cfafc475b693
Gitweb:     http://git.kernel.org/tip/e2137086be7bc52893a790292635cfafc475b693
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 26 Sep 2013 20:55:54 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:29 -0300

perf tools: Add missing -ldl for gtk build

If we build perf with NO_LIBPYTHON=1 NO_LIBPERL=1 the '-ldl' is not
added to libs build fails if we have gtk2 code in, because it depends on
it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1380221754-29865-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index cf6ad5d..29ad7d6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -382,6 +382,7 @@ ifndef NO_GTK2
     CFLAGS += -DHAVE_GTK2_SUPPORT
     GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    EXTLIBS += -ldl
   endif
 endif
 
