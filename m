Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaDHWeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:34:13 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:64993 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaDHWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:34:12 -0400
From: Alex Elder <elder@linaro.org>
To: viresh.linux@gmail.com, shiraz.hashim@gmail.com
Cc: spear-devel@list.st.com, vk.vipin@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] ARM: spear: add __init to spear_clocksource_init()
Date: Tue,  8 Apr 2014 17:34:45 -0500
Message-Id: <1396996485-632-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get a build warning because spear_clocksource_init() calls
clocksource_mmio_init(), but it doesn't have an __init annotation.
Fix that.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-spear/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear/time.c b/arch/arm/mach-spear/time.c
index 218ba5b..c4d0931 100644
--- a/arch/arm/mach-spear/time.c
+++ b/arch/arm/mach-spear/time.c
@@ -71,7 +71,7 @@ static void clockevent_set_mode(enum clock_event_mode mode,
 static int clockevent_next_event(unsigned long evt,
 				 struct clock_event_device *clk_event_dev);
 
-static void spear_clocksource_init(void)
+static void __init spear_clocksource_init(void)
 {
 	u32 tick_rate;
 	u16 val;
-- 
1.7.9.5

