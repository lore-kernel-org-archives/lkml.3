Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaL0P3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:29:47 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:19332 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaL0P3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:29:44 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 27 Dec 2014 16:29:37 +0100
X-ME-IP: 109.222.86.28
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] arm: pxa: move gpio11 clock to board files
Date: Sat, 27 Dec 2014 14:55:27 +0100
Message-Id: <1419688528-760-4-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pxa25x gpio11 clock output was previously selected on its pin by the
clock enabling, toggling the pin function.

As we transition to common clock framework, the pin function is moved to
board file for the 2 users, ie. lubbock and eseries.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/eseries.c | 5 ++++-
 arch/arm/mach-pxa/lubbock.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
index cfb8641..d8fc9a3 100644
--- a/arch/arm/mach-pxa/eseries.c
+++ b/arch/arm/mach-pxa/eseries.c
@@ -683,7 +683,7 @@ static unsigned long e750_pin_config[] __initdata = {
 	/* PC Card */
 	GPIO8_GPIO,   /* CD0 */
 	GPIO44_GPIO,  /* CD1 */
-	GPIO11_GPIO,  /* IRQ0 */
+	/* GPIO11_GPIO,  IRQ0 */
 	GPIO6_GPIO,   /* IRQ1 */
 	GPIO27_GPIO,  /* RST0 */
 	GPIO24_GPIO,  /* RST1 */
@@ -778,6 +778,9 @@ static unsigned long e800_pin_config[] __initdata = {
 	GPIO29_AC97_SDATA_IN_0,
 	GPIO30_AC97_SDATA_OUT,
 	GPIO31_AC97_SYNC,
+
+	/* tc6393xb */
+	GPIO11_3_6MHz,
 };
 
 static struct w100_gen_regs e800_lcd_regs = {
diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index d8a1be6..b742708 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -101,6 +101,9 @@ static unsigned long lubbock_pin_config[] __initdata = {
 	GPIO6_MMC_CLK,
 	GPIO8_MMC_CS0,
 
+	/* SA1111 chip */
+	GPIO11_3_6MHz,
+
 	/* wakeup */
 	GPIO1_GPIO | WAKEUP_ON_EDGE_RISE,
 };
-- 
2.1.0

