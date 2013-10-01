Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3JAQU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:20:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9433 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3JAQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:20:43 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-a1-524af65907a2
From: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Tyrtov Vyacheslav <v.tyrtov@samsung.com>
Subject: [PATCH 5/6] ARM: EXYNOS: Minor fixes to enable EXYNOS5410 support
Date: Tue, 01 Oct 2013 20:17:06 +0400
Message-id: <1380644227-12244-6-git-send-email-v.tyrtov@samsung.com>
X-Mailer: git-send-email 1.8.1.5
In-reply-to: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7qR37yCDL59FbSYtO4Ak8W8z7IW
	84+cY7X4/+g1q8W5VysZLXoXXGWz2PT4GqvFwrYlLBaXd81hs5hxfh+Txe3LvBZLr19ksng6
	4SKbxYTpa1ksDq8AmrHu5XQWiy0/OxgtXh1sY7FY//wUo8XmTVOZLabO+MHuIOqxZt4aRo+W
	5h42jwWfr7B7/F31gtlj5fIvbB6vVs9k9bhzbQ+bx7tz59g9Ni+p93h1jcWjb8sqRo/t1+Yx
	e3zeJOexcW5oAF8Ul01Kak5mWWqRvl0CV8aBDdOYC85LVjQ0LWBvYPwk0sXIySEhYCJxufEj
	C4QtJnHh3nq2LkYuDiGBpYwSLWtbmCGcHiaJp8+2sIFUsQnoSfS9ugHWISKgILG59xkrSBGz
	wC9WiU8zTzCDJIQFvCQ23X3CBGKzCKhKXP+1gL2LkYODV8BF4tsjVohtChJH296ChTkFXCW2
	N9eAhIWAKjY+3882gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQiPm6g3HpMatD
	jAIcjEo8vBIPvYKEWBPLiitzDzFKcDArifDanwUK8aYkVlalFuXHF5XmpBYfYmTi4JRqYLR3
	rs8yMX9uff3ClVXqi2v23wx7yhvwo/vN8oxQrmmzj826KboqR/H9moXvX784/WFiZ/4lnZ2H
	733Jbk5rTNt3bZ/XrqbQ/RsuXJzLvYxXp9vr3Tm/s8Wt3j9WHjcuvFzAzF18Xq4y61XfSu/V
	4l/6rusd+drltrk1Q7ngaGs4/8W7CSczpz5XYinOSDTUYi4qTgQARFciQ3YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tarek Dakhran <t.dakhran@samsung.com>

Configure ARM_NR_BANKS as 16 for EXYNOS SoC.
Enable cci_control_port_by_index for ACE_PORT.
Add additional irqs for Exynos MCT.
Set irq base as 256 for EXYNOS5410 SoC.

Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/Kconfig                  |  2 +-
 drivers/bus/arm-cci.c             |  7 +++++++
 drivers/clocksource/exynos_mct.c  |  8 +++++++-
 drivers/irqchip/exynos-combiner.c | 12 +++++++++++-
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3f7714d..7f88896 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1080,7 +1080,7 @@ source arch/arm/mm/Kconfig
 
 config ARM_NR_BANKS
 	int
-	default 16 if ARCH_EP93XX
+	default 16 if ARCH_EP93XX || ARCH_EXYNOS
 	default 8
 
 config IWMMXT
diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index 2009266..f2f5df1 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -363,8 +363,15 @@ int notrace __cci_control_port_by_index(u32 port, bool enable)
 	 * interface (ie cci_disable_port_by_cpu(); control by general purpose
 	 * indexing is therefore disabled for ACE ports.
 	 */
+
+	/*
+	 * Using this way to enable cci_port on EXYNOS5410 SoC
+	 */
+
+#ifndef CONFIG_SOC_EXYNOS5410
 	if (ports[port].type == ACE_PORT)
 		return -EPERM;
+#endif
 
 	cci_port_control(port, enable);
 	return 0;
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 5b34768..33884d7 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -71,6 +71,12 @@ enum {
 	MCT_L1_IRQ,
 	MCT_L2_IRQ,
 	MCT_L3_IRQ,
+#ifdef CONFIG_ARM_CCI
+	MCT_L4_IRQ,
+	MCT_L5_IRQ,
+	MCT_L6_IRQ,
+	MCT_L7_IRQ,
+#endif
 	MCT_NR_IRQS,
 };
 
@@ -406,7 +412,7 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	mevt = container_of(evt, struct mct_clock_event_device, evt);
 
 	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
-	sprintf(mevt->name, "mct_tick%d", cpu);
+	snprintf(mevt->name, 10, "mct_tick%d", cpu);
 
 	evt->name = mevt->name;
 	evt->cpumask = cpumask_of(cpu);
diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index 868ed40..2e056fc 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -18,6 +18,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <asm/mach/irq.h>
+#include <plat/cpu.h>
 
 #include "irqchip.h"
 
@@ -66,6 +67,11 @@ static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_get_chip(irq);
 	unsigned int cascade_irq, combiner_irq;
 	unsigned long status;
+	if (unlikely(!chip || !chip_data)) {
+		printk_once(KERN_ALERT "%s: Chip not found for IRQ %d\n"
+				, __func__, irq);
+		return;
+	}
 
 	chained_irq_enter(chip, desc);
 
@@ -226,7 +232,11 @@ static int __init combiner_of_init(struct device_node *np,
 	 * get their IRQ from DT, remove this in order to get dynamic
 	 * allocation.
 	 */
-	irq_base = 160;
+
+	if (soc_is_exynos5410())
+		irq_base = 256;
+	else
+		irq_base = 160;
 
 	combiner_init(combiner_base, np, max_nr, irq_base);
 
-- 
1.8.1.5

