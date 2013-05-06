Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3EFInT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:43:19 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55311 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3EFInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:43:18 -0400
X-AuditID: 9c930197-b7c1fae000001854-03-51876d23abd5
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>
Subject: [PATCH -next 1/2] arm: Remove enforced Os flag for LZ4 decompressor
Date: Mon,  6 May 2013 17:42:54 +0900
Message-Id: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Os is enforced here, based on the test result of decompression time
below, slightly faster than -O2.

But further tests with UA show that using -O2 will be the right choice
especially in the case of the unaligned access enabled and the gap,
few counts in the normal decompression mode is small enough to remove -Os.

Decompression Time(counts)
     Normal    UA enabled
-Os  6717      3447
-O2  6720      2728

Note: ARM v7, Kernel 3.4
      counter freq. = 32768 HZ
      UA(Unaligned Access)
      gcc version 4.6.2

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
---
 arch/arm/boot/compressed/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 001a13a..198a4ad 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -27,9 +27,6 @@ OBJS	+= misc.o decompress.o
 ifeq ($(CONFIG_DEBUG_UNCOMPRESS),y)
 OBJS	+= debug.o
 endif
-ifeq ($(CONFIG_KERNEL_LZ4),y)
-CFLAGS_decompress.o := -Os
-endif
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
 
 # string library code (-Os is enforced to keep it much smaller)
-- 
1.8.1.1

