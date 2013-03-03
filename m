Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3CCTZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 14:25:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3CCTZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 14:25:52 -0500
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] perf, liblk: Fix _FORTIFY_SOURCE builds
Date: Sun,  3 Mar 2013 20:25:33 +0100
Message-Id: <1362338733-8718-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Jiri Olsa triggers the following build error:

    SUBDIR ../lib/lk/
    CC debugfs.o
In file included from /usr/include/errno.h:29:0,
                 from debugfs.c:1:
/usr/include/features.h:314:4: error: #warning _FORTIFY_SOURCE requires compiling with optimization (-O) [-Werror=cpp]

This is because enabling buffer overflow checks through _FORTIFY_SOURCE
require compiler optimizations to be enabled too. However, those are
not. Enable them by simply copying the perf optimization level. It can
be expanded later if we want to support debug builds, etc.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/lib/lk/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 8cf576f1a003..926cbf3efc7f 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -10,7 +10,7 @@ LIB_OBJS += $(OUTPUT)debugfs.o
 
 LIBFILE = liblk.a
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.8.1.3.535.ga923c31

