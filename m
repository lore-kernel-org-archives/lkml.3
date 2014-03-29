Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaC2SVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:21:45 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36043 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaC2SVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:21:43 -0400
Date: Sat, 29 Mar 2014 23:52:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 33/55] scsi: Mark functions as static in mvsas/mv_94xx.c
Message-ID: <ea974588688a06daecf5c058b550e5e86ecbff43.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in mvsas/mv_94xx.c because they are not used
outside this file.

This eliminates the following warning in mvsas/mv_94xx.c:
drivers/scsi/mvsas/mv_94xx.c:51:6: warning: no previous prototype for ‘set_phy_tuning’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:113:6: warning: no previous prototype for ‘set_phy_ffe_tuning’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:180:6: warning: no previous prototype for ‘set_phy_rate’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:635:6: warning: no previous prototype for ‘mvs_94xx_clear_srs_irq’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:862:6: warning: no previous prototype for ‘mvs_94xx_phy_set_link_rate’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:892:5: warning: no previous prototype for ‘mvs_94xx_spi_read_data’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:898:6: warning: no previous prototype for ‘mvs_94xx_spi_write_data’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:905:5: warning: no previous prototype for ‘mvs_94xx_spi_buildcmd’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:930:5: warning: no previous prototype for ‘mvs_94xx_spi_issuecmd’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:938:5: warning: no previous prototype for ‘mvs_94xx_spi_waitdataready’ [-Wmissing-prototypes]
drivers/scsi/mvsas/mv_94xx.c:953:6: warning: no previous prototype for ‘mvs_94xx_fix_dma’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/mvsas/mv_94xx.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 1e4479f..7ab9818 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -48,8 +48,8 @@ static void mvs_94xx_detect_porttype(struct mvs_info *mvi, int i)
 	}
 }
 
-void set_phy_tuning(struct mvs_info *mvi, int phy_id,
-			struct phy_tuning phy_tuning)
+static void set_phy_tuning(struct mvs_info *mvi, int phy_id,
+			   struct phy_tuning phy_tuning)
 {
 	u32 tmp, setting_0 = 0, setting_1 = 0;
 	u8 i;
@@ -110,8 +110,8 @@ void set_phy_tuning(struct mvs_info *mvi, int phy_id,
 	}
 }
 
-void set_phy_ffe_tuning(struct mvs_info *mvi, int phy_id,
-				struct ffe_control ffe)
+static void set_phy_ffe_tuning(struct mvs_info *mvi, int phy_id,
+			       struct ffe_control ffe)
 {
 	u32 tmp;
 
@@ -177,7 +177,7 @@ void set_phy_ffe_tuning(struct mvs_info *mvi, int phy_id,
 }
 
 /*Notice: this function must be called when phy is disabled*/
-void set_phy_rate(struct mvs_info *mvi, int phy_id, u8 rate)
+static void set_phy_rate(struct mvs_info *mvi, int phy_id, u8 rate)
 {
 	union reg_phy_cfg phy_cfg, phy_cfg_tmp;
 	mvs_write_port_vsr_addr(mvi, phy_id, VSR_PHY_MODE2);
@@ -632,7 +632,8 @@ static void mvs_94xx_command_active(struct mvs_info *mvi, u32 slot_idx)
 	}
 }
 
-void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
+static void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set,
+				   u8 clear_all)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
@@ -859,8 +860,8 @@ static void mvs_94xx_fix_phy_info(struct mvs_info *mvi, int i,
 
 }
 
-void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
-			struct sas_phy_linkrates *rates)
+static void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
+				       struct sas_phy_linkrates *rates)
 {
 	u32 lrmax = 0;
 	u32 tmp;
@@ -889,20 +890,20 @@ static void mvs_94xx_clear_active_cmds(struct mvs_info *mvi)
 }
 
 
-u32 mvs_94xx_spi_read_data(struct mvs_info *mvi)
+static u32 mvs_94xx_spi_read_data(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	return mr32(SPI_RD_DATA_REG_94XX);
 }
 
-void mvs_94xx_spi_write_data(struct mvs_info *mvi, u32 data)
+static void mvs_94xx_spi_write_data(struct mvs_info *mvi, u32 data)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	 mw32(SPI_RD_DATA_REG_94XX, data);
 }
 
 
-int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
+static int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
 				u32      *dwCmd,
 				u8       cmd,
 				u8       read,
@@ -927,7 +928,7 @@ int mvs_94xx_spi_buildcmd(struct mvs_info *mvi,
 }
 
 
-int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
+static int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	mw32(SPI_CTRL_REG_94XX, cmd | SPI_CTRL_SpiStart_94XX);
@@ -935,7 +936,7 @@ int mvs_94xx_spi_issuecmd(struct mvs_info *mvi, u32 cmd)
 	return 0;
 }
 
-int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
+static int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
 	u32   i, dwTmp;
@@ -950,8 +951,8 @@ int mvs_94xx_spi_waitdataready(struct mvs_info *mvi, u32 timeout)
 	return -1;
 }
 
-void mvs_94xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
-				int buf_len, int from, void *prd)
+static void mvs_94xx_fix_dma(struct mvs_info *mvi, u32 phy_mask,
+			     int buf_len, int from, void *prd)
 {
 	int i;
 	struct mvs_prd *buf_prd = prd;
-- 
1.7.9.5

