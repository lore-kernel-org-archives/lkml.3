Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaAaMp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:45:26 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932146AbaAaMpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:45:25 -0500
From: Richard Weinberger <richard@nod.at>
To: thierry.reding@gmail.com
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] pwm,renesas-tpu: Add dependency on HAS_IOMEM
Date: Fri, 31 Jan 2014 13:45:18 +0100
Message-Id: <1391172318-17853-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/built-in.o: In function `tpu_probe':
drivers/pwm/pwm-renesas-tpu.c:421: undefined reference to `devm_ioremap_resource'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/pwm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 22f2f28..0b7a3c9 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -160,6 +160,7 @@ config PWM_PXA
 config PWM_RENESAS_TPU
 	tristate "Renesas TPU PWM support"
 	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  This driver exposes the Timer Pulse Unit (TPU) PWM controller found
 	  in Renesas chips through the PWM API.
-- 
1.8.1.4

