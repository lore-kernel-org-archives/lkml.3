Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3AaK73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:59:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3AaK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:59:25 -0500
Date: Thu, 31 Jan 2013 02:59:07 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-e3541ec75219819d3235f80125a1a75d798ff6e1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ellerman@au1.ibm.com, jolsa@redhat.com,
        anton@au1.ibm.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ellerman@au1.ibm.com, jolsa@redhat.com,
        anton@au1.ibm.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <20130124054439.GA31588@us.ibm.com>
References: <20130124054439.GA31588@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools, powerpc:
  Fix compile warnings in tests/attr.c
Git-Commit-ID: e3541ec75219819d3235f80125a1a75d798ff6e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:59:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3541ec75219819d3235f80125a1a75d798ff6e1
Gitweb:     http://git.kernel.org/tip/e3541ec75219819d3235f80125a1a75d798ff6e1
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Wed, 23 Jan 2013 21:44:39 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:37:14 -0300

perf tools, powerpc: Fix compile warnings in tests/attr.c

We print several '__u64' quantities using '%llu'. On powerpc, we by
default include '<asm-generic/int-l64.h> which results in __u64 being an
unsigned long. This causes compile warnings which are treated as errors
due to '-Werror'.

By defining __SANE_USERSPACE_TYPES__ we include <asm-generic/int-ll64.h>
and define __u64 as unsigned long long.

Changelog[v2]:
	[Michael Ellerman] Use __SANE_USERSPACE_TYPES__ and avoid PRIu64
	format specifier - which as Jiri Olsa pointed out, breaks on x86-64.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <ellerman@au1.ibm.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130124054439.GA31588@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index f61dd3f..bdcceb8 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -19,6 +19,11 @@
  * permissions. All the event text files are stored there.
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
 #include <stdlib.h>
 #include <stdio.h>
 #include <inttypes.h>
