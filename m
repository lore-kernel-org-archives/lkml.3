Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3LHJuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:50:22 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:42000 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3LHJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:50:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] m68k/atari: Hide RTC_PORT() macro from rtc-cmos
Date: Sun,  8 Dec 2013 10:49:56 +0100
Message-Id: <1386496197-20669-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386496197-20669-1-git-send-email-geert@linux-m68k.org>
References: <1386496197-20669-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename RTC_PORT() to ATARI_RTC_PORT(), as the rtc-cmos RTC driver uses the
presence of this macro to enable support for the second NVRAM bank, which
Atari doesn't have ("Unable to handle kernel access at virtual address
00ff8965").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/mc146818rtc.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/include/asm/mc146818rtc.h b/arch/m68k/include/asm/mc146818rtc.h
index 9f70a01f73dc..05b43bf5cdf3 100644
--- a/arch/m68k/include/asm/mc146818rtc.h
+++ b/arch/m68k/include/asm/mc146818rtc.h
@@ -10,16 +10,16 @@
 
 #include <asm/atarihw.h>
 
-#define RTC_PORT(x)	(TT_RTC_BAS + 2*(x))
+#define ATARI_RTC_PORT(x)	(TT_RTC_BAS + 2*(x))
 #define RTC_ALWAYS_BCD	0
 
 #define CMOS_READ(addr) ({ \
-atari_outb_p((addr),RTC_PORT(0)); \
-atari_inb_p(RTC_PORT(1)); \
+atari_outb_p((addr), ATARI_RTC_PORT(0)); \
+atari_inb_p(ATARI_RTC_PORT(1)); \
 })
 #define CMOS_WRITE(val, addr) ({ \
-atari_outb_p((addr),RTC_PORT(0)); \
-atari_outb_p((val),RTC_PORT(1)); \
+atari_outb_p((addr), ATARI_RTC_PORT(0)); \
+atari_outb_p((val), ATARI_RTC_PORT(1)); \
 })
 #endif /* CONFIG_ATARI */
 
-- 
1.7.9.5

