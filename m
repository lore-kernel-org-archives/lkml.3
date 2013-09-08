Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab3IHDVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56224 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756935Ab3IHDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Hirokazu Takata" <takata@linux-m32r.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.283653768@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [113/121] m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m32r/boot/compressed/misc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/m32r/boot/compressed/misc.c b/arch/m32r/boot/compressed/misc.c
index 370d608..3147aa2 100644
--- a/arch/m32r/boot/compressed/misc.c
+++ b/arch/m32r/boot/compressed/misc.c
@@ -39,6 +39,16 @@ static void *memset(void *s, int c, size_t n)
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

