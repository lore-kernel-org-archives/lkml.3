Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaEUT6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:58:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56807 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaEUT6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:58:38 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: ffs-test: convert to new descriptor format fixing
 compilation error
In-Reply-To: <CA+V-a8v-y_=zjPKG2ui0y1eBhk-Ri3SKuv=X2sMReit2UOY=4A@mail.gmail.com>
Date: Tue, 20 May 2014 09:38:03 -1000
Organization: http://mina86.com/
References: <CA+V-a8v-y_=zjPKG2ui0y1eBhk-Ri3SKuv=X2sMReit2UOY=4A@mail.gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140521:prabhakar.csengg@gmail.com::GQ0P3FEk2hVJUwVl:000000000000000000000000000000000002SCt
X-Hashcash: 1:20:140521:prabhakar.csengg@gmail.com::TsluduPjmzl0EpvS:0000000000000000000000000000000000080cG
X-Hashcash: 1:20:140521:balbi@ti.com::rOfRIg8by7CgK5Ac:00000POAD
Message-ID: <xa1tiooy9a51.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit [ac8dde11: “usb: gadget: f_fs: Add flags to descriptors block”]
which introduced a new descriptor format for FunctionFS removed the
usb_functionfs_descs_head structure, which is still used by ffs-test.
tool.

Convert ffs-test by converting it to use the new header format.  For
testing kernels prior to 3.14 (when the new format was introduced) and
parsing of the legacy headers in the new kernels, provide a compilation
flag to make the tool use the old format.

Finally, include information as to when the legacy FunctionFS headers
format has been deprecated (which is also when the new one has been
introduced).

Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/uapi/linux/usb/functionfs.h |  2 +-
 tools/usb/Makefile                  |  6 +++++-
 tools/usb/ffs-test.c                | 20 ++++++++++++++++++--
 3 files changed, 24 insertions(+), 4 deletions(-)

Sorry for the delay.  This has been compile-tested only since I'm
technically on vacation in the middle of Pacific and won't be able to
properly test this for quite some time.

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 2a4b4a7..ecb3a31 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -53,7 +53,7 @@ struct usb_endpoint_descriptor_no_audio {
  * structure.  Any flags that are not recognised cause the whole block to be
  * rejected with -ENOSYS.
  *
- * Legacy descriptors format:
+ * Legacy descriptors format (deprecated as of 3.14):
  *
  * | off | name      | type         | description                          |
  * |-----+-----------+--------------+--------------------------------------|
diff --git a/tools/usb/Makefile b/tools/usb/Makefile
index acf2165..d576b3b 100644
--- a/tools/usb/Makefile
+++ b/tools/usb/Makefile
@@ -6,7 +6,11 @@ WARNINGS = -Wall -Wextra
 CFLAGS = $(WARNINGS) -g -I../include
 LDFLAGS = $(PTHREAD_LIBS)
 
-all: testusb ffs-test
+all: testusb ffs-test ffs-test-legacy
+
+ffs-test-legacy: ffs-test.c
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) -DUSE_LEGACY_DESC_HEAD
+
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
 
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index fe1e66b..74b353d 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -1,5 +1,5 @@
 /*
- * ffs-test.c.c -- user mode filesystem api for usb composite function
+ * ffs-test.c -- user mode filesystem api for usb composite function
  *
  * Copyright (C) 2010 Samsung Electronics
  *                    Author: Michal Nazarewicz <mina86@mina86.com>
@@ -21,6 +21,8 @@
 
 /* $(CROSS_COMPILE)cc -Wall -Wextra -g -o ffs-test ffs-test.c -lpthread */
 
+/* Uncomment to make the tool use legacy FFS descriptor headers. */
+/* #define USE_LEGACY_DESC_HEAD */
 
 #define _BSD_SOURCE /* for endian.h */
 
@@ -106,7 +108,15 @@ static void _msg(unsigned level, const char *fmt, ...)
 /******************** Descriptors and Strings *******************************/
 
 static const struct {
-	struct usb_functionfs_descs_head header;
+	struct {
+		__le32 magic;
+		__le32 length;
+#ifndef USE_LEGACY_DESC_HEAD
+		__le32 flags;
+#endif
+		__le32 fs_count;
+		__le32 hs_count;
+	} __attribute__((packed)) header;
 	struct {
 		struct usb_interface_descriptor intf;
 		struct usb_endpoint_descriptor_no_audio sink;
@@ -114,7 +124,13 @@ static const struct {
 	} __attribute__((packed)) fs_descs, hs_descs;
 } __attribute__((packed)) descriptors = {
 	.header = {
+#ifdef USE_LEGACY_DESC_HEAD
 		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
+#else
+		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
+		.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
+				     FUNCTIONFS_HAS_HS_DESC),
+#endif
 		.length = cpu_to_le32(sizeof descriptors),
 		.fs_count = 3,
 		.hs_count = 3,
-- 
1.9.1.423.g4596e3a

