Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaAWRES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:04:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaAWREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:04:16 -0500
Date: Thu, 23 Jan 2014 09:03:47 -0800
From: tip-bot for Baruch Siach <tipbot@zytor.com>
Message-ID: <tip-3a46817f674389d5fb2f4dce19fbc73ebd1976bb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, baruch@tkos.co.il, jcmvbkbc@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        baruch@tkos.co.il, jcmvbkbc@gmail.com, tglx@linutronix.de
In-Reply-To: <aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il>
References: <aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Add support for the xtensa architecture
Git-Commit-ID: 3a46817f674389d5fb2f4dce19fbc73ebd1976bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:03:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a46817f674389d5fb2f4dce19fbc73ebd1976bb
Gitweb:     http://git.kernel.org/tip/3a46817f674389d5fb2f4dce19fbc73ebd1976bb
Author:     Baruch Siach <baruch@tkos.co.il>
AuthorDate: Mon, 13 Jan 2014 12:27:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:08 -0300

perf tools: Add support for the xtensa architecture

Tested using kernel tracepoints on a QEMU simulated environment.

Kernel support for perf depends on the patch "xtensa: enable
HAVE_PERF_EVENTS", which is scheduled for v3.14.

Hardware performance counters are not supported under xtensa yet.

Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-xtensa@linux-xtensa.org
Link: http://lkml.kernel.org/r/aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 3c2f213..7daa806 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -132,6 +132,13 @@
 #define CPUINFO_PROC	"CPU"
 #endif
 
+#ifdef __xtensa__
+#define mb()		asm volatile("memw" ::: "memory")
+#define wmb()		asm volatile("memw" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"core ID"
+#endif
+
 #define barrier() asm volatile ("" ::: "memory")
 
 #ifndef cpu_relax
