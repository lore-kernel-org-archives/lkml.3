Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaGUOtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:49:07 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57447 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUOtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:49:04 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Marex Vasut <marex@denx.de>,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>
Subject: [PATCH RFC 9/9] arm: imx: non-secure aliased mapping of GIC registers
Date: Mon, 21 Jul 2014 15:47:20 +0100
Message-Id: <1405954040-30399-10-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/mach-imx/mach-imx6q.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index e60456d..192d268 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -381,10 +381,21 @@ static void __init imx6q_init_late(void)
 	}
 }
 
+static struct map_desc gic_cpu_io_desc __initdata = {
+		.virtual        = 0xff000000,
+		.pfn            = __phys_to_pfn(0x00a00000),
+		.length         = SZ_1M,
+		.type           = MT_DEVICE_NS,
+};
+
 static void __init imx6q_map_io(void)
 {
 	debug_ll_io_init();
 	imx_scu_map_io();
+	/* TODO: Need to check we are running without a secure monitor before
+	 *       setting up this mapping.
+	 */
+	iotable_init(&gic_cpu_io_desc, 1);
 }
 
 static void __init imx6q_init_irq(void)
-- 
1.9.3

