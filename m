Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3ILRrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:47:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3ILRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 21/23] m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
Date: Thu, 12 Sep 2013 10:45:17 -0700
Message-Id: <20130912174454.037622248@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit a8abbca6617e1caa2344d2d38d0a35f3e5928b79 upstream.

Fix the m32r link error:

    LD      arch/m32r/boot/compressed/vmlinux
  arch/m32r/boot/compressed/misc.o: In function `zlib_updatewindow':
  misc.c:(.text+0x190): undefined reference to `memcpy'
  misc.c:(.text+0x190): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
  make[5]: *** [arch/m32r/boot/compressed/vmlinux] Error 1

by adding our own implementation of memcpy().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m32r/boot/compressed/misc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -39,6 +39,16 @@ static void *memset(void *s, int c, size
 #endif
 
 #ifdef CONFIG_KERNEL_GZIP
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	char *d = dest;
+	const char *s = src;
+	while (n--)
+		*d++ = *s++;
+
+	return dest;
+}
+
 #define BOOT_HEAP_SIZE             0x10000
 #include "../../../../lib/decompress_inflate.c"
 #endif


