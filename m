Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3JOKxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:53:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37702 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3JOKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:53:08 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tools: use ansi versions of asm and volatile
Date: Tue, 15 Oct 2013 16:16:26 +0530
Message-Id: <1381833986-19393-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm and volatile are provided for backward compatibility; use the ansi
versions __asm__ and __volatile__.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/tests/rdpmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index ff94886..a05be61 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -9,7 +9,7 @@
 
 #if defined(__x86_64__) || defined(__i386__)
 
-#define barrier() asm volatile("" ::: "memory")
+#define barrier() __asm__ __volatile__("" ::: "memory")
 
 static u64 rdpmc(unsigned int counter)
 {
-- 
1.8.4.477.g5d89aa9

