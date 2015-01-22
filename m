Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbbAVHE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:04:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51200 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbAVHDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:03:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M73Op4021351, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 5/9] mfd: rtsx: update phy register
Date: Thu, 22 Jan 2015 15:03:12 +0800
Message-ID: <8ed856727983f0d9e526e082852018619751ebe7.1421909642.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421909642.git.micky_ching@realsil.com.cn>
References: <cover.1421909642.git.micky_ching@realsil.com.cn>
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
 drivers/mfd/rts5249.c        |  55 ++++++++++++----------
 include/linux/mfd/rtsx_pci.h | 109 ++++++++++++++++++++++---------------------
 2 files changed, 85 insertions(+), 79 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 2fe2854..d8072f6 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -132,57 +132,62 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 	if (err < 0)
 		return err;
 
-	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
-			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
-			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
-			PHY_REG_REV_RX_PWST | PHY_REG_REV_CLKREQ_DLY_TIMER_1_0 |
-			PHY_REG_REV_STOP_CLKRD | PHY_REG_REV_STOP_CLKWR);
+	err = rtsx_pci_write_phy_register(pcr, PHY_REV,
+		PHY_REV_RESV | PHY_REV_RXIDLE_LATCHED |
+		PHY_REV_P1_EN | PHY_REV_RXIDLE_EN |
+		PHY_REV_CLKREQ_TX_EN | PHY_REV_RX_PWST |
+		PHY_REV_CLKREQ_DT_1_0 | PHY_REV_STOP_CLKRD |
+		PHY_REV_STOP_CLKWR);
 	if (err < 0)
 		return err;
 
 	msleep(1);
 
 	err = rtsx_pci_write_phy_register(pcr, PHY_BPCR,
-			PHY_BPCR_IBRXSEL | PHY_BPCR_IBTXSEL |
-			PHY_BPCR_IB_FILTER | PHY_BPCR_CMIRROR_EN);
+		PHY_BPCR_IBRXSEL | PHY_BPCR_IBTXSEL |
+		PHY_BPCR_IB_FILTER | PHY_BPCR_CMIRROR_EN);
 	if (err < 0)
 		return err;
+
 	err = rtsx_pci_write_phy_register(pcr, PHY_PCR,
-			PHY_PCR_FORCE_CODE | PHY_PCR_OOBS_CALI_50 |
-			PHY_PCR_OOBS_VCM_08 | PHY_PCR_OOBS_SEN_90 |
-			PHY_PCR_RSSI_EN);
+		PHY_PCR_FORCE_CODE | PHY_PCR_OOBS_CALI_50 |
+		PHY_PCR_OOBS_VCM_08 | PHY_PCR_OOBS_SEN_90 |
+		PHY_PCR_RSSI_EN | PHY_PCR_RX10K);
 	if (err < 0)
 		return err;
+
 	err = rtsx_pci_write_phy_register(pcr, PHY_RCR2,
-			PHY_RCR2_EMPHASE_EN | PHY_RCR2_NADJR |
-			PHY_RCR2_CDR_CP_10 | PHY_RCR2_CDR_SR_2 |
-			PHY_RCR2_FREQSEL_12 | PHY_RCR2_CPADJEN |
-			PHY_RCR2_CDR_SC_8 | PHY_RCR2_CALIB_LATE);
+		PHY_RCR2_EMPHASE_EN | PHY_RCR2_NADJR |
+		PHY_RCR2_CDR_SR_2 | PHY_RCR2_FREQSEL_12 |
+		PHY_RCR2_CDR_SC_12P | PHY_RCR2_CALIB_LATE);
 	if (err < 0)
 		return err;
+
 	err = rtsx_pci_write_phy_register(pcr, PHY_FLD4,
-			PHY_FLD4_FLDEN_SEL | PHY_FLD4_REQ_REF |
-			PHY_FLD4_RXAMP_OFF | PHY_FLD4_REQ_ADDA |
-			PHY_FLD4_BER_COUNT | PHY_FLD4_BER_TIMER |
-			PHY_FLD4_BER_CHK_EN);
+		PHY_FLD4_FLDEN_SEL | PHY_FLD4_REQ_REF |
+		PHY_FLD4_RXAMP_OFF | PHY_FLD4_REQ_ADDA |
+		PHY_FLD4_BER_COUNT | PHY_FLD4_BER_TIMER |
+		PHY_FLD4_BER_CHK_EN);
 	if (err < 0)
 		return err;
-	err = rtsx_pci_write_phy_register(pcr, PHY_RDR, PHY_RDR_RXDSEL_1_9);
+	err = rtsx_pci_write_phy_register(pcr, PHY_RDR,
+		PHY_RDR_RXDSEL_1_9 | PHY_SSC_AUTO_PWD);
 	if (err < 0)
 		return err;
 	err = rtsx_pci_write_phy_register(pcr, PHY_RCR1,
-			PHY_RCR1_ADP_TIME | PHY_RCR1_VCO_COARSE);
+		PHY_RCR1_ADP_TIME_4 | PHY_RCR1_VCO_COARSE);
 	if (err < 0)
 		return err;
 	err = rtsx_pci_write_phy_register(pcr, PHY_FLD3,
-			PHY_FLD3_TIMER_4 | PHY_FLD3_TIMER_6 |
-			PHY_FLD3_RXDELINK);
+		PHY_FLD3_TIMER_4 | PHY_FLD3_TIMER_6 |
+		PHY_FLD3_RXDELINK);
 	if (err < 0)
 		return err;
+
 	return rtsx_pci_write_phy_register(pcr, PHY_TUNE,
-			PHY_TUNE_TUNEREF_1_0 | PHY_TUNE_VBGSEL_1252 |
-			PHY_TUNE_SDBUS_33 | PHY_TUNE_TUNED18 |
-			PHY_TUNE_TUNED12);
+		PHY_TUNE_TUNEREF_1_0 | PHY_TUNE_VBGSEL_1252 |
+		PHY_TUNE_SDBUS_33 | PHY_TUNE_TUNED18 |
+		PHY_TUNE_TUNED12 | PHY_TUNE_TUNEA12);
 }
 
 static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 87cff60..0103210 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -630,16 +630,47 @@
 
 /* Phy register */
 #define PHY_PCR				0x00
+#define   PHY_PCR_FORCE_CODE		0xB000
+#define   PHY_PCR_OOBS_CALI_50		0x0800
+#define   PHY_PCR_OOBS_VCM_08		0x0200
+#define   PHY_PCR_OOBS_SEN_90		0x0040
+#define   PHY_PCR_RSSI_EN		0x0002
+#define   PHY_PCR_RX10K			0x0001
+
 #define PHY_RCR0			0x01
 #define PHY_RCR1			0x02
+#define   PHY_RCR1_ADP_TIME_4		0x0400
+#define   PHY_RCR1_VCO_COARSE		0x001F
+
 #define PHY_RCR2			0x03
+#define   PHY_RCR2_EMPHASE_EN		0x8000
+#define   PHY_RCR2_NADJR		0x4000
+#define   PHY_RCR2_CDR_SR_2		0x0100
+#define   PHY_RCR2_FREQSEL_12		0x0040
+#define   PHY_RCR2_CDR_SC_12P		0x0010
+#define   PHY_RCR2_CALIB_LATE		0x0002
+
 #define PHY_RTCR			0x04
 #define PHY_RDR				0x05
+#define   PHY_RDR_RXDSEL_1_9		0x4000
+#define   PHY_SSC_AUTO_PWD		0x0600
 #define PHY_TCR0			0x06
 #define PHY_TCR1			0x07
 #define PHY_TUNE			0x08
+#define   PHY_TUNE_TUNEREF_1_0		0x4000
+#define   PHY_TUNE_VBGSEL_1252		0x0C00
+#define   PHY_TUNE_SDBUS_33		0x0200
+#define   PHY_TUNE_TUNED18		0x01C0
+#define   PHY_TUNE_TUNED12		0X0020
+#define   PHY_TUNE_TUNEA12		0x0004
+
 #define PHY_IMR				0x09
 #define PHY_BPCR			0x0A
+#define   PHY_BPCR_IBRXSEL		0x0400
+#define   PHY_BPCR_IBTXSEL		0x0100
+#define   PHY_BPCR_IB_FILTER		0x0080
+#define   PHY_BPCR_CMIRROR_EN		0x0040
+
 #define PHY_BIST			0x0B
 #define PHY_RAW_L			0x0C
 #define PHY_RAW_H			0x0D
@@ -654,12 +685,35 @@
 #define PHY_BPNR			0x16
 #define PHY_BRNR2			0x17
 #define PHY_BENR			0x18
-#define PHY_REG_REV			0x19
+#define PHY_REV				0x19
+#define   PHY_REV_RESV			0xE000
+#define   PHY_REV_RXIDLE_LATCHED	0x1000
+#define   PHY_REV_P1_EN			0x0800
+#define   PHY_REV_RXIDLE_EN		0x0400
+#define   PHY_REV_CLKREQ_TX_EN		0x0200
+#define   PHY_REV_CLKREQ_RX_EN		0x0100
+#define   PHY_REV_CLKREQ_DT_1_0		0x0040
+#define   PHY_REV_STOP_CLKRD		0x0020
+#define   PHY_REV_RX_PWST		0x0008
+#define   PHY_REV_STOP_CLKWR		0x0004
+
 #define PHY_FLD0			0x1A
 #define PHY_FLD1			0x1B
 #define PHY_FLD2			0x1C
 #define PHY_FLD3			0x1D
+#define   PHY_FLD3_TIMER_4		0x0800
+#define   PHY_FLD3_TIMER_6		0x0020
+#define   PHY_FLD3_RXDELINK		0x0004
+
 #define PHY_FLD4			0x1E
+#define   PHY_FLD4_FLDEN_SEL		0x4000
+#define   PHY_FLD4_REQ_REF		0x2000
+#define   PHY_FLD4_RXAMP_OFF		0x1000
+#define   PHY_FLD4_REQ_ADDA		0x0800
+#define   PHY_FLD4_BER_COUNT		0x00E0
+#define   PHY_FLD4_BER_TIMER		0x000A
+#define   PHY_FLD4_BER_CHK_EN		0x0001
+
 #define PHY_DUM_REG			0x1F
 
 #define LCTLR				0x80
@@ -675,59 +729,6 @@
 #define PCR_SETTING_REG2		0x814
 #define PCR_SETTING_REG3		0x747
 
-/* Phy bits */
-#define PHY_PCR_FORCE_CODE			0xB000
-#define PHY_PCR_OOBS_CALI_50			0x0800
-#define PHY_PCR_OOBS_VCM_08			0x0200
-#define PHY_PCR_OOBS_SEN_90			0x0040
-#define PHY_PCR_RSSI_EN				0x0002
-
-#define PHY_RCR1_ADP_TIME			0x0100
-#define PHY_RCR1_VCO_COARSE			0x001F
-
-#define PHY_RCR2_EMPHASE_EN			0x8000
-#define PHY_RCR2_NADJR				0x4000
-#define PHY_RCR2_CDR_CP_10			0x0400
-#define PHY_RCR2_CDR_SR_2			0x0100
-#define PHY_RCR2_FREQSEL_12			0x0040
-#define PHY_RCR2_CPADJEN			0x0020
-#define PHY_RCR2_CDR_SC_8			0x0008
-#define PHY_RCR2_CALIB_LATE			0x0002
-
-#define PHY_RDR_RXDSEL_1_9			0x4000
-
-#define PHY_TUNE_TUNEREF_1_0			0x4000
-#define PHY_TUNE_VBGSEL_1252			0x0C00
-#define PHY_TUNE_SDBUS_33			0x0200
-#define PHY_TUNE_TUNED18			0x01C0
-#define PHY_TUNE_TUNED12			0X0020
-
-#define PHY_BPCR_IBRXSEL			0x0400
-#define PHY_BPCR_IBTXSEL			0x0100
-#define PHY_BPCR_IB_FILTER			0x0080
-#define PHY_BPCR_CMIRROR_EN			0x0040
-
-#define PHY_REG_REV_RESV			0xE000
-#define PHY_REG_REV_RXIDLE_LATCHED		0x1000
-#define PHY_REG_REV_P1_EN			0x0800
-#define PHY_REG_REV_RXIDLE_EN			0x0400
-#define PHY_REG_REV_CLKREQ_DLY_TIMER_1_0	0x0040
-#define PHY_REG_REV_STOP_CLKRD			0x0020
-#define PHY_REG_REV_RX_PWST			0x0008
-#define PHY_REG_REV_STOP_CLKWR			0x0004
-
-#define PHY_FLD3_TIMER_4			0x7800
-#define PHY_FLD3_TIMER_6			0x00E0
-#define PHY_FLD3_RXDELINK			0x0004
-
-#define PHY_FLD4_FLDEN_SEL			0x4000
-#define PHY_FLD4_REQ_REF			0x2000
-#define PHY_FLD4_RXAMP_OFF			0x1000
-#define PHY_FLD4_REQ_ADDA			0x0800
-#define PHY_FLD4_BER_COUNT			0x00E0
-#define PHY_FLD4_BER_TIMER			0x000A
-#define PHY_FLD4_BER_CHK_EN			0x0001
-
 #define rtsx_pci_init_cmd(pcr)		((pcr)->ci = 0)
 
 struct rtsx_pcr;
-- 
1.9.1

