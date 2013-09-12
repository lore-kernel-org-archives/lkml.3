Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3ILR2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:28:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3ILR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 16/19] m32r: consistently use "suffix-$(...)"
Date: Thu, 12 Sep 2013 10:26:25 -0700
Message-Id: <20130912172525.925215518@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m32r/boot/compressed/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


