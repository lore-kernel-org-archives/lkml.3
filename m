Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935523Ab3E3QXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:23:12 -0400
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1073 "EHLO
	smtp-out-015.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935429Ab3E3QWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:22:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 26279
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 4/6] MIPS: jz4740: Register jz4740 DMA device
Date: Thu, 30 May 2013 18:25:03 +0200
Message-Id: <1369931105-28065-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369931105-28065-1-git-send-email-lars@metafoo.de>
References: <1369931105-28065-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a device for the newly added jz4740 dmaengine driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---
No changes since v1
---
 arch/mips/include/asm/mach-jz4740/platform.h |  1 +
 arch/mips/jz4740/board-qi_lb60.c             |  1 +
 arch/mips/jz4740/platform.c                  | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/mips/include/asm/mach-jz4740/platform.h b/arch/mips/include/asm/mach-jz4740/platform.h
index 72cfebd..05988c2 100644
--- a/arch/mips/include/asm/mach-jz4740/platform.h
+++ b/arch/mips/include/asm/mach-jz4740/platform.h
@@ -32,6 +32,7 @@ extern struct platform_device jz4740_codec_device;
 extern struct platform_device jz4740_adc_device;
 extern struct platform_device jz4740_wdt_device;
 extern struct platform_device jz4740_pwm_device;
+extern struct platform_device jz4740_dma_device;
 
 void jz4740_serial_device_register(void);
 
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index be2b3de..8a5ec0e 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -438,6 +438,7 @@ static struct platform_device *jz_platform_devices[] __initdata = {
 	&jz4740_rtc_device,
 	&jz4740_adc_device,
 	&jz4740_pwm_device,
+	&jz4740_dma_device,
 	&qi_lb60_gpio_keys,
 	&qi_lb60_pwm_beeper,
 	&qi_lb60_charger_device,
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index e9348fd..35a9d8c 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -329,3 +329,24 @@ struct platform_device jz4740_pwm_device = {
 	.name = "jz4740-pwm",
 	.id   = -1,
 };
+
+/* DMA */
+static struct resource jz4740_dma_resources[] = {
+	{
+		.start	= JZ4740_DMAC_BASE_ADDR,
+		.end	= JZ4740_DMAC_BASE_ADDR + 0x400 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= JZ4740_IRQ_DMAC,
+		.end	= JZ4740_IRQ_DMAC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device jz4740_dma_device = {
+	.name	= "jz4740-dma",
+	.id	= -1,
+	.num_resources = ARRAY_SIZE(jz4740_dma_resources),
+	.resource      = jz4740_dma_resources,
+};
-- 
1.8.2.1

