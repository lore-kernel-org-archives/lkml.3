Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3IHDp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:45:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56226 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab3IHDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:08 -0400
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
Message-ID: <lsq.1378608721.806466276@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [112/121] m32r: consistently use "suffix-$(...)"
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

commit df12aef6a19bb2d69859a94936bda0e6ccaf3327 upstream.

Commit a556bec9955c ("m32r: fix arch/m32r/boot/compressed/Makefile")
changed "$(suffix_y)" to "$(suffix-y)", but didn't update any location
where "suffix_y" is set, causing:

  make[5]: *** No rule to make target `arch/m32r/boot/compressed/vmlinux.bin.', needed by `arch/m32r/boot/compressed/piggy.o'.  Stop.
  make[4]: *** [arch/m32r/boot/compressed/vmlinux] Error 2
  make[3]: *** [zImage] Error 2

Correct the other locations to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m32r/boot/compressed/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/boot/compressed/Makefile b/arch/m32r/boot/compressed/Makefile
index 177716b..01729c2 100644
--- a/arch/m32r/boot/compressed/Makefile
+++ b/arch/m32r/boot/compressed/Makefile
@@ -43,9 +43,9 @@ endif
 
 OBJCOPYFLAGS += -R .empty_zero_page
 
-suffix_$(CONFIG_KERNEL_GZIP)	= gz
-suffix_$(CONFIG_KERNEL_BZIP2)	= bz2
-suffix_$(CONFIG_KERNEL_LZMA)	= lzma
+suffix-$(CONFIG_KERNEL_GZIP)	= gz
+suffix-$(CONFIG_KERNEL_BZIP2)	= bz2
+suffix-$(CONFIG_KERNEL_LZMA)	= lzma
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y) FORCE
 	$(call if_changed,ld)

