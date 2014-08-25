Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaHYO4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbaHYO4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:56:09 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Allow to specify lib compile variable for spec usage
Date: Mon, 25 Aug 2014 16:55:52 +0200
Message-Id: <1408978552-17131-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a way to specify $(lib) part of the installation
path for traceevent plugin libraries. Currently we use
'lib64' for x86_64 and 'lib' otherwise.

Instead of listing all possible values, this change allows
the rpm spec code to specify the correct $(lib) part based
on processed architecture, like

  $ make ... lib=%{_lib}

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/config/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 75d4c237b03d..eaf36dafb482 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -651,11 +651,13 @@ else
 sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
+ifndef lib
 ifeq ($(IS_X86_64),1)
 lib = lib64
 else
 lib = lib
 endif
+endif # lib
 libdir = $(prefix)/$(lib)
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
-- 
1.8.3.1

