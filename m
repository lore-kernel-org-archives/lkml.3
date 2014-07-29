Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaG2G5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:57:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34352 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaG2G5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:57:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Subject: [PATCH v2 2/2] perf tools: Default to python version 2
Date: Tue, 29 Jul 2014 15:57:20 +0900
Message-Id: <1406617040-26909-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
References: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to PEP 394 recommendation [1], it's more portable to use
python2 rather than plain python to refer python binary version 2.

Since there're distros using python3 by default like Arch, and we
don't support python3 (yet), it'd be better using python2 explicitly.

But older versions (prior to 2.7) seem not to provide python2 but just
python.  Given that it's only old version, try python2 first and then
fallback to python.  It'll ensure that it always points to python 2.x.

[1] https://www.python.org/dev/peps/pep-0394

Suggested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Tested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/config/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e05d8f99424d..60177278a357 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,8 +121,8 @@ ifdef PARSER_DEBUG
 endif
 
 ifndef NO_LIBPYTHON
-  override PYTHON := \
-    $(call get-executable-or-default,PYTHON,python)
+  PYTHON2 := $(if $(call get-executable,python2),python2,python)
+  override PYTHON := $(call get-executable-or-default,PYTHON,$(PYTHON2))
   override PYTHON_CONFIG := \
     $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 
-- 
2.0.0

