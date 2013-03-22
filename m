Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab3CVPxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:53:41 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59105 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516Ab3CVPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:53:40 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Changhwan Youn <chaos.youn@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: Add missing semicolons in exynos_mct.c
Date: Fri, 22 Mar 2013 08:53:07 -0700
Message-Id: <1363967587-19154-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CLOCKSOURCE_OF_DECLARE lines were added without a semicolon at the
end.  On my system this causes a compile-time error that looks like:

 .../drivers/clocksource/exynos_mct.c:557:202: warning: comparison of distinct pointer types lacks a cast [enabled by default]
 .../drivers/clocksource/exynos_mct.c:558:1: error: expected ',' or ';' before 'static'

The error didn't show up till now because there was an extra semicolon
at end of the CLOCKSOURCE_OF_DECLARE definition that was removed by
Arnd Bergmann in "clocksource: make CLOCKSOURCE_OF_DECLARE type safe"

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clocksource/exynos_mct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 203ac05..106228d 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -554,5 +554,5 @@ void __init mct_init(void)
 	exynos4_clocksource_init();
 	exynos4_clockevent_init();
 }
-CLOCKSOURCE_OF_DECLARE(exynos4210, "samsung,exynos4210-mct", mct_init)
-CLOCKSOURCE_OF_DECLARE(exynos4412, "samsung,exynos4412-mct", mct_init)
+CLOCKSOURCE_OF_DECLARE(exynos4210, "samsung,exynos4210-mct", mct_init);
+CLOCKSOURCE_OF_DECLARE(exynos4412, "samsung,exynos4412-mct", mct_init);
-- 
1.8.1.3

