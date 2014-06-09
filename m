Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaFIKVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:21:25 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62049 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbaFIKVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:21:21 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Krzysztof Opasiak <k.opasiak@samsung.com>, "'Felipe Balbi'" <balbi@ti.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3] tools: ffs-test: add compatibility code for old kernels
In-Reply-To: <006601cf83bc$66197b30$324c7190$%opasiak@samsung.com>
Organization: http://mina86.com/
References: <1402045976-26580-1-git-send-email-mina86@mina86.com> <1402045976-26580-5-git-send-email-mina86@mina86.com> <006601cf83bc$66197b30$324c7190$%opasiak@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140609:linux-kernel@vger.kernel.org::NdvQ/8Rcwq5a+WwI:0000000000000000000000000000000000J8Y
X-Hashcash: 1:20:140609:linux-usb@vger.kernel.org::SS1iUDRxQzcej5Ii:0000000000000000000000000000000000000cMb
X-Hashcash: 1:20:140609:k.opasiak@samsung.com::sOsEE42SXQn6+rnD:00000000000000000000000000000000000000001T3r
X-Hashcash: 1:20:140609:k.opasiak@samsung.com::u5juzVCc9uCMzQDW:00000000000000000000000000000000000000004Ncd
X-Hashcash: 1:20:140609:balbi@ti.com::qW6q+dzDy/TXBP14:000005kP3
Date: Mon, 09 Jun 2014 12:21:15 +0200
Message-ID: <xa1tsinee63o.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ffs-test is used with a kernel prior to 3.14, which do not
support the new descriptors format, it will fail when trying to
write the descriptors.  Add a function that converts the new
descriptors to the legacy ones and use it to retry writing the
descriptors using the legacy format.

Also add “-l” flag to ffs-test which will cause the tool to
never try the new format and instead immediatelly try the
legacy one.  This should be useful to test whether parsing
of the old format still works on given 3.14+ kernel.
---
 tools/usb/ffs-test.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 100 insertions(+), 5 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 708d317..afd69ea 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -29,6 +29,7 @@
 #include <fcntl.h>
 #include <pthread.h>
 #include <stdarg.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -172,6 +173,82 @@ static const struct {
 	},
 };
 
+static size_t descs_to_legacy(void **legacy, const void *descriptors) {
+	__u32 length, flags, fs_count = 0, hs_count = 0, count;
+	const unsigned char *descs, *usb_descs;
+
+	/* Read v2 header */
+	{
+		const struct usb_functionfs_descs_head_v2 *head = descriptors;
+
+		if (le32_to_cpu(head->magic) !=
+		    FUNCTIONFS_DESCRIPTORS_MAGIC_V2)
+			return 0;
+		length = le32_to_cpu(head->length);
+		if (length <= sizeof *head)
+			return 0;
+		flags = le32_to_cpu(head->flags);
+		descs = (const void *)(head + 1);
+		length -= sizeof *head;
+	}
+
+	/* Read v2 counts */
+#define GET_LE32(ret) do {					\
+		if (length < 4)					\
+			return 0;				\
+		ret = le32_to_cpu(*(const __le32 *)descs);	\
+		descs += 4;					\
+		length -= 4;					\
+	} while (0)
+
+	if (flags & FUNCTIONFS_HAS_FS_DESC)
+		GET_LE32(fs_count);
+	if (flags & FUNCTIONFS_HAS_HS_DESC)
+		GET_LE32(hs_count);
+	if (!fs_count && !hs_count)
+		return 0;
+	if (flags & FUNCTIONFS_HAS_SS_DESC)
+		/* Legacy does not support SS so this is ignored. */
+		GET_LE32(count);
+	if (flags & ~(FUNCTIONFS_HAS_FS_DESC | FUNCTIONFS_HAS_HS_DESC |
+		      FUNCTIONFS_HAS_SS_DESC))
+		return 0;
+
+#undef GET_LE32
+
+	/*
+	 * Find the end of FS and HS USB descriptors.  SS descriptors
+	 * are ignored since legacy format does not support them.
+	 */
+	count = fs_count + hs_count;
+	usb_descs = descs;
+	do {
+		if (length < *descs)
+			return 0;
+		length -= *descs;
+		descs += *descs;
+	} while (--count);
+
+	/* Allocate legacy descriptors and copy the data. */
+	{
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+		struct usb_functionfs_descs_head *head;
+#pragma GCC diagnostic pop
+
+		length = sizeof *head + (descs - usb_descs);
+		head = malloc(length);
+		head->magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC);
+		head->length = cpu_to_le32(length);
+		head->fs_count = cpu_to_le32(fs_count);
+		head->hs_count = cpu_to_le32(hs_count);
+		memcpy(head + 1, usb_descs, descs - usb_descs);
+		*legacy = head;
+	}
+
+	return length;
+}
+
 
 #define STR_INTERFACE_ "Source/Sink"
 
@@ -491,12 +568,29 @@ ep0_consume(struct thread *ignore, const void *buf, size_t nbytes)
 	return nbytes;
 }
 
-static void ep0_init(struct thread *t)
+static void ep0_init(struct thread *t, bool legacy_descriptors)
 {
+	void *legacy;
 	ssize_t ret;
+	size_t len;
+
+	if (legacy_descriptors) {
+		info("%s: writing descriptors\n", t->filename);
+		goto legacy;
+	}
 
-	info("%s: writing descriptors\n", t->filename);
+	info("%s: writing descriptors (in v2 format)\n", t->filename);
 	ret = write(t->fd, &descriptors, sizeof descriptors);
+
+	if (ret < 0 && errno == EINVAL) {
+		warn("%s: new format rejected, trying legacy\n", t->filename);
+legacy:
+		len = descs_to_legacy(&legacy, &descriptors);
+		if (len) {
+			ret = write(t->fd, legacy, len);
+			free(legacy);
+		}
+	}
 	die_on(ret < 0, "%s: write: descriptors", t->filename);
 
 	info("%s: writing strings\n", t->filename);
@@ -507,14 +601,15 @@ static void ep0_init(struct thread *t)
 
 /******************** Main **************************************************/
 
-int main(void)
+int main(int argc, char **argv)
 {
+	bool legacy_descriptors;
 	unsigned i;
 
-	/* XXX TODO: Argument parsing missing */
+	legacy_descriptors = argc > 2 && !strcmp(argv[1], "-l");
 
 	init_thread(threads);
-	ep0_init(threads);
+	ep0_init(threads, legacy_descriptors);
 
 	for (i = 1; i < sizeof threads / sizeof *threads; ++i)
 		init_thread(threads + i);
-- 
2.0.0.526.g5318336

