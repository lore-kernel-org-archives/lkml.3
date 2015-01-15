Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbbAOLT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:19:56 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50073 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbAOLTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:19:45 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0FBJSr8002332, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 06/10] mfd: rtsx: update phy register
Date: Thu, 15 Jan 2015 19:19:03 +0800
Message-ID: <38141c346f29fcf48b4dc168c1841c8732c70b4c.1421320541.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421320541.git.micky_ching@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

update phy register value and using direct value instead of macros.
It is much easier to debug using constant value than a lot of macros.
We usually need compare the value directly to check the configure.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rts5249.c | 46 ++++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 2fe2854..00208d1 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -132,57 +132,39 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 	if (err < 0)
 		return err;
 
-	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
-			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
-			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
-			PHY_REG_REV_RX_PWST | PHY_REG_REV_CLKREQ_DLY_TIMER_1_0 |
-			PHY_REG_REV_STOP_CLKRD | PHY_REG_REV_STOP_CLKWR);
+	err = rtsx_pci_write_phy_register(pcr, 0x19, 0xFE6C);
 	if (err < 0)
 		return err;
 
 	msleep(1);
 
-	err = rtsx_pci_write_phy_register(pcr, PHY_BPCR,
-			PHY_BPCR_IBRXSEL | PHY_BPCR_IBTXSEL |
-			PHY_BPCR_IB_FILTER | PHY_BPCR_CMIRROR_EN);
+	err = rtsx_pci_write_phy_register(pcr, 0x0A, 0x05C0);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_PCR,
-			PHY_PCR_FORCE_CODE | PHY_PCR_OOBS_CALI_50 |
-			PHY_PCR_OOBS_VCM_08 | PHY_PCR_OOBS_SEN_90 |
-			PHY_PCR_RSSI_EN);
+
+	err = rtsx_pci_write_phy_register(pcr, 0x00, 0xBA43);
+	if (err < 0)
+		return err;
+	err = rtsx_pci_write_phy_register(pcr, 0x03, 0xC152);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_RCR2,
-			PHY_RCR2_EMPHASE_EN | PHY_RCR2_NADJR |
-			PHY_RCR2_CDR_CP_10 | PHY_RCR2_CDR_SR_2 |
-			PHY_RCR2_FREQSEL_12 | PHY_RCR2_CPADJEN |
-			PHY_RCR2_CDR_SC_8 | PHY_RCR2_CALIB_LATE);
+	err = rtsx_pci_write_phy_register(pcr, 0x1E, 0x78EB);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_FLD4,
-			PHY_FLD4_FLDEN_SEL | PHY_FLD4_REQ_REF |
-			PHY_FLD4_RXAMP_OFF | PHY_FLD4_REQ_ADDA |
-			PHY_FLD4_BER_COUNT | PHY_FLD4_BER_TIMER |
-			PHY_FLD4_BER_CHK_EN);
+	err = rtsx_pci_write_phy_register(pcr, 0x05, 0x4600);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_RDR, PHY_RDR_RXDSEL_1_9);
+	err = rtsx_pci_write_phy_register(pcr, 0x02, 0x041F);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_RCR1,
-			PHY_RCR1_ADP_TIME | PHY_RCR1_VCO_COARSE);
+	err = rtsx_pci_write_phy_register(pcr, 0x1D, 0x0824);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_FLD3,
-			PHY_FLD3_TIMER_4 | PHY_FLD3_TIMER_6 |
-			PHY_FLD3_RXDELINK);
+	err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FE4);
 	if (err < 0)
 		return err;
-	return rtsx_pci_write_phy_register(pcr, PHY_TUNE,
-			PHY_TUNE_TUNEREF_1_0 | PHY_TUNE_VBGSEL_1252 |
-			PHY_TUNE_SDBUS_33 | PHY_TUNE_TUNED18 |
-			PHY_TUNE_TUNED12);
+
+	return 0;
 }
 
 static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
-- 
1.9.1

