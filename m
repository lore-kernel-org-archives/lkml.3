Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaHXO5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:57:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaHXO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:57:16 -0400
Date: Sun, 24 Aug 2014 07:56:59 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-ad7e767a726dd7dffad45d7fcbf371094e7f2288@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, michaele@au1.ibm.com, jolsa@redhat.com,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, michaele@au1.ibm.com, jolsa@redhat.com,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <20140807072700.GA17623@us.ibm.com>
References: <20140807072700.GA17623@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools powerpc: Explicitly include util/
 debug.h
Git-Commit-ID: ad7e767a726dd7dffad45d7fcbf371094e7f2288
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

Commit-ID:  ad7e767a726dd7dffad45d7fcbf371094e7f2288
Gitweb:     http://git.kernel.org/tip/ad7e767a726dd7dffad45d7fcbf371094e7f2288
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Thu, 7 Aug 2014 00:27:00 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 20 Aug 2014 08:29:10 -0300

perf tools powerpc: Explicitly include util/debug.h

Looks like util/debug.h was indirectly included before and is no longer
included now. pr_debug is left undefined and the build of perf tool
fails on Powerpc.

Explicitly include util/debug.h.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Link: http://lkml.kernel.org/r/20140807072700.GA17623@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index a7c23a4..d73ef8b 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -15,6 +15,7 @@
 
 #include "util/thread.h"
 #include "util/callchain.h"
+#include "util/debug.h"
 
 /*
  * When saving the callchain on Power, the kernel conservatively saves
