Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3HVUZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:25:50 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58356 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3HVUZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:25:47 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v2 5/5] tools/perf/perf-archive.sh: replace echo -e with printf
Date: Fri, 23 Aug 2013 00:25:25 +0400
Message-Id: <1377203125-22934-6-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
References: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-e is a non-standard echo option, echo output is
implementation-dependent when it is used. Replace echo -e
with printf as suggested by POSIX echo manual.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 tools/perf/perf-archive.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index e919306..8db9a24 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -41,7 +41,7 @@ done
 
 tar cjf $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
 rm $MANIFEST $BUILDIDS || true
-echo -e "Now please run:\n"
-echo -e "$ tar xvf $PERF_DATA.tar.bz2 -C ~/.debug\n"
+printf "Now please run:\n\n"
+printf "$ tar xvf $PERF_DATA.tar.bz2 -C ~/.debug\n\n"
 echo "wherever you need to run 'perf report' on."
 exit 0
-- 
1.7.7.6

