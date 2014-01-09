Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaAIOBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:01:31 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43667 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaAIOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:01:14 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/8] tools include: Define likely/unlikely in linux/compiler.h
Date: Thu,  9 Jan 2014 23:00:53 +0900
Message-Id: <1389276059-8829-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/linux/compiler.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 0135ccf2a00c..fbc6665c6d53 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -27,4 +27,12 @@
 # define __weak			__attribute__((weak))
 #endif
 
+#ifndef likely
+# define likely(x)		__builtin_expect(!!(x), 1)
+#endif
+
+#ifndef unlikely
+# define unlikely(x)		__builtin_expect(!!(x), 0)
+#endif
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
-- 
1.7.9.2

