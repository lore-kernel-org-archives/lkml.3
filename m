Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914Ab3LIJCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:02:36 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33894 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755451Ab3LIJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:02:26 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: SAMSUNG: remove IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:02:15 +0100
Message-Id: <1386579735-4065-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <000801cec874$%han@samsung.com>
References: <000801cec874$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/mach-s3c24xx/dma.c         | 2 +-
 arch/arm/mach-s3c24xx/simtec-usb.c  | 3 +--
 arch/arm/mach-s3c64xx/mach-smartq.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/dma.c b/arch/arm/mach-s3c24xx/dma.c
index 4a65cba3295d..a8dafc174fe3 100644
--- a/arch/arm/mach-s3c24xx/dma.c
+++ b/arch/arm/mach-s3c24xx/dma.c
@@ -742,7 +742,7 @@ int s3c2410_dma_request(enum dma_ch channel,
 		chan->irq_claimed = 1;
 		local_irq_restore(flags);
 
-		err = request_irq(chan->irq, s3c2410_dma_irq, IRQF_DISABLED,
+		err = request_irq(chan->irq, s3c2410_dma_irq, 0,
 				  client->name, (void *)chan);
 
 		local_irq_save(flags);
diff --git a/arch/arm/mach-s3c24xx/simtec-usb.c b/arch/arm/mach-s3c24xx/simtec-usb.c
index 2ed2e32430dc..bb3eac6a7697 100644
--- a/arch/arm/mach-s3c24xx/simtec-usb.c
+++ b/arch/arm/mach-s3c24xx/simtec-usb.c
@@ -78,8 +78,7 @@ static void usb_simtec_enableoc(struct s3c2410_hcd_info *info, int on)
 
 	if (on) {
 		ret = request_irq(BAST_IRQ_USBOC, usb_simtec_ocirq,
-				  IRQF_DISABLED | IRQF_TRIGGER_RISING |
-				   IRQF_TRIGGER_FALLING,
+				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				  "USB Over-current", info);
 		if (ret != 0) {
 			printk(KERN_ERR "failed to request usb oc irq\n");
diff --git a/arch/arm/mach-s3c64xx/mach-smartq.c b/arch/arm/mach-s3c64xx/mach-smartq.c
index a6b338fd0470..08a889c141da 100644
--- a/arch/arm/mach-s3c64xx/mach-smartq.c
+++ b/arch/arm/mach-s3c64xx/mach-smartq.c
@@ -106,7 +106,7 @@ static void smartq_usb_host_enableoc(struct s3c2410_hcd_info *info, int on)
 
 	if (on) {
 		ret = request_irq(gpio_to_irq(S3C64XX_GPL(10)),
-				  smartq_usb_host_ocirq, IRQF_DISABLED |
+				  smartq_usb_host_ocirq,
 				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				  "USB host overcurrent", info);
 		if (ret != 0)
-- 
1.8.3.2

