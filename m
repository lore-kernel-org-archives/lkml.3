Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab3GZO1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:27:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47897 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZO1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:27:30 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] perf x86: Fix compile of util/tsc.c
Date: Fri, 26 Jul 2013 08:27:23 -0600
Message-Id: <1374848843-43127-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fedora 18, with gcc 4.6.4 compile fails with:

arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
cc1: all warnings being treated as errors
make: *** [/tmp/junk/arch/x86/util/tsc.o] Error 1
make: *** Waiting for unfinished jobs....

Fix by renaming the local variable.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/arch/x86/util/tsc.c |    8 ++++----
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
1.7.10.1

