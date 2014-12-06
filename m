Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaLFPKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:10:52 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:3169 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbaLFPKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:10:49 -0500
Message-Id: <681c51$omkd8a@relay.skynet.be>
Date: 06 Dec 2014 16:09:36 +0100
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIUABMcg1RR9Aqz/2dsb2JhbABZgwZSWIIhtFcBj2GGEyhrFwEBAQEBfYRfIxgXUxgkE4gmAxYBCM5xDYV1jk6BSWSDA4E6BYRSA5MhgwuDEog+PIYRgUWCaTABgQKBQAECAw
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [GIT PULL REQUEST] watchdog - v3.18-rc7 Fixes
X-Antivirus: avast! (VPS 141206-0, 06/12/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
        git://www.linux-watchdog.org/linux-watchdog.git

It will fix the watchdog mask bit offset for Exynos7.

This will update the following files:

 s3c2410_wdt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

with these Changes:

commit 5476b2b77dae50c88aa6a85f21abeac38dde590f
Author: Abhilash Kesavan <a.kesavan@samsung.com>
Date:   Fri Oct 17 21:42:53 2014 +0530

    watchdog: s3c2410_wdt: Fix the mask bit offset for Exynos7

    The watchdog mask bit offset listed for Exynos7 is incorrect.
    Fix this.

    Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
    Acked-by: Naveen Krishna Chatradhi <naveenkrishna.ch@gmail.com
    Reviewd-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 8532c3e..1626dc6 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -161,7 +161,7 @@ static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
 static const struct s3c2410_wdt_variant drv_data_exynos7 = {
        .disable_reg = EXYNOS5_WDT_DISABLE_REG_OFFSET,
        .mask_reset_reg = EXYNOS5_WDT_MASK_RESET_REG_OFFSET,
-       .mask_bit = 0,
+       .mask_bit = 23,
        .rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
        .rst_stat_bit = 23,     /* A57 WDTRESET */
        .quirks = QUIRK_HAS_PMU_CONFIG | QUIRK_HAS_RST_STAT,

