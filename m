Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbbAVHEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:04:23 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51213 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbbAVHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:03:47 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M73WvK021387, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 9/9] mfd: rtsx: using pcr_dbg replace dev_dbg
Date: Thu, 22 Jan 2015 15:03:16 +0800
Message-ID: <99edd41dac5414f3b18df843399054c59b884ee6.1421909642.git.micky_ching@realsil.com.cn>
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

pcr_dbg is a wrapper of dev_dbg, which can save some code,
and help to enable/disable debug message static.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c  | 11 +++++------
 drivers/mfd/rts5209.c  |  4 ++--
 drivers/mfd/rts5227.c  |  4 ++--
 drivers/mfd/rts5229.c  |  4 ++--
 drivers/mfd/rts5249.c  |  4 ++--
 drivers/mfd/rtsx_pcr.c | 49 ++++++++++++++++++++++---------------------------
 6 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index fdd34c8..b3ae659 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -53,7 +53,7 @@ static void rtl8411_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	u8 reg3 = 0;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg1);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg1);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg1);
 
 	if (!rtsx_vendor_setting_valid(reg1))
 		return;
@@ -65,7 +65,7 @@ static void rtl8411_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	pcr->card_drive_sel |= rtsx_reg_to_card_drive_sel(reg1);
 
 	rtsx_pci_read_config_byte(pcr, PCR_SETTING_REG3, &reg3);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG3, reg3);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG3, reg3);
 	pcr->sd30_drive_sel_3v3 = rtl8411_reg_to_sd30_drive_sel_3v3(reg3);
 }
 
@@ -74,7 +74,7 @@ static void rtl8411b_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	u32 reg = 0;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
 
 	if (!rtsx_vendor_setting_valid(reg))
 		return;
@@ -260,9 +260,8 @@ static unsigned int rtl8411_cd_deglitch(struct rtsx_pcr *pcr)
 		rtsx_pci_write_register(pcr, CARD_PWR_CTL,
 				BPP_POWER_MASK, BPP_POWER_OFF);
 
-		dev_dbg(&(pcr->pci->dev),
-				"After CD deglitch, card_exist = 0x%x\n",
-				card_exist);
+		pcr_dbg(pcr, "After CD deglitch, card_exist = 0x%x\n",
+			card_exist);
 	}
 
 	if (card_exist & MS_EXIST) {
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index cb04174..373e253 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -38,7 +38,7 @@ static void rts5209_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	u32 reg;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
 
 	if (rts5209_vendor_setting1_valid(reg)) {
 		if (rts5209_reg_check_ms_pmos(reg))
@@ -47,7 +47,7 @@ static void rts5209_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	}
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
 
 	if (rts5209_vendor_setting2_valid(reg)) {
 		pcr->sd30_drive_sel_1v8 =
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 0c02831..ce012d7 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -63,7 +63,7 @@ static void rts5227_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	u32 reg;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
 
 	if (!rtsx_vendor_setting_valid(reg))
 		return;
@@ -74,7 +74,7 @@ static void rts5227_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	pcr->card_drive_sel |= rtsx_reg_to_card_drive_sel(reg);
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
 	pcr->sd30_drive_sel_3v3 = rtsx_reg_to_sd30_drive_sel_3v3(reg);
 	if (rtsx_reg_check_reverse_socket(reg))
 		pcr->flags |= PCR_REVERSE_SOCKET;
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index 6353f5d..ace4538 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -38,7 +38,7 @@ static void rts5229_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	u32 reg;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
 
 	if (!rtsx_vendor_setting_valid(reg))
 		return;
@@ -50,7 +50,7 @@ static void rts5229_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	pcr->card_drive_sel |= rtsx_reg_to_card_drive_sel(reg);
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
 	pcr->sd30_drive_sel_3v3 =
 		map_sd_drive(rtsx_reg_to_sd30_drive_sel_3v3(reg));
 }
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 134e03f..663d4e3 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -70,7 +70,7 @@ static void rtsx_base_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	u32 reg;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
 
 	if (!rtsx_vendor_setting_valid(reg)) {
 		pcr_dbg(pcr, "skip fetch vendor setting\n");
@@ -83,7 +83,7 @@ static void rtsx_base_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	pcr->card_drive_sel |= rtsx_reg_to_card_drive_sel(reg);
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG2, &reg);
-	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
+	pcr_dbg(pcr, "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG2, reg);
 	pcr->sd30_drive_sel_3v3 = rtsx_reg_to_sd30_drive_sel_3v3(reg);
 	if (rtsx_reg_check_reverse_socket(reg))
 		pcr->flags |= PCR_REVERSE_SOCKET;
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 681e1a6..9b37bc4 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -317,8 +317,7 @@ int rtsx_pci_send_cmd(struct rtsx_pcr *pcr, int timeout)
 	timeleft = wait_for_completion_interruptible_timeout(
 			&trans_done, msecs_to_jiffies(timeout));
 	if (timeleft <= 0) {
-		dev_dbg(&(pcr->pci->dev), "Timeout (%s %d)\n",
-				__func__, __LINE__);
+		pcr_dbg(pcr, "Timeout (%s %d)\n", __func__, __LINE__);
 		err = -ETIMEDOUT;
 		goto finish_send_cmd;
 	}
@@ -354,8 +353,7 @@ static void rtsx_pci_add_sg_tbl(struct rtsx_pcr *pcr,
 	u64 val;
 	u8 option = SG_VALID | SG_TRANS_DATA;
 
-	dev_dbg(&(pcr->pci->dev), "DMA addr: 0x%x, Len: 0x%x\n",
-			(unsigned int)addr, len);
+	pcr_dbg(pcr, "DMA addr: 0x%x, Len: 0x%x\n", (unsigned int)addr, len);
 
 	if (end)
 		option |= SG_END;
@@ -370,11 +368,11 @@ int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 {
 	int err = 0, count;
 
-	dev_dbg(&(pcr->pci->dev), "--> %s: num_sg = %d\n", __func__, num_sg);
+	pcr_dbg(pcr, "--> %s: num_sg = %d\n", __func__, num_sg);
 	count = rtsx_pci_dma_map_sg(pcr, sglist, num_sg, read);
 	if (count < 1)
 		return -EINVAL;
-	dev_dbg(&(pcr->pci->dev), "DMA mapping count: %d\n", count);
+	pcr_dbg(pcr, "DMA mapping count: %d\n", count);
 
 	err = rtsx_pci_dma_transfer(pcr, sglist, count, read, timeout);
 
@@ -448,8 +446,7 @@ int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 	timeleft = wait_for_completion_interruptible_timeout(
 			&trans_done, msecs_to_jiffies(timeout));
 	if (timeleft <= 0) {
-		dev_dbg(&(pcr->pci->dev), "Timeout (%s %d)\n",
-				__func__, __LINE__);
+		pcr_dbg(pcr, "Timeout (%s %d)\n", __func__, __LINE__);
 		err = -ETIMEDOUT;
 		goto out;
 	}
@@ -623,7 +620,7 @@ static void rtsx_pci_enable_bus_int(struct rtsx_pcr *pcr)
 	/* Enable Bus Interrupt */
 	rtsx_pci_writel(pcr, RTSX_BIER, pcr->bier);
 
-	dev_dbg(&(pcr->pci->dev), "RTSX_BIER: 0x%08x\n", pcr->bier);
+	pcr_dbg(pcr, "RTSX_BIER: 0x%08x\n", pcr->bier);
 }
 
 static inline u8 double_ssc_depth(u8 depth)
@@ -669,14 +666,13 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
 		return err;
 
 	card_clock /= 1000000;
-	dev_dbg(&(pcr->pci->dev), "Switch card clock to %dMHz\n", card_clock);
+	pcr_dbg(pcr, "Switch card clock to %dMHz\n", card_clock);
 
 	clk = card_clock;
 	if (!initial_mode && double_clk)
 		clk = card_clock * 2;
-	dev_dbg(&(pcr->pci->dev),
-			"Internal SSC clock: %dMHz (cur_clock = %d)\n",
-			clk, pcr->cur_clock);
+	pcr_dbg(pcr, "Internal SSC clock: %dMHz (cur_clock = %d)\n",
+		clk, pcr->cur_clock);
 
 	if (clk == pcr->cur_clock)
 		return 0;
@@ -705,14 +701,14 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
 		}
 		div++;
 	}
-	dev_dbg(&(pcr->pci->dev), "n = %d, div = %d\n", n, div);
+	pcr_dbg(pcr, "n = %d, div = %d\n", n, div);
 
 	ssc_depth = depth[ssc_depth];
 	if (double_clk)
 		ssc_depth = double_ssc_depth(ssc_depth);
 
 	ssc_depth = revise_ssc_depth(ssc_depth, div);
-	dev_dbg(&(pcr->pci->dev), "ssc_depth = %d\n", ssc_depth);
+	pcr_dbg(pcr, "ssc_depth = %d\n", ssc_depth);
 
 	rtsx_pci_init_cmd(pcr);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CLK_CTL,
@@ -834,13 +830,13 @@ static void rtsx_pci_card_detect(struct work_struct *work)
 	dwork = to_delayed_work(work);
 	pcr = container_of(dwork, struct rtsx_pcr, carddet_work);
 
-	dev_dbg(&(pcr->pci->dev), "--> %s\n", __func__);
+	pcr_dbg(pcr, "--> %s\n", __func__);
 
 	mutex_lock(&pcr->pcr_mutex);
 	spin_lock_irqsave(&pcr->lock, flags);
 
 	irq_status = rtsx_pci_readl(pcr, RTSX_BIPR);
-	dev_dbg(&(pcr->pci->dev), "irq_status: 0x%08x\n", irq_status);
+	pcr_dbg(pcr, "irq_status: 0x%08x\n", irq_status);
 
 	irq_status &= CARD_EXIST;
 	card_inserted = pcr->card_inserted & irq_status;
@@ -851,9 +847,8 @@ static void rtsx_pci_card_detect(struct work_struct *work)
 	spin_unlock_irqrestore(&pcr->lock, flags);
 
 	if (card_inserted || card_removed) {
-		dev_dbg(&(pcr->pci->dev),
-				"card_inserted: 0x%x, card_removed: 0x%x\n",
-				card_inserted, card_removed);
+		pcr_dbg(pcr, "card_inserted: 0x%x, card_removed: 0x%x\n",
+			card_inserted, card_removed);
 
 		if (pcr->ops->cd_deglitch)
 			card_inserted = pcr->ops->cd_deglitch(pcr);
@@ -961,7 +956,7 @@ static void rtsx_pci_idle_work(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct rtsx_pcr *pcr = container_of(dwork, struct rtsx_pcr, idle_work);
 
-	dev_dbg(&(pcr->pci->dev), "--> %s\n", __func__);
+	pcr_dbg(pcr, "--> %s\n", __func__);
 
 	mutex_lock(&pcr->pcr_mutex);
 
@@ -1129,7 +1124,7 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 		break;
 	}
 
-	dev_dbg(&(pcr->pci->dev), "PID: 0x%04x, IC version: 0x%02x\n",
+	pcr_dbg(pcr, "PID: 0x%04x, IC version: 0x%02x\n",
 			PCI_PID(pcr), pcr->ic_version);
 
 	pcr->slots = kcalloc(pcr->num_slots, sizeof(struct rtsx_slot),
@@ -1140,14 +1135,14 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 	if (pcr->ops->fetch_vendor_settings)
 		pcr->ops->fetch_vendor_settings(pcr);
 
-	dev_dbg(&(pcr->pci->dev), "pcr->aspm_en = 0x%x\n", pcr->aspm_en);
-	dev_dbg(&(pcr->pci->dev), "pcr->sd30_drive_sel_1v8 = 0x%x\n",
+	pcr_dbg(pcr, "pcr->aspm_en = 0x%x\n", pcr->aspm_en);
+	pcr_dbg(pcr, "pcr->sd30_drive_sel_1v8 = 0x%x\n",
 			pcr->sd30_drive_sel_1v8);
-	dev_dbg(&(pcr->pci->dev), "pcr->sd30_drive_sel_3v3 = 0x%x\n",
+	pcr_dbg(pcr, "pcr->sd30_drive_sel_3v3 = 0x%x\n",
 			pcr->sd30_drive_sel_3v3);
-	dev_dbg(&(pcr->pci->dev), "pcr->card_drive_sel = 0x%x\n",
+	pcr_dbg(pcr, "pcr->card_drive_sel = 0x%x\n",
 			pcr->card_drive_sel);
-	dev_dbg(&(pcr->pci->dev), "pcr->flags = 0x%x\n", pcr->flags);
+	pcr_dbg(pcr, "pcr->flags = 0x%x\n", pcr->flags);
 
 	pcr->state = PDEV_STAT_IDLE;
 	err = rtsx_pci_init_hw(pcr);
-- 
1.9.1

