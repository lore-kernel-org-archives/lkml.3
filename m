Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3GIKEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:04:35 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51129 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3GIKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:04:28 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v3 3/5] perf: squelch warnings from perl.h to compile-pass
Date: Tue,  9 Jul 2013 15:30:31 +0530
Message-Id: <1373364033-7918-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
References: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a simple

  $ make

errors out because we compile with -Werror by default, turning all
warnings into errors.  Although no warnings are emitted by our code
itself, two kinds of warnings are emitted by perl.h (perl 5.18.0):

  -Wundef and -Wswitch-default

Use #pragma statements to squelch exactly those warnings, making perf
compile-pass.

Helped-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/util/perl.h | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 tools/perf/util/perl.h

diff --git a/tools/perf/util/perl.h b/tools/perf/util/perl.h
new file mode 100644
index 0000000..862d08d
--- /dev/null
+++ b/tools/perf/util/perl.h
@@ -0,0 +1,10 @@
+#ifndef __PERF_PERL_H
+#define __PERF_PERL_H
+
+#pragma GCC diagnostic ignored "-Wundef"
+#pragma GCC diagnostic ignored "-Wswitch-default"
+#include_next <perl.h>
+#pragma GCC diagnostic error "-Wundef"
+#pragma GCC diagnostic error "-Wswitch-default"
+
+#endif
-- 
1.8.3.2.736.g869de25

