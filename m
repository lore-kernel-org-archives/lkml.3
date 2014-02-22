Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaBVR4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:56:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaBVRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:55:44 -0500
Date: Sat, 22 Feb 2014 09:55:20 -0800
From: tip-bot for Ben Hutchings <tipbot@zytor.com>
Message-ID: <tip-79d26a6a19ace19faabf8d8d27d3430be2e26d34@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, stable@vger.kernel.org, ben@decadent.org.uk,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        stable@vger.kernel.org, ben@decadent.org.uk, tglx@linutronix.de
In-Reply-To: <1391648435.3003.100.camel@deadeye.wl.decadent.org.uk>
References: <1391648435.3003.100.camel@deadeye.wl.decadent.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add fallback definition of EFD_SEMAPHORE
Git-Commit-ID: 79d26a6a19ace19faabf8d8d27d3430be2e26d34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79d26a6a19ace19faabf8d8d27d3430be2e26d34
Gitweb:     http://git.kernel.org/tip/79d26a6a19ace19faabf8d8d27d3430be2e26d34
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Thu, 6 Feb 2014 01:00:35 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Feb 2014 11:34:31 -0300

perf trace: Add fallback definition of EFD_SEMAPHORE

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
index 896f270..619d11c 100644
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
