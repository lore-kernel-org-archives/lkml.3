Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966665AbaFTKm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:42:58 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36572 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965665AbaFTKm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:42:56 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 1/2] clocksource: arm_arch_timer: remove static from arch_timer_init
Date: Fri, 20 Jun 2014 12:44:11 +0200
Message-ID: <3602534.r5eJA8RqrN@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <70167479.zcs3JF0luJ@diego>
References: <70167479.zcs3JF0luJ@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exist SoCs that need some special setup procedure for their architected-timer
to work. Therefore allow arch_timer_init to be called from such specialized
clocksources.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clocksource/arm_arch_timer.c | 2 +-
 drivers/clocksource/arm_arch_timer.h | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clocksource/arm_arch_timer.h

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..55116d6 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -635,7 +635,7 @@ static void __init arch_timer_common_init(void)
 	arch_timer_arch_init();
 }
 
-static void __init arch_timer_init(struct device_node *np)
+void __init arch_timer_init(struct device_node *np)
 {
 	int i;
 
diff --git a/drivers/clocksource/arm_arch_timer.h b/drivers/clocksource/arm_arch_timer.h
new file mode 100644
index 0000000..af3974d
--- /dev/null
+++ b/drivers/clocksource/arm_arch_timer.h
@@ -0,0 +1,7 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+void __init arch_timer_init(struct device_node *np);
-- 
1.9.0


