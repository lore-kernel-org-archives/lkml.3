Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaDTK2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 06:28:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbaDTK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 06:28:14 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Disable libdw unwind for all but x86 arch
Date: Sun, 20 Apr 2014 12:00:06 +0200
Message-Id: <1397988006-14158-1-git-send-email-jolsa@redhat.com>
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
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ee21fa9..19ee413 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -34,6 +34,10 @@ ifeq ($(ARCH),arm)
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
+ifneq ($(ARCH),x86)
+  NO_LIBDW_DWARF_UNWIND := 1
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
-- 
1.8.3.1

