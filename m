Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaDWNOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:14:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaDWNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:14:12 -0400
Date: Wed, 23 Apr 2014 06:13:36 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4dc549e58b6ebf63554cd466d5ceb0e9c70ab859@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        jwboyer@fedoraproject.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jean.pihet@linaro.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, jwboyer@fedoraproject.org,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1397988006-14158-1-git-send-email-jolsa@redhat.com>
References: <1397988006-14158-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Disable libdw unwind for all but x86 arch
Git-Commit-ID: 4dc549e58b6ebf63554cd466d5ceb0e9c70ab859
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dc549e58b6ebf63554cd466d5ceb0e9c70ab859
Gitweb:     http://git.kernel.org/tip/4dc549e58b6ebf63554cd466d5ceb0e9c70ab859
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 20 Apr 2014 10:50:00 +0200
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 23 Apr 2014 13:19:18 +0200

perf tools: Disable libdw unwind for all but x86 arch

So far there's only x86 libdw unwind support merged in perf.
Disable it on all other architectures in case libdw unwind
support is detected in system.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1397988006-14158-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ee21fa9..a71fb39 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -34,6 +34,14 @@ ifeq ($(ARCH),arm)
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
+# So far there's only x86 libdw unwind support merged in perf.
+# Disable it on all other architectures in case libdw unwind
+# support is detected in system. Add supported architectures
+# to the check.
+ifneq ($(ARCH),x86)
+  NO_LIBDW_DWARF_UNWIND := 1
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
