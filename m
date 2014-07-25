Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbaGYDOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 23:14:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48688 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbaGYDOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 23:14:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf tools: Default to python version 2
Date: Fri, 25 Jul 2014 12:14:05 +0900
Message-Id: <1406258045-25726-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406258045-25726-1-git-send-email-namhyung@kernel.org>
References: <53D135F9.1070104@tu-dresden.de>
 <1406258045-25726-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to PEP 394 recommendation [1], it's more portable to use
python2 rather than plain python to refer python binary version 2.

Since there're distros using python3 by default like Arch, and we
don't support python3 (yet), it'd be better using python2 explicitly.

[1] https://www.python.org/dev/peps/pep-0394

Suggested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e05d8f99424d..0f4b7fbc4852 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -122,7 +122,7 @@ endif
 
 ifndef NO_LIBPYTHON
   override PYTHON := \
-    $(call get-executable-or-default,PYTHON,python)
+    $(call get-executable-or-default,PYTHON,python2)
   override PYTHON_CONFIG := \
     $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 
-- 
2.0.0

