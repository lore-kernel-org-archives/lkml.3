Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbaIQV11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:27:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:58213 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbaIQVZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:35 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/20] perf tools: define _DEFAULT_SOURCE for glibc_2.20
Date: Wed, 17 Sep 2014 18:24:18 -0300
Message-Id: <1410989063-14207-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

_BSD_SOURCE was deprecated in favour of _DEFAULT_SOURCE since glibc
2.20[1]. To avoid build warning on glibc2.20, _DEFAULT_SOURCE should
also be defined.

[1]: https://sourceware.org/glibc/wiki/Release/2.20

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1410487817-13403-1-git-send-email-chanho61.park@samsung.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6ad2b5e3d5bb..80bfdaa0e2a4 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,6 +39,8 @@
 
 #define _ALL_SOURCE 1
 #define _BSD_SOURCE 1
+/* glibc 2.20 deprecates _BSD_SOURCE in favour of _DEFAULT_SOURCE */
+#define _DEFAULT_SOURCE 1
 #define HAS_BOOL
 
 #include <unistd.h>
-- 
1.9.3

