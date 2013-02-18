Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3BRXIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:08:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:56660 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3BRXIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:08:16 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/oUvxWVbbokmz+4CaB8Se4aPBL4JbBFt7f09ACQy
	iocAcDLq3b2r1c
From: Peter Huewe <peterhuewe@gmx.de>
To: Teddy Wang <teddy.wang@siliconmotion.com.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Javier M. Mellid" <jmunhoz@igalia.com>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/sm7xxfb: Convert to SIMPLE_DEV_PM_OPS
Date: Tue, 19 Feb 2013 00:12:48 +0100
Message-Id: <1361229168-18137-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of assigning the pm_ops fields individually we can simply use
SIMPLE_DEV_PM_OPS.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 0764bbb..8add64b 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -1006,15 +1006,7 @@ static int smtcfb_pci_resume(struct device *device)
 	return 0;
 }
 
-static const struct dev_pm_ops sm7xx_pm_ops = {
-	.suspend = smtcfb_pci_suspend,
-	.resume = smtcfb_pci_resume,
-	.freeze = smtcfb_pci_suspend,
-	.thaw = smtcfb_pci_resume,
-	.poweroff = smtcfb_pci_suspend,
-	.restore = smtcfb_pci_resume,
-};
-
+static SIMPLE_DEV_PM_OPS(sm7xx_pm_ops, smtcfb_pci_suspend, smtcfb_pci_resume);
 #define SM7XX_PM_OPS (&sm7xx_pm_ops)
 
 #else  /* !CONFIG_PM */
-- 
1.7.8.6

