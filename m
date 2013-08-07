Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab3HGVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:24:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46944 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab3HGVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/47] perf tools: Fix compile of util/tsc.c
Date: Wed,  7 Aug 2013 18:10:39 -0300
Message-Id: <1375909874-22073-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.8.1.4

