Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3CBH0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 02:26:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50691 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab3CBH0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 02:26:40 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: tps65912: Declare and use tps65912_irq_exit()
Date: Sat,  2 Mar 2013 15:25:50 +0800
Message-Id: <1362209150-4869-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up interrupts on exit, silencing a sparse warning caused by
tps65912_irq_exit() being defined but not prototyped as we go.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tps65912-core.c  |    1 +
 include/linux/mfd/tps65912.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 4658b5b..aeb8e40 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -169,6 +169,7 @@ err:
 void tps65912_device_exit(struct tps65912 *tps65912)
 {
 	mfd_remove_devices(tps65912->dev);
+	tps65912_irq_exit(tps65912);
 	kfree(tps65912);
 }
 
diff --git a/include/linux/mfd/tps65912.h b/include/linux/mfd/tps65912.h
index aaceab4..6d30903 100644
--- a/include/linux/mfd/tps65912.h
+++ b/include/linux/mfd/tps65912.h
@@ -323,5 +323,6 @@ int tps65912_device_init(struct tps65912 *tps65912);
 void tps65912_device_exit(struct tps65912 *tps65912);
 int tps65912_irq_init(struct tps65912 *tps65912, int irq,
 			struct tps65912_platform_data *pdata);
+int tps65912_irq_exit(struct tps65912 *tps65912);
 
 #endif /*  __LINUX_MFD_TPS65912_H */
-- 
1.7.10.4

