Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaEERj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbaEERgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:36:12 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sasha Levin <sasha.levin@oracle.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 01/12] tools: Unify export.h
Date: Mon,  5 May 2014 19:35:37 +0200
Message-Id: <1399311348-28152-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
References: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

So tools/ has been growing three, at a different stage of their
development export.h headers and so we should unite into one. Add
tools/include/ to the include path of virtio and liblockdep to pick the
shared header now.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: virtio-dev@lists.oasis-open.org
Cc: virtualization@lists.linux-foundation.org
Link: http://lkml.kernel.org/r/1397493185-19521-2-git-send-email-bp@alien8.de
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/include/linux/export.h              | 10 ++++++++++
 tools/lib/lockdep/Makefile                |  2 +-
 tools/lib/lockdep/uinclude/linux/export.h |  7 -------
 tools/perf/MANIFEST                       |  1 +
 tools/perf/Makefile.perf                  |  2 +-
 tools/perf/util/include/linux/export.h    |  6 ------
 tools/virtio/Makefile                     |  2 +-
 tools/virtio/linux/export.h               |  5 -----
 8 files changed, 14 insertions(+), 21 deletions(-)
 create mode 100644 tools/include/linux/export.h
 delete mode 100644 tools/lib/lockdep/uinclude/linux/export.h
 delete mode 100644 tools/perf/util/include/linux/export.h
 delete mode 100644 tools/virtio/linux/export.h

diff --git a/tools/include/linux/export.h b/tools/include/linux/export.h
new file mode 100644
index 0000000..d07e586
--- /dev/null
+++ b/tools/include/linux/export.h
@@ -0,0 +1,10 @@
+#ifndef _TOOLS_LINUX_EXPORT_H_
+#define _TOOLS_LINUX_EXPORT_H_
+
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+
+#endif
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index cb09d3f..85ef05d 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -105,7 +105,7 @@ N		=
 
 export Q VERBOSE
 
-INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)
+INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include -I../../include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
diff --git a/tools/lib/lockdep/uinclude/linux/export.h b/tools/lib/lockdep/uinclude/linux/export.h
deleted file mode 100644
index 6bdf349..0000000
--- a/tools/lib/lockdep/uinclude/linux/export.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _LIBLOCKDEP_LINUX_EXPORT_H_
-#define _LIBLOCKDEP_LINUX_EXPORT_H_
-
-#define EXPORT_SYMBOL(sym)
-#define EXPORT_SYMBOL_GPL(sym)
-
-#endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index c0c87c8..81783c2 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -7,6 +7,7 @@ tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
 tools/include/linux/compiler.h
 tools/include/linux/hash.h
+tools/include/linux/export.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 5e21aad..bd11e8a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -222,7 +222,7 @@ LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
-LIB_H += util/include/linux/export.h
+LIB_H += ../include/linux/export.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/rbtree_augmented.h
diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
deleted file mode 100644
index b43e2dc..0000000
--- a/tools/perf/util/include/linux/export.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef PERF_LINUX_MODULE_H
-#define PERF_LINUX_MODULE_H
-
-#define EXPORT_SYMBOL(name)
-
-#endif
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 3187c62..9325f46 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -3,7 +3,7 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
+CFLAGS += -g -O2 -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
diff --git a/tools/virtio/linux/export.h b/tools/virtio/linux/export.h
deleted file mode 100644
index 7311d32..0000000
--- a/tools/virtio/linux/export.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#define EXPORT_SYMBOL(sym)
-#define EXPORT_SYMBOL_GPL(sym)
-#define EXPORT_SYMBOL_GPL_FUTURE(sym)
-#define EXPORT_UNUSED_SYMBOL(sym)
-#define EXPORT_UNUSED_SYMBOL_GPL(sym)
-- 
1.8.3.1

