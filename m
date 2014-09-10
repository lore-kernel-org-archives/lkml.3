Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaIJSbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:31:35 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:41496 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaIJSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:31:32 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH] Documentation: support glibc versions without htole macros
Date: Wed, 10 Sep 2014 14:31:01 -0400
Message-Id: <1410373861-5968-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc 2.9 introduced the htole<16/32/64> macros, add them to
tools/include to support older versions of glibc.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/arm/SH-Mobile/Makefile |  2 +-
 Documentation/arm/SH-Mobile/vrl4.c   |  1 +
 Documentation/mic/mpssd/Makefile     |  2 +-
 Documentation/mic/mpssd/mpssd.c      |  1 +
 tools/include/tools/endian.h         | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 36 insertions(+), 2 deletions(-)
 create mode 100644 tools/include/tools/endian.h

diff --git a/Documentation/arm/SH-Mobile/Makefile b/Documentation/arm/SH-Mobile/Makefile
index ac8075d..bca8a7e 100644
--- a/Documentation/arm/SH-Mobile/Makefile
+++ b/Documentation/arm/SH-Mobile/Makefile
@@ -4,4 +4,4 @@ hostprogs-y := vrl4
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_vrl4.o += -I$(objtree)/usr/include
+HOSTCFLAGS_vrl4.o += -I$(objtree)/usr/include -I$(srctree)/tools/include
diff --git a/Documentation/arm/SH-Mobile/vrl4.c b/Documentation/arm/SH-Mobile/vrl4.c
index 4cbbba5..f4cd8ad 100644
--- a/Documentation/arm/SH-Mobile/vrl4.c
+++ b/Documentation/arm/SH-Mobile/vrl4.c
@@ -34,6 +34,7 @@
 #include <stdint.h>
 #include <stdio.h>
 #include <errno.h>
+#include <tools/endian.h>
 
 struct hdr {
 	uint32_t magic1;
diff --git a/Documentation/mic/mpssd/Makefile b/Documentation/mic/mpssd/Makefile
index aaa89d1..505d84f 100644
--- a/Documentation/mic/mpssd/Makefile
+++ b/Documentation/mic/mpssd/Makefile
@@ -6,7 +6,7 @@ mpssd-objs := mpssd.o sysfs.o
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_mpssd.o += -I$(objtree)/usr/include
+HOSTCFLAGS_mpssd.o += -I$(objtree)/usr/include -I$(srctree)/tools/include
 
 ifdef DEBUG
 HOSTCFLAGS += -DDEBUG=$(DEBUG)
diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 24203dd..3c5c379 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -41,6 +41,7 @@
 #include "mpssd.h"
 #include <linux/mic_ioctl.h>
 #include <linux/mic_common.h>
+#include <tools/endian.h>
 
 static void init_mic(struct mic_info *mic);
 
diff --git a/tools/include/tools/endian.h b/tools/include/tools/endian.h
new file mode 100644
index 0000000..5d42e20
--- /dev/null
+++ b/tools/include/tools/endian.h
@@ -0,0 +1,32 @@
+#ifndef _TOOLS_ENDIAN_H
+#define _TOOLS_ENDIAN_H
+
+#include <byteswap.h>
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+
+#ifndef htole16
+#define htole16(x) (x)
+#endif
+#ifndef htole32
+#define htole32(x) (x)
+#endif
+#ifndef htole64
+#define htole64(x) (x)
+#endif
+
+#else /* __BYTE_ORDER */
+
+#ifndef htole16
+#define htole16(x) __bswap_16(x)
+#endif
+#ifndef htole32
+#define htole32(x) __bswap_32(x)
+#endif
+#ifndef htole64
+#define htole64(x) __bswap_64(x)
+#endif
+
+#endif
+
+#endif /* _TOOLS_ENDIAN_H */
-- 
2.1.0

