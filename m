Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3LHJus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:50:48 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:37351 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3LHJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:50:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 3/3] rtc: Disable RTC_DRV_CMOS on Atari
Date: Sun,  8 Dec 2013 10:49:57 +0100
Message-Id: <1386496197-20669-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386496197-20669-1-git-send-email-geert@linux-m68k.org>
References: <1386496197-20669-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARAnyM (emulating an Atari Falcon, which doesn't have an RTC IRQ, as the
Second Multi Function Peripheral MFP 68901 is available on Atari TT only),
rtc-cmos doesn't work well:
  - The date is of by 32 years (2045 instead of 2013):

    rtc_cmos rtc_cmos: setting system clock to 2045-12-02 10:56:17 UTC (2395824977)

  - The hwclock utility doesn't work:

    hwclock: ioctl() to /dev/rtc to turn on update interrupts failed unexpectedly, errno=5: Input/output error.

As rtc-generic works fine for the RTC part, and nvram works for the NVRAM
part, we'll continue on using that.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 007730222116..f1d7e974a700 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -626,7 +626,7 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on X86 || ARM || M32R || ATARI || PPC || MIPS || SPARC64
+	depends on X86 || ARM || M32R || PPC || MIPS || SPARC64
 	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
-- 
1.7.9.5

