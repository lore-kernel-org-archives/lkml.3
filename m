Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3HLKSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:18:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3HLKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:18:47 -0400
Date: Mon, 12 Aug 2013 03:18:26 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-602bab1b883090ffd125ed1253fe8ec127c048b1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1374848843-43127-1-git-send-email-dsahern@gmail.com>
References: <1374848843-43127-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix compile of util/tsc.c
Git-Commit-ID: 602bab1b883090ffd125ed1253fe8ec127c048b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:18:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  602bab1b883090ffd125ed1253fe8ec127c048b1
Gitweb:     http://git.kernel.org/tip/602bab1b883090ffd125ed1253fe8ec127c048b1
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 26 Jul 2013 08:27:23 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:24 -0300

perf tools: Fix compile of util/tsc.c

On Fedora 18, with gcc 4.6.4 compile fails with:

arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
cc1: all warnings being treated as errors
make: *** [/tmp/junk/arch/x86/util/tsc.o] Error 1
make: *** Waiting for unfinished jobs....

Fix by renaming the local variable.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/1374848843-43127-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/util/tsc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index f111744..9570c2b 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -10,11 +10,11 @@
 
 u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
 {
-	u64 time, quot, rem;
+	u64 t, quot, rem;
 
-	time = ns - tc->time_zero;
-	quot = time / tc->time_mult;
-	rem  = time % tc->time_mult;
+	t = ns - tc->time_zero;
+	quot = t / tc->time_mult;
+	rem  = t % tc->time_mult;
 	return (quot << tc->time_shift) +
 	       (rem << tc->time_shift) / tc->time_mult;
 }
