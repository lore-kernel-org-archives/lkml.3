Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaDWLby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaDWLbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:31:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf tools: Disable libdw unwind for all but x86 arch
Date: Wed, 23 Apr 2014 13:31:20 +0200
Message-Id: <1398252682-17185-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.8.3.1

