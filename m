Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446Ab3LIKWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:22:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34513 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754044Ab3LIKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:22:31 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: pxa: remove IRQF_DISABLED
Date: Mon,  9 Dec 2013 11:22:22 +0100
Message-Id: <1386584542-5498-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAMPhdO_=PETk6cd8zJUnt=i5V=65ESr83QeY80Rb4P=1+5NLtw@mail.gmail.com>
References: <CAMPhdO_=PETk6cd8zJUnt=i5V=65ESr83QeY80Rb4P=1+5NLtw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP since 2.6.35 and can be removed.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
---
 arch/arm/mach-pxa/am200epd.c         | 3 +--
 arch/arm/mach-pxa/am300epd.c         | 3 +--
 arch/arm/mach-pxa/em-x270.c          | 3 +--
 arch/arm/mach-pxa/magician.c         | 2 +-
 arch/arm/mach-pxa/mainstone.c        | 2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c | 2 +-
 arch/arm/mach-pxa/sharpsl_pm.c       | 8 ++++----
 arch/arm/mach-pxa/time.c             | 2 +-
 arch/arm/mach-pxa/trizeps4.c         | 3 +--
 arch/arm/plat-pxa/dma.c              | 2 +-
 10 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
index ffa6d811aad8..12fb0f4ae359 100644
--- a/arch/arm/mach-pxa/am200epd.c
+++ b/arch/arm/mach-pxa/am200epd.c
@@ -293,8 +293,7 @@ static int am200_setup_irq(struct fb_info *info)
 	int ret;
 
 	ret = request_irq(PXA_GPIO_TO_IRQ(RDY_GPIO_PIN), am200_handle_irq,
-				IRQF_DISABLED|IRQF_TRIGGER_FALLING,
-				"AM200", info->par);
+				IRQF_TRIGGER_FALLING, "AM200", info->par);
 	if (ret)
 		dev_err(&am200_device->dev, "request_irq failed: %d\n", ret);
 
diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 3dfec1ec462d..c9f309ae88c5 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -241,8 +241,7 @@ static int am300_setup_irq(struct fb_info *info)
 	struct broadsheetfb_par *par = info->par;
 
 	ret = request_irq(PXA_GPIO_TO_IRQ(RDY_GPIO_PIN), am300_handle_irq,
-				IRQF_DISABLED|IRQF_TRIGGER_RISING,
-				"AM300", par);
+				IRQF_TRIGGER_RISING, "AM300", par);
 	if (ret)
 		dev_err(&am300_device->dev, "request_irq failed: %d\n", ret);
 
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 8eb4e23c561d..6915a9f6b3a3 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -564,8 +564,7 @@ static int em_x270_mci_init(struct device *dev,
 	}
 
 	err = request_irq(gpio_to_irq(mmc_cd), em_x270_detect_int,
-			      IRQF_DISABLED | IRQF_TRIGGER_RISING |
-			      IRQF_TRIGGER_FALLING,
+			      IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 			      "MMC card detect", data);
 	if (err) {
 		dev_err(dev, "can't request MMC card detect IRQ: %d\n", err);
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index fab30d666cc7..a9761c293028 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -634,7 +634,7 @@ static struct platform_device bq24022 = {
 static int magician_mci_init(struct device *dev,
 				irq_handler_t detect_irq, void *data)
 {
-	return request_irq(IRQ_MAGICIAN_SD, detect_irq, IRQF_DISABLED,
+	return request_irq(IRQ_MAGICIAN_SD, detect_irq, 0,
 			   "mmc card detect", data);
 }
 
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index 08ccc0718f31..78b84c0dfc79 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -401,7 +401,7 @@ static int mainstone_mci_init(struct device *dev, irq_handler_t mstone_detect_in
 	 */
 	MST_MSCWR1 &= ~MST_MSCWR1_MS_SEL;
 
-	err = request_irq(MAINSTONE_MMC_IRQ, mstone_detect_int, IRQF_DISABLED,
+	err = request_irq(MAINSTONE_MMC_IRQ, mstone_detect_int, 0,
 			     "MMC card detect", data);
 	if (err)
 		printk(KERN_ERR "mainstone_mci_init: MMC/SD: can't request MMC card detect IRQ\n");
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 9a4e470f162b..c83ae4bb356a 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -327,7 +327,7 @@ static int pcm990_mci_init(struct device *dev, irq_handler_t mci_detect_int,
 {
 	int err;
 
-	err = request_irq(PCM027_MMCDET_IRQ, mci_detect_int, IRQF_DISABLED,
+	err = request_irq(PCM027_MMCDET_IRQ, mci_detect_int,
 			     "MMC card detect", data);
 	if (err)
 		printk(KERN_ERR "pcm990_mci_init: MMC/SD: can't request MMC "
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 0a36d3585f26..051a6555cbf9 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -860,18 +860,18 @@ static int sharpsl_pm_probe(struct platform_device *pdev)
 
 	/* Register interrupt handlers */
 	irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_acin);
-	if (request_irq(irq, sharpsl_ac_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, "AC Input Detect", sharpsl_ac_isr)) {
+	if (request_irq(irq, sharpsl_ac_isr, IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, "AC Input Detect", sharpsl_ac_isr)) {
 		dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
 	}
 
 	irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_batlock);
-	if (request_irq(irq, sharpsl_fatal_isr, IRQF_DISABLED | IRQF_TRIGGER_FALLING, "Battery Cover", sharpsl_fatal_isr)) {
+	if (request_irq(irq, sharpsl_fatal_isr, IRQF_TRIGGER_FALLING, "Battery Cover", sharpsl_fatal_isr)) {
 		dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
 	}
 
 	if (sharpsl_pm.machinfo->gpio_fatal) {
 		irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_fatal);
-		if (request_irq(irq, sharpsl_fatal_isr, IRQF_DISABLED | IRQF_TRIGGER_FALLING, "Fatal Battery", sharpsl_fatal_isr)) {
+		if (request_irq(irq, sharpsl_fatal_isr, IRQF_TRIGGER_FALLING, "Fatal Battery", sharpsl_fatal_isr)) {
 			dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
 		}
 	}
@@ -879,7 +879,7 @@ static int sharpsl_pm_probe(struct platform_device *pdev)
 	if (sharpsl_pm.machinfo->batfull_irq) {
 		/* Register interrupt handler. */
 		irq = gpio_to_irq(sharpsl_pm.machinfo->gpio_batfull);
-		if (request_irq(irq, sharpsl_chrg_full_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
+		if (request_irq(irq, sharpsl_chrg_full_isr, IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
 			dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", irq);
 		}
 	}
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 9aa852a8fab9..5fdc9c4f05be 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -137,7 +137,7 @@ static struct clock_event_device ckevt_pxa_osmr0 = {
 
 static struct irqaction pxa_ost0_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= pxa_ost0_interrupt,
 	.dev_id		= &ckevt_pxa_osmr0,
 };
diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
index c58043462acd..872dcb20e757 100644
--- a/arch/arm/mach-pxa/trizeps4.c
+++ b/arch/arm/mach-pxa/trizeps4.c
@@ -332,8 +332,7 @@ static int trizeps4_mci_init(struct device *dev, irq_handler_t mci_detect_int,
 	int err;
 
 	err = request_irq(TRIZEPS4_MMC_IRQ, mci_detect_int,
-			  IRQF_DISABLED | IRQF_TRIGGER_RISING,
-			  "MMC card detect", data);
+			  IRQF_TRIGGER_RISING, "MMC card detect", data);
 	if (err) {
 		printk(KERN_ERR "trizeps4_mci_init: MMC/SD: can't request"
 						"MMC card detect IRQ\n");
diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 79ef102e3b2b..054fc5a1a11c 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -377,7 +377,7 @@ int __init pxa_init_dma(int irq, int num_ch)
 		spin_lock_init(&dma_channels[i].lock);
 	}
 
-	ret = request_irq(irq, dma_irq_handler, IRQF_DISABLED, "DMA", NULL);
+	ret = request_irq(irq, dma_irq_handler, 0, "DMA", NULL);
 	if (ret) {
 		printk (KERN_CRIT "Wow!  Can't register IRQ for DMA\n");
 		kfree(dma_channels);
-- 
1.8.3.2

