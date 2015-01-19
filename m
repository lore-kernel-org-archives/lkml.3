Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbbASInv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:43:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:17644 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbbASInu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,425,1418112000"; 
   d="scan'208";a="639230070"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com,
        linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm, tpm_crb: fix build error
Date: Mon, 19 Jan 2015 10:43:40 +0200
Message-Id: <1421657020-18418-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIMPLE_DEV_PM_OPS() was inside #ifdef CONFIG_PM_SLEEP.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_crb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index c248a35..3dd23cf 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -107,9 +107,9 @@ static int crb_resume(struct device *dev)
 
 	return rc;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, crb_resume);
-#endif
 
 static u8 crb_status(struct tpm_chip *chip)
 {
-- 
2.1.0

