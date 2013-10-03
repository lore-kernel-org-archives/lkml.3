Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3JCIlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:41:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65528 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3JCIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:41:17 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2] perf tool: add example to perf-trace documentation
Date: Thu,  3 Oct 2013 14:04:13 +0530
Message-Id: <1380789253-3713-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, update the synopsis to include options.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/Documentation/perf-trace.txt | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index daccd2c..978c6c2 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -8,7 +8,7 @@ perf-trace - strace inspired tool
 SYNOPSIS
 --------
 [verse]
-'perf trace'
+'perf trace' [<options>]
 
 DESCRIPTION
 -----------
@@ -78,6 +78,33 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --input
 	Process events from a given perf data file.
 
+EXAMPLES
+--------
+
+$ perf trace -a -e mmap git status
+
+     0.791 ( 0.003 ms): 32657 mmap(addr: 0, len: 121652, prot: READ, flags: PRIVATE, fd: 3, off: 0  ) = 0xa7659000
+     0.814 ( 0.002 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7658000
+     0.820 ( 0.003 ms): 32657 mmap(addr: 0, len: 2380712, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3, off: 0) = 0xa7212000
+     0.830 ( 0.004 ms): 32657 mmap(addr: 0x7f7ca744e000, len: 32768, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 245760) = 0xa744e000
+     0.836 ( 0.002 ms): 32657 mmap(addr: 0x7f7ca7456000, len: 5032, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: 4294967295, off: 0) = 0xa7456000
+     0.862 ( 0.003 ms): 32657 mmap(addr: 0, len: 2484168, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3, off: 0) = 0xa6fb3000
+     0.870 ( 0.003 ms): 32657 mmap(addr: 0x7f7ca720c000, len: 24576, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 364544) = 0xa720c000
+     0.899 ( 0.003 ms): 32657 mmap(addr: 0, len: 2109712, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3, off: 0) = 0xa6daf000
+     0.909 ( 0.004 ms): 32657 mmap(addr: 0x7f7ca6fb1000, len: 8192, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 8192) = 0xa6fb1000
+     0.934 ( 0.002 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7657000
+     0.940 ( 0.003 ms): 32657 mmap(addr: 0, len: 3844624, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3, off: 0) = 0xa6a04000
+     0.951 ( 0.004 ms): 32657 mmap(addr: 0x7f7ca6da5000, len: 24576, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1708032) = 0xa6da5000
+     0.957 ( 0.002 ms): 32657 mmap(addr: 0x7f7ca6dab000, len: 14864, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: 4294967295, off: 0) = 0xa6dab000
+     0.977 ( 0.002 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7656000
+     0.981 ( 0.001 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7655000
+     0.985 ( 0.001 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7654000
+     0.936 ( 0.003 ms): 32655 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xb7192000
+     1.327 ( 0.004 ms): 32657 mmap(addr: 0, len: 1607632, prot: READ, flags: PRIVATE, fd: 3, off: 0 ) = 0xa74cb000
+     1.401 ( 0.002 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7676000
+     1.545 ( 0.002 ms): 32657 mmap(addr: 0, len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295, off: 0) = 0xa7676000
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
-- 
1.8.4.477.g5d89aa9

