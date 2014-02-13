Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaBMVQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:16:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55901 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaBMVQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:16:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf trace: Add fallback definition of EFD_SEMAPHORE
Date: Thu, 13 Feb 2014 18:16:00 -0300
Message-Id: <1392326161-30579-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392326161-30579-1-git-send-email-acme@infradead.org>
References: <1392326161-30579-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

glibc 2.17 is missing this on sparc, despite the fact that it's not
architecture-specific.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 49af9e93adfa ('perf trace: Beautify eventfd2 'flags' arg')
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1391648435.3003.100.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 896f27047ed6..619d11c47a91 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -37,6 +37,10 @@
 # define MADV_UNMERGEABLE	13
 #endif
 
+#ifndef EFD_SEMAPHORE
+# define EFD_SEMAPHORE		1
+#endif
+
 struct tp_field {
 	int offset;
 	union {
-- 
1.8.1.4

