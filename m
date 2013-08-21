Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3HUBrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:47:08 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55452 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HUBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:46:49 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7L1kWwJ012577, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 1/3] mfd:mmc:rtsx: Change default tx phase
Date: Wed, 21 Aug 2013 09:46:25 +0800
Message-ID: <0dd50ed0bb16afbb47d8de8ba6eb4f9d1c901d45.1377049122.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1377049122.git.wei_wang@realsil.com.cn>
References: <cover.1377049122.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

The default phase can meet most cards' requirement, but it is not the
optimal one. In some extreme situation, the rx phase point produced by
the following tuning process will drift quite a distance.
Before tuning UHS card, this patch will set a more proper initial tx
phase point, which is calculated from statistic data, and can achieve
a much better tx signal quality.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c             |    4 +++
 drivers/mfd/rts5209.c             |    2 ++
 drivers/mfd/rts5227.c             |    2 ++
 drivers/mfd/rts5229.c             |    2 ++
 drivers/mfd/rts5249.c             |    2 ++
 drivers/mmc/host/rtsx_pci_sdmmc.c |   58 +++++++++++++++++++++++++++----------
 include/linux/mfd/rtsx_pci.h      |   15 ++++++++++
 7 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index e4c1833..5280135 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -452,6 +452,8 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
 	pcr->sd_pull_ctl_enable_tbl = rtl8411_sd_pull_ctl_enable_tbl;
@@ -471,6 +473,8 @@ void rtl8411b_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
 
 	pcr->ic_version = rtl8411_get_ic_version(pcr);
 
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index 4026e1f..cb04174 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -270,6 +270,8 @@ void rts5209_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 16);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
 	pcr->ic_version = rts5209_get_ic_version(pcr);
 	pcr->sd_pull_ctl_enable_tbl = rts5209_sd_pull_ctl_enable_tbl;
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index d7cae82..c001151 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -291,6 +291,8 @@ void rts5227_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 15);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(30, 7, 7);
 
 	pcr->sd_pull_ctl_enable_tbl = rts5227_sd_pull_ctl_enable_tbl;
 	pcr->sd_pull_ctl_disable_tbl = rts5227_sd_pull_ctl_disable_tbl;
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index 620e7fa..6353f5d 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -261,6 +261,8 @@ void rts5229_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(27, 27, 15);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(30, 6, 6);
 
 	pcr->ic_version = rts5229_get_ic_version(pcr);
 	if (pcr->ic_version == IC_VER_C) {
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index ea90f8f..3b835f5 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -298,6 +298,8 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
 	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_C;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
+	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);
+	pcr->rx_initial_phase = SET_CLOCK_PHASE(24, 6, 5);
 
 	pcr->ic_version = rts5249_get_ic_version(pcr);
 	pcr->sd_pull_ctl_enable_tbl = rts5249_sd_pull_ctl_enable_tbl;
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 82a35b9..fcb368e 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -56,7 +56,6 @@ struct realtek_pci_sdmmc {
 	bool			double_clk;
 	bool			eject;
 	bool			initial_mode;
-	bool			ddr_mode;
 	int			power_state;
 #define SDMMC_POWER_ON		1
 #define SDMMC_POWER_OFF		0
@@ -475,18 +474,24 @@ static void sd_normal_rw(struct realtek_pci_sdmmc *host,
 	kfree(buf);
 }
 
-static int sd_change_phase(struct realtek_pci_sdmmc *host, u8 sample_point)
+static int sd_change_phase(struct realtek_pci_sdmmc *host,
+		u8 sample_point, bool rx)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
 
-	dev_dbg(sdmmc_dev(host), "%s: sample_point = %d\n",
-			__func__, sample_point);
+	dev_dbg(sdmmc_dev(host), "%s(%s): sample_point = %d\n",
+			__func__, rx ? "RX" : "TX", sample_point);
 
 	rtsx_pci_init_cmd(pcr);
 
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CLK_CTL, CHANGE_CLK, CHANGE_CLK);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_VPRX_CTL, 0x1F, sample_point);
+	if (rx)
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				SD_VPRX_CTL, 0x1F, sample_point);
+	else
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
+				SD_VPTX_CTL, 0x1F, sample_point);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_VPCLK0_CTL, PHASE_NOT_RESET, 0);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_VPCLK0_CTL,
 			PHASE_NOT_RESET, PHASE_NOT_RESET);
@@ -602,7 +607,7 @@ static int sd_tuning_rx_cmd(struct realtek_pci_sdmmc *host,
 	int err;
 	u8 cmd[5] = {0};
 
-	err = sd_change_phase(host, sample_point);
+	err = sd_change_phase(host, sample_point, true);
 	if (err < 0)
 		return err;
 
@@ -664,7 +669,7 @@ static int sd_tuning_rx(struct realtek_pci_sdmmc *host, u8 opcode)
 		if (final_phase == 0xFF)
 			return -EINVAL;
 
-		err = sd_change_phase(host, final_phase);
+		err = sd_change_phase(host, final_phase, true);
 		if (err < 0)
 			return err;
 	} else {
@@ -833,14 +838,11 @@ static int sd_set_power_mode(struct realtek_pci_sdmmc *host,
 	return err;
 }
 
-static int sd_set_timing(struct realtek_pci_sdmmc *host,
-		unsigned char timing, bool *ddr_mode)
+static int sd_set_timing(struct realtek_pci_sdmmc *host, unsigned char timing)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	int err = 0;
 
-	*ddr_mode = false;
-
 	rtsx_pci_init_cmd(pcr);
 
 	switch (timing) {
@@ -857,8 +859,6 @@ static int sd_set_timing(struct realtek_pci_sdmmc *host,
 		break;
 
 	case MMC_TIMING_UHS_DDR50:
-		*ddr_mode = true;
-
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG1,
 				0x0C | SD_ASYNC_FIFO_NOT_RST,
 				SD_DDR_MODE | SD_ASYNC_FIFO_NOT_RST);
@@ -926,7 +926,7 @@ static void sdmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	sd_set_bus_width(host, ios->bus_width);
 	sd_set_power_mode(host, ios->power_mode);
-	sd_set_timing(host, ios->timing, &host->ddr_mode);
+	sd_set_timing(host, ios->timing);
 
 	host->vpclk = false;
 	host->double_clk = true;
@@ -1148,9 +1148,35 @@ static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
 
 	rtsx_pci_start_run(pcr);
 
-	if (!host->ddr_mode)
-		err = sd_tuning_rx(host, MMC_SEND_TUNING_BLOCK);
+	/* Set initial TX phase */
+	switch (mmc->ios.timing) {
+	case MMC_TIMING_UHS_SDR104:
+		err = sd_change_phase(host, SDR104_TX_PHASE(pcr), false);
+		break;
+
+	case MMC_TIMING_UHS_SDR50:
+		err = sd_change_phase(host, SDR50_TX_PHASE(pcr), false);
+		break;
+
+	case MMC_TIMING_UHS_DDR50:
+		err = sd_change_phase(host, DDR50_TX_PHASE(pcr), false);
+		break;
+
+	default:
+		err = 0;
+	}
 
+	if (err)
+		goto out;
+
+	/* Tuning RX phase */
+	if ((mmc->ios.timing == MMC_TIMING_UHS_SDR104) ||
+			(mmc->ios.timing == MMC_TIMING_UHS_SDR50))
+		err = sd_tuning_rx(host, opcode);
+	else if (mmc->ios.timing == MMC_TIMING_UHS_DDR50)
+		err = sd_change_phase(host, DDR50_RX_PHASE(pcr), true);
+
+out:
 	mutex_unlock(&pcr->pcr_mutex);
 
 	return err;
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index daefca1..d1382df 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -847,6 +847,9 @@ struct rtsx_pcr {
 #define PCR_REVERSE_SOCKET		(1 << 1)
 	u32				flags;
 
+	u32				tx_initial_phase;
+	u32				rx_initial_phase;
+
 	const u32			*sd_pull_ctl_enable_tbl;
 	const u32			*sd_pull_ctl_disable_tbl;
 	const u32			*ms_pull_ctl_enable_tbl;
@@ -863,6 +866,18 @@ struct rtsx_pcr {
 #define PCI_VID(pcr)			((pcr)->pci->vendor)
 #define PCI_PID(pcr)			((pcr)->pci->device)
 
+#define SDR104_PHASE(val)		((val) & 0xFF)
+#define SDR50_PHASE(val)		(((val) >> 8) & 0xFF)
+#define DDR50_PHASE(val)		(((val) >> 16) & 0xFF)
+#define SDR104_TX_PHASE(pcr)		SDR104_PHASE((pcr)->tx_initial_phase)
+#define SDR50_TX_PHASE(pcr)		SDR50_PHASE((pcr)->tx_initial_phase)
+#define DDR50_TX_PHASE(pcr)		DDR50_PHASE((pcr)->tx_initial_phase)
+#define SDR104_RX_PHASE(pcr)		SDR104_PHASE((pcr)->rx_initial_phase)
+#define SDR50_RX_PHASE(pcr)		SDR50_PHASE((pcr)->rx_initial_phase)
+#define DDR50_RX_PHASE(pcr)		DDR50_PHASE((pcr)->rx_initial_phase)
+#define SET_CLOCK_PHASE(sdr104, sdr50, ddr50)	\
+				(((ddr50) << 16) | ((sdr50) << 8) | (sdr104))
+
 void rtsx_pci_start_run(struct rtsx_pcr *pcr);
 int rtsx_pci_write_register(struct rtsx_pcr *pcr, u16 addr, u8 mask, u8 data);
 int rtsx_pci_read_register(struct rtsx_pcr *pcr, u16 addr, u8 *data);
-- 
1.7.9.5

