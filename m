Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaIQVZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:57968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbaIQVY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:24:59 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/20] perf tools: Allow to specify lib compile variable for spec usage
Date: Wed, 17 Sep 2014 18:24:09 -0300
Message-Id: <1410989063-14207-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

We need a way to specify $(lib) part of the installation path for
traceevent plugin libraries. Currently we use 'lib64' for x86_64 and
'lib' otherwise.

Instead of listing all possible values, this change allows the rpm spec
code to specify the correct $(lib) part based on processed architecture,
like

  $ make ... lib=%{_lib}

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1408978552-17131-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 98c9fd174e98..58f609198c6d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -653,11 +653,13 @@ else
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
1.9.3

