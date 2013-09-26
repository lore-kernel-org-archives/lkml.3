Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3IZW3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:29:49 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:44831 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab3IZW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:29:47 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] i2c-designware: define i2c_dw_pci_runtime_idle only with runtime pm
Date: Fri, 27 Sep 2013 00:24:03 +0200
Message-Id: <1380234243-23787-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure i2c_dw_pci_runtime_idle() is defined only when actually used, when
CONFIG_PM_RUNTIME is defined.

This fixes the following compilation warning:

 drivers/i2c/busses/i2c-designware-pcidrv.c:188:12: warning: ‘i2c_dw_pci_runtime_idle’ defined but not used [-Wunused-function]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index f6ed06c..2b5d3a6 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -185,6 +185,7 @@ static int i2c_dw_pci_resume(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int i2c_dw_pci_runtime_idle(struct device *dev)
 {
 	int err = pm_schedule_suspend(dev, 500);
@@ -194,6 +195,7 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
 		return 0;
 	return -EBUSY;
 }
+#endif
 
 static const struct dev_pm_ops i2c_dw_pm_ops = {
 	.resume         = i2c_dw_pci_resume,
-- 
1.8.4.rc3

