Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaDNOSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaDNOSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/17] perf tools: Pick up libdw without explicit LIBDW_DIR
Date: Mon, 14 Apr 2014 16:17:30 +0200
Message-Id: <1397485061-17215-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

The Makefile logic sets FEATURE_CHECKS_CFLAGS-libdw-dwarf-unwind and
FEATURE_CHECKS_LDFLAGS-libdw-dwarf-unwind only if LIBDW_DIR is
defined. This means that under a normal setup,

  $ make NO_LIBUNWIND=1

won't automatically pick up libdw. Fix this.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395873845-466-1-git-send-email-artagnon@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5a3c452..ee21fa9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -65,10 +65,9 @@ ifndef NO_LIBELF
   ifdef LIBDW_DIR
     LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
     LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-
-    FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
-    FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
   endif
+  FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
 endif
 
 # include ARCH specific config
-- 
1.8.3.1

