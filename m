Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3CRKvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:51:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3CRKvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:51:37 -0400
Date: Mon, 18 Mar 2013 03:50:12 -0700
From: tip-bot for Michael Ellerman <tipbot@zytor.com>
Message-ID: <tip-1e825efb571a87d039cb3fe7ca833a25f11c7cb9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, michael@ellerman.id.au, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, michael@ellerman.id.au, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate: Fix build with NO_NEWT=1
Git-Commit-ID: 1e825efb571a87d039cb3fe7ca833a25f11c7cb9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:50:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e825efb571a87d039cb3fe7ca833a25f11c7cb9
Gitweb:     http://git.kernel.org/tip/1e825efb571a87d039cb3fe7ca833a25f11c7cb9
Author:     Michael Ellerman <michael@ellerman.id.au>
AuthorDate: Tue, 26 Feb 2013 16:02:02 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 16:54:49 -0300

perf annotate: Fix build with NO_NEWT=1

Commit 18c9e5c "Make it to be able to skip unannotatable symbols" broke
the build with NO_NEWT=1:

   CC builtin-annotate.o
builtin-annotate.c: In function 'hists__find_annotations':
builtin-annotate.c:161:4: error: duplicate case value
builtin-annotate.c:154:4: error: previously used here
make: *** [builtin-annotate.o] Error 1

This is because without NEWT support K_LEFT is #defined to -1 in
utils/hist.h

Fix it by shifting the K_LEFT/K_RIGHT #defines out of the likely range
of error values.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1361854923-1814-1-git-send-email-michael@ellerman.id.au
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3862468..609a115 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -208,8 +208,8 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 	return 0;
 }
 
-#define K_LEFT -1
-#define K_RIGHT -2
+#define K_LEFT  -1000
+#define K_RIGHT -2000
 #endif
 
 #ifdef GTK2_SUPPORT
