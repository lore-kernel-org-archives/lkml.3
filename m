Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaCZWm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:42:59 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34266 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaCZWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:42:57 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Pick up libdw without explicit LIBDW_DIR
Date: Wed, 26 Mar 2014 18:44:05 -0400
Message-Id: <1395873845-466-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile logic sets FEATURE_CHECKS_CFLAGS-libdw-dwarf-unwind and
FEATURE_CHECKS_LDFLAGS-libdw-dwarf-unwind only if LIBDW_DIR is
defined. This means that under a normal setup,

  $ make NO_LIBUNWIND=1

won't automatically pick up libdw. Fix this.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/config/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c234182..0c043b0 100644
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
1.9.0.431.g014438b

