Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935722Ab3IEJql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:46:41 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48022 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935615Ab3IEJpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:45:51 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r859jc65030462, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <micky_ching@realsil.com.cn>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH] mfd: rtsx: Modify rts5249_optimize_phy
Date: Thu, 5 Sep 2013 17:45:38 +0800
Message-ID: <1378374338-11455-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

In some platforms, specially Thinkpad series, rts5249 won't be
initialized properly. So we need adjust some phy parameters to
improve the compatibility issue.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rts5249.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 3b835f5..e3c6dc1 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -130,13 +130,34 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;
 
-	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFE46);
+	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFC6C);
 	if (err < 0)
 		return err;
 
 	msleep(1);
 
-	return rtsx_pci_write_phy_register(pcr, PHY_BPCR, 0x05C0);
+	err = rtsx_pci_write_phy_register(pcr, PHY_BPCR, 0x05C0);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_PCR, 0xBA42);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RCR2, 0xC56A);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_FLD4, 0x78EB);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RDR, 0x4000);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_RCR1, 0x011F);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, PHY_FLD3, 0x78E4);
+	if (err < 0)
+		return err;
+	return rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4FE4);
 }
 
 static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
-- 
1.7.9.5

