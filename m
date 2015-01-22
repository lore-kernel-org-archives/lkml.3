Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbbAVHdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:33:01 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:52314 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbAVHbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:31:00 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M7Uixb001365, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [RESEND PATCH v2 2/9] mfd: rtsx: place register address and values togather
Date: Thu, 22 Jan 2015 15:30:34 +0800
Message-ID: <69af9f802e6b398e8cb46691c7de18dafd0a0a3b.1421911636.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421911636.git.micky_ching@realsil.com.cn>
References: <cover.1421911636.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

It is more readable to place register address and values define
togather. The values define add two leading space indicate belong
to the register address defined above.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/rtsx_pci.h | 836 +++++++++++++++++++------------------------
 1 file changed, 369 insertions(+), 467 deletions(-)

diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index a9c2a14..e81f2bb 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -28,74 +28,72 @@
 
 #define MAX_RW_REG_CNT			1024
 
-/* PCI Operation Register Address */
 #define RTSX_HCBAR			0x00
 #define RTSX_HCBCTLR			0x04
+#define   STOP_CMD			(0x01 << 28)
+#define   READ_REG_CMD			0
+#define   WRITE_REG_CMD			1
+#define   CHECK_REG_CMD			2
+
 #define RTSX_HDBAR			0x08
+#define   SG_INT			0x04
+#define   SG_END			0x02
+#define   SG_VALID			0x01
+#define   SG_NO_OP			0x00
+#define   SG_TRANS_DATA			(0x02 << 4)
+#define   SG_LINK_DESC			(0x03 << 4)
 #define RTSX_HDBCTLR			0x0C
+#define   SDMA_MODE			0x00
+#define   ADMA_MODE			(0x02 << 26)
+#define   STOP_DMA			(0x01 << 28)
+#define   TRIG_DMA			(0x01 << 31)
+
 #define RTSX_HAIMR			0x10
-#define RTSX_BIPR			0x14
-#define RTSX_BIER			0x18
+#define   HAIMR_TRANS_START		(0x01 << 31)
+#define   HAIMR_READ			0x00
+#define   HAIMR_WRITE			(0x01 << 30)
+#define   HAIMR_READ_START		(HAIMR_TRANS_START | HAIMR_READ)
+#define   HAIMR_WRITE_START		(HAIMR_TRANS_START | HAIMR_WRITE)
+#define   HAIMR_TRANS_END			(HAIMR_TRANS_START)
 
-/* Host command buffer control register */
-#define STOP_CMD			(0x01 << 28)
-
-/* Host data buffer control register */
-#define SDMA_MODE			0x00
-#define ADMA_MODE			(0x02 << 26)
-#define STOP_DMA			(0x01 << 28)
-#define TRIG_DMA			(0x01 << 31)
-
-/* Host access internal memory register */
-#define HAIMR_TRANS_START		(0x01 << 31)
-#define HAIMR_READ			0x00
-#define HAIMR_WRITE			(0x01 << 30)
-#define HAIMR_READ_START		(HAIMR_TRANS_START | HAIMR_READ)
-#define HAIMR_WRITE_START		(HAIMR_TRANS_START | HAIMR_WRITE)
-#define HAIMR_TRANS_END			(HAIMR_TRANS_START)
-
-/* Bus interrupt pending register */
-#define CMD_DONE_INT			(1 << 31)
-#define DATA_DONE_INT			(1 << 30)
-#define TRANS_OK_INT			(1 << 29)
-#define TRANS_FAIL_INT			(1 << 28)
-#define XD_INT				(1 << 27)
-#define MS_INT				(1 << 26)
-#define SD_INT				(1 << 25)
-#define GPIO0_INT			(1 << 24)
-#define OC_INT				(1 << 23)
-#define SD_WRITE_PROTECT		(1 << 19)
-#define XD_EXIST			(1 << 18)
-#define MS_EXIST			(1 << 17)
-#define SD_EXIST			(1 << 16)
-#define DELINK_INT			GPIO0_INT
-#define MS_OC_INT			(1 << 23)
-#define SD_OC_INT			(1 << 22)
+#define RTSX_BIPR			0x14
+#define   CMD_DONE_INT			(1 << 31)
+#define   DATA_DONE_INT			(1 << 30)
+#define   TRANS_OK_INT			(1 << 29)
+#define   TRANS_FAIL_INT		(1 << 28)
+#define   XD_INT			(1 << 27)
+#define   MS_INT			(1 << 26)
+#define   SD_INT			(1 << 25)
+#define   GPIO0_INT			(1 << 24)
+#define   OC_INT			(1 << 23)
+#define   SD_WRITE_PROTECT		(1 << 19)
+#define   XD_EXIST			(1 << 18)
+#define   MS_EXIST			(1 << 17)
+#define   SD_EXIST			(1 << 16)
+#define   DELINK_INT			GPIO0_INT
+#define   MS_OC_INT			(1 << 23)
+#define   SD_OC_INT			(1 << 22)
 
 #define CARD_INT		(XD_INT | MS_INT | SD_INT)
 #define NEED_COMPLETE_INT	(DATA_DONE_INT | TRANS_OK_INT | TRANS_FAIL_INT)
 #define RTSX_INT		(CMD_DONE_INT | NEED_COMPLETE_INT | \
 					CARD_INT | GPIO0_INT | OC_INT)
-
 #define CARD_EXIST		(XD_EXIST | MS_EXIST | SD_EXIST)
 
-/* Bus interrupt enable register */
-#define CMD_DONE_INT_EN		(1 << 31)
-#define DATA_DONE_INT_EN	(1 << 30)
-#define TRANS_OK_INT_EN		(1 << 29)
-#define TRANS_FAIL_INT_EN	(1 << 28)
-#define XD_INT_EN		(1 << 27)
-#define MS_INT_EN		(1 << 26)
-#define SD_INT_EN		(1 << 25)
-#define GPIO0_INT_EN		(1 << 24)
-#define OC_INT_EN		(1 << 23)
-#define DELINK_INT_EN		GPIO0_INT_EN
-#define MS_OC_INT_EN		(1 << 23)
-#define SD_OC_INT_EN		(1 << 22)
-
-#define READ_REG_CMD		0
-#define WRITE_REG_CMD		1
-#define CHECK_REG_CMD		2
+#define RTSX_BIER			0x18
+#define   CMD_DONE_INT_EN		(1 << 31)
+#define   DATA_DONE_INT_EN		(1 << 30)
+#define   TRANS_OK_INT_EN		(1 << 29)
+#define   TRANS_FAIL_INT_EN		(1 << 28)
+#define   XD_INT_EN			(1 << 27)
+#define   MS_INT_EN			(1 << 26)
+#define   SD_INT_EN			(1 << 25)
+#define   GPIO0_INT_EN			(1 << 24)
+#define   OC_INT_EN			(1 << 23)
+#define   DELINK_INT_EN			GPIO0_INT_EN
+#define   MS_OC_INT_EN			(1 << 23)
+#define   SD_OC_INT_EN			(1 << 22)
+
 
 /*
  * macros for easy use
@@ -125,423 +123,68 @@
 #define rtsx_pci_write_config_dword(pcr, where, val) \
 	pci_write_config_dword((pcr)->pci, where, val)
 
-#define STATE_TRANS_NONE	0
-#define STATE_TRANS_CMD		1
-#define STATE_TRANS_BUF		2
-#define STATE_TRANS_SG		3
-
-#define TRANS_NOT_READY		0
-#define TRANS_RESULT_OK		1
-#define TRANS_RESULT_FAIL	2
-#define TRANS_NO_DEVICE		3
-
-#define RTSX_RESV_BUF_LEN	4096
-#define HOST_CMDS_BUF_LEN	1024
-#define HOST_SG_TBL_BUF_LEN	(RTSX_RESV_BUF_LEN - HOST_CMDS_BUF_LEN)
-#define HOST_SG_TBL_ITEMS	(HOST_SG_TBL_BUF_LEN / 8)
-#define MAX_SG_ITEM_LEN		0x80000
-
-#define HOST_TO_DEVICE		0
-#define DEVICE_TO_HOST		1
-
-#define RTSX_PHASE_MAX		32
-#define RX_TUNING_CNT		3
-
-/* SG descriptor */
-#define SG_INT			0x04
-#define SG_END			0x02
-#define SG_VALID		0x01
-
-#define SG_NO_OP		0x00
-#define SG_TRANS_DATA		(0x02 << 4)
-#define SG_LINK_DESC		(0x03 << 4)
-
-/* Output voltage */
-#define OUTPUT_3V3		0
-#define OUTPUT_1V8		1
-
-/* Card Clock Enable Register */
-#define SD_CLK_EN			0x04
-#define MS_CLK_EN			0x08
-
-/* Card Select Register */
-#define SD_MOD_SEL			2
-#define MS_MOD_SEL			3
-
-/* Card Output Enable Register */
-#define SD_OUTPUT_EN			0x04
-#define MS_OUTPUT_EN			0x08
-
-/* CARD_SHARE_MODE */
-#define CARD_SHARE_MASK			0x0F
-#define CARD_SHARE_MULTI_LUN		0x00
-#define CARD_SHARE_NORMAL		0x00
-#define CARD_SHARE_48_SD		0x04
-#define CARD_SHARE_48_MS		0x08
-/* CARD_SHARE_MODE for barossa */
-#define CARD_SHARE_BAROSSA_SD		0x01
-#define CARD_SHARE_BAROSSA_MS		0x02
-
-/* CARD_DRIVE_SEL */
-#define MS_DRIVE_8mA			(0x01 << 6)
-#define MMC_DRIVE_8mA			(0x01 << 4)
-#define XD_DRIVE_8mA			(0x01 << 2)
-#define GPIO_DRIVE_8mA			0x01
-#define RTS5209_CARD_DRIVE_DEFAULT	(MS_DRIVE_8mA | MMC_DRIVE_8mA |\
-						XD_DRIVE_8mA | GPIO_DRIVE_8mA)
-#define RTL8411_CARD_DRIVE_DEFAULT	(MS_DRIVE_8mA | MMC_DRIVE_8mA |\
-						XD_DRIVE_8mA)
-#define RTSX_CARD_DRIVE_DEFAULT		(MS_DRIVE_8mA | GPIO_DRIVE_8mA)
+#define STATE_TRANS_NONE		0
+#define STATE_TRANS_CMD			1
+#define STATE_TRANS_BUF			2
+#define STATE_TRANS_SG			3
 
-/* SD30_DRIVE_SEL */
-#define DRIVER_TYPE_A			0x05
-#define DRIVER_TYPE_B			0x03
-#define DRIVER_TYPE_C			0x02
-#define DRIVER_TYPE_D			0x01
-#define CFG_DRIVER_TYPE_A		0x02
-#define CFG_DRIVER_TYPE_B		0x03
-#define CFG_DRIVER_TYPE_C		0x01
-#define CFG_DRIVER_TYPE_D		0x00
-
-/* FPDCTL */
-#define SSC_POWER_DOWN			0x01
-#define SD_OC_POWER_DOWN		0x02
-#define ALL_POWER_DOWN			0x07
-#define OC_POWER_DOWN			0x06
-
-/* CLK_CTL */
-#define CHANGE_CLK			0x01
-
-/* LDO_CTL */
-#define BPP_ASIC_1V7			0x00
-#define BPP_ASIC_1V8			0x01
-#define BPP_ASIC_1V9			0x02
-#define BPP_ASIC_2V0			0x03
-#define BPP_ASIC_2V7			0x04
-#define BPP_ASIC_2V8			0x05
-#define BPP_ASIC_3V2			0x06
-#define BPP_ASIC_3V3			0x07
-#define BPP_REG_TUNED18			0x07
-#define BPP_TUNED18_SHIFT_8402		5
-#define BPP_TUNED18_SHIFT_8411		4
-#define BPP_PAD_MASK			0x04
-#define BPP_PAD_3V3			0x04
-#define BPP_PAD_1V8			0x00
-#define BPP_LDO_POWB			0x03
-#define BPP_LDO_ON			0x00
-#define BPP_LDO_SUSPEND			0x02
-#define BPP_LDO_OFF			0x03
-
-/* CD_PAD_CTL */
-#define CD_DISABLE_MASK			0x07
-#define MS_CD_DISABLE			0x04
-#define SD_CD_DISABLE			0x02
-#define XD_CD_DISABLE			0x01
-#define CD_DISABLE			0x07
-#define CD_ENABLE			0x00
-#define MS_CD_EN_ONLY			0x03
-#define SD_CD_EN_ONLY			0x05
-#define XD_CD_EN_ONLY			0x06
-#define FORCE_CD_LOW_MASK		0x38
-#define FORCE_CD_XD_LOW			0x08
-#define FORCE_CD_SD_LOW			0x10
-#define FORCE_CD_MS_LOW			0x20
-#define CD_AUTO_DISABLE			0x40
-
-/* SD_STAT1 */
-#define SD_CRC7_ERR			0x80
-#define SD_CRC16_ERR			0x40
-#define SD_CRC_WRITE_ERR		0x20
-#define SD_CRC_WRITE_ERR_MASK		0x1C
-#define GET_CRC_TIME_OUT		0x02
-#define SD_TUNING_COMPARE_ERR		0x01
-
-/* SD_STAT2 */
-#define SD_RSP_80CLK_TIMEOUT		0x01
-
-/* SD_BUS_STAT */
-#define SD_CLK_TOGGLE_EN		0x80
-#define SD_CLK_FORCE_STOP	        0x40
-#define SD_DAT3_STATUS		        0x10
-#define SD_DAT2_STATUS		        0x08
-#define SD_DAT1_STATUS		        0x04
-#define SD_DAT0_STATUS		        0x02
-#define SD_CMD_STATUS			0x01
-
-/* SD_PAD_CTL */
-#define SD_IO_USING_1V8		        0x80
-#define SD_IO_USING_3V3		        0x7F
-#define TYPE_A_DRIVING		        0x00
-#define TYPE_B_DRIVING			0x01
-#define TYPE_C_DRIVING			0x02
-#define TYPE_D_DRIVING		        0x03
-
-/* SD_SAMPLE_POINT_CTL */
-#define DDR_FIX_RX_DAT			0x00
-#define DDR_VAR_RX_DAT			0x80
-#define DDR_FIX_RX_DAT_EDGE		0x00
-#define DDR_FIX_RX_DAT_14_DELAY		0x40
-#define DDR_FIX_RX_CMD			0x00
-#define DDR_VAR_RX_CMD			0x20
-#define DDR_FIX_RX_CMD_POS_EDGE		0x00
-#define DDR_FIX_RX_CMD_14_DELAY		0x10
-#define SD20_RX_POS_EDGE		0x00
-#define SD20_RX_14_DELAY		0x08
-#define SD20_RX_SEL_MASK		0x08
+#define TRANS_NOT_READY			0
+#define TRANS_RESULT_OK			1
+#define TRANS_RESULT_FAIL		2
+#define TRANS_NO_DEVICE			3
 
-/* SD_PUSH_POINT_CTL */
-#define DDR_FIX_TX_CMD_DAT		0x00
-#define DDR_VAR_TX_CMD_DAT		0x80
-#define DDR_FIX_TX_DAT_14_TSU		0x00
-#define DDR_FIX_TX_DAT_12_TSU		0x40
-#define DDR_FIX_TX_CMD_NEG_EDGE		0x00
-#define DDR_FIX_TX_CMD_14_AHEAD		0x20
-#define SD20_TX_NEG_EDGE		0x00
-#define SD20_TX_14_AHEAD		0x10
-#define SD20_TX_SEL_MASK		0x10
-#define DDR_VAR_SDCLK_POL_SWAP		0x01
-
-/* SD_TRANSFER */
-#define SD_TRANSFER_START		0x80
-#define SD_TRANSFER_END			0x40
-#define SD_STAT_IDLE			0x20
-#define SD_TRANSFER_ERR			0x10
-/* SD Transfer Mode definition */
-#define SD_TM_NORMAL_WRITE		0x00
-#define SD_TM_AUTO_WRITE_3		0x01
-#define SD_TM_AUTO_WRITE_4		0x02
-#define SD_TM_AUTO_READ_3		0x05
-#define SD_TM_AUTO_READ_4		0x06
-#define SD_TM_CMD_RSP			0x08
-#define SD_TM_AUTO_WRITE_1		0x09
-#define SD_TM_AUTO_WRITE_2		0x0A
-#define SD_TM_NORMAL_READ		0x0C
-#define SD_TM_AUTO_READ_1		0x0D
-#define SD_TM_AUTO_READ_2		0x0E
-#define SD_TM_AUTO_TUNING		0x0F
-
-/* SD_VPTX_CTL / SD_VPRX_CTL */
-#define PHASE_CHANGE			0x80
-#define PHASE_NOT_RESET			0x40
-
-/* SD_DCMPS_TX_CTL / SD_DCMPS_RX_CTL */
-#define DCMPS_CHANGE			0x80
-#define DCMPS_CHANGE_DONE		0x40
-#define DCMPS_ERROR			0x20
-#define DCMPS_CURRENT_PHASE		0x1F
-
-/* SD Configure 1 Register */
-#define SD_CLK_DIVIDE_0			0x00
-#define SD_CLK_DIVIDE_256		0xC0
-#define SD_CLK_DIVIDE_128		0x80
-#define SD_BUS_WIDTH_1BIT		0x00
-#define SD_BUS_WIDTH_4BIT		0x01
-#define SD_BUS_WIDTH_8BIT		0x02
-#define SD_ASYNC_FIFO_NOT_RST		0x10
-#define SD_20_MODE			0x00
-#define SD_DDR_MODE			0x04
-#define SD_30_MODE			0x08
-
-#define SD_CLK_DIVIDE_MASK		0xC0
-
-/* SD_CMD_STATE */
-#define SD_CMD_IDLE			0x80
-
-/* SD_DATA_STATE */
-#define SD_DATA_IDLE			0x80
-
-/* DCM_DRP_CTL */
-#define DCM_RESET			0x08
-#define DCM_LOCKED			0x04
-#define DCM_208M			0x00
-#define DCM_TX			        0x01
-#define DCM_RX			        0x02
-
-/* DCM_DRP_TRIG */
-#define DRP_START			0x80
-#define DRP_DONE			0x40
-
-/* DCM_DRP_CFG */
-#define DRP_WRITE			0x80
-#define DRP_READ			0x00
-#define DCM_WRITE_ADDRESS_50		0x50
-#define DCM_WRITE_ADDRESS_51		0x51
-#define DCM_READ_ADDRESS_00		0x00
-#define DCM_READ_ADDRESS_51		0x51
-
-/* IRQSTAT0 */
-#define DMA_DONE_INT			0x80
-#define SUSPEND_INT			0x40
-#define LINK_RDY_INT			0x20
-#define LINK_DOWN_INT			0x10
-
-/* DMACTL */
-#define DMA_RST				0x80
-#define DMA_BUSY			0x04
-#define DMA_DIR_TO_CARD			0x00
-#define DMA_DIR_FROM_CARD		0x02
-#define DMA_EN				0x01
-#define DMA_128				(0 << 4)
-#define DMA_256				(1 << 4)
-#define DMA_512				(2 << 4)
-#define DMA_1024			(3 << 4)
-#define DMA_PACK_SIZE_MASK		0x30
-
-/* SSC_CTL1 */
-#define SSC_RSTB			0x80
-#define SSC_8X_EN			0x40
-#define SSC_FIX_FRAC			0x20
-#define SSC_SEL_1M			0x00
-#define SSC_SEL_2M			0x08
-#define SSC_SEL_4M			0x10
-#define SSC_SEL_8M			0x18
-
-/* SSC_CTL2 */
-#define SSC_DEPTH_MASK			0x07
-#define SSC_DEPTH_DISALBE		0x00
-#define SSC_DEPTH_4M			0x01
-#define SSC_DEPTH_2M			0x02
-#define SSC_DEPTH_1M			0x03
-#define SSC_DEPTH_500K			0x04
-#define SSC_DEPTH_250K			0x05
-
-/* System Clock Control Register */
-#define CLK_LOW_FREQ			0x01
-
-/* System Clock Divider Register */
-#define CLK_DIV_1			0x01
-#define CLK_DIV_2			0x02
-#define CLK_DIV_4			0x03
-#define CLK_DIV_8			0x04
-
-/* MS_CFG */
-#define SAMPLE_TIME_RISING		0x00
-#define SAMPLE_TIME_FALLING		0x80
-#define PUSH_TIME_DEFAULT		0x00
-#define PUSH_TIME_ODD			0x40
-#define NO_EXTEND_TOGGLE		0x00
-#define EXTEND_TOGGLE_CHK		0x20
-#define MS_BUS_WIDTH_1			0x00
-#define MS_BUS_WIDTH_4			0x10
-#define MS_BUS_WIDTH_8			0x18
-#define MS_2K_SECTOR_MODE		0x04
-#define MS_512_SECTOR_MODE		0x00
-#define MS_TOGGLE_TIMEOUT_EN		0x00
-#define MS_TOGGLE_TIMEOUT_DISEN		0x01
-#define MS_NO_CHECK_INT			0x02
+#define RTSX_RESV_BUF_LEN		4096
+#define HOST_CMDS_BUF_LEN		1024
+#define HOST_SG_TBL_BUF_LEN		(RTSX_RESV_BUF_LEN - HOST_CMDS_BUF_LEN)
+#define HOST_SG_TBL_ITEMS		(HOST_SG_TBL_BUF_LEN / 8)
+#define MAX_SG_ITEM_LEN			0x80000
+#define HOST_TO_DEVICE			0
+#define DEVICE_TO_HOST			1
+
+#define OUTPUT_3V3			0
+#define OUTPUT_1V8			1
 
-/* MS_TRANS_CFG */
-#define WAIT_INT			0x80
-#define NO_WAIT_INT			0x00
-#define NO_AUTO_READ_INT_REG		0x00
-#define AUTO_READ_INT_REG		0x40
-#define MS_CRC16_ERR			0x20
-#define MS_RDY_TIMEOUT			0x10
-#define MS_INT_CMDNK			0x08
-#define MS_INT_BREQ			0x04
-#define MS_INT_ERR			0x02
-#define MS_INT_CED			0x01
-
-/* MS_TRANSFER */
-#define MS_TRANSFER_START		0x80
-#define MS_TRANSFER_END			0x40
-#define MS_TRANSFER_ERR			0x20
-#define MS_BS_STATE			0x10
-#define MS_TM_READ_BYTES		0x00
-#define MS_TM_NORMAL_READ		0x01
-#define MS_TM_WRITE_BYTES		0x04
-#define MS_TM_NORMAL_WRITE		0x05
-#define MS_TM_AUTO_READ			0x08
-#define MS_TM_AUTO_WRITE		0x0C
-
-/* SD Configure 2 Register */
-#define SD_CALCULATE_CRC7		0x00
-#define SD_NO_CALCULATE_CRC7		0x80
-#define SD_CHECK_CRC16			0x00
-#define SD_NO_CHECK_CRC16		0x40
-#define SD_NO_CHECK_WAIT_CRC_TO		0x20
-#define SD_WAIT_BUSY_END		0x08
-#define SD_NO_WAIT_BUSY_END		0x00
-#define SD_CHECK_CRC7			0x00
-#define SD_NO_CHECK_CRC7		0x04
-#define SD_RSP_LEN_0			0x00
-#define SD_RSP_LEN_6			0x01
-#define SD_RSP_LEN_17			0x02
-/* SD/MMC Response Type Definition */
-#define SD_RSP_TYPE_R0			0x04
-#define SD_RSP_TYPE_R1			0x01
-#define SD_RSP_TYPE_R1b			0x09
-#define SD_RSP_TYPE_R2			0x02
-#define SD_RSP_TYPE_R3			0x05
-#define SD_RSP_TYPE_R4			0x05
-#define SD_RSP_TYPE_R5			0x01
-#define SD_RSP_TYPE_R6			0x01
-#define SD_RSP_TYPE_R7			0x01
-
-/* SD_CONFIGURE3 */
-#define SD_RSP_80CLK_TIMEOUT_EN		0x01
-
-/* Card Transfer Reset Register */
-#define SPI_STOP			0x01
-#define XD_STOP				0x02
-#define SD_STOP				0x04
-#define MS_STOP				0x08
-#define SPI_CLR_ERR			0x10
-#define XD_CLR_ERR			0x20
-#define SD_CLR_ERR			0x40
-#define MS_CLR_ERR			0x80
-
-/* Card Data Source Register */
-#define PINGPONG_BUFFER			0x01
-#define RING_BUFFER			0x00
-
-/* Card Power Control Register */
-#define PMOS_STRG_MASK			0x10
-#define PMOS_STRG_800mA			0x10
-#define PMOS_STRG_400mA			0x00
-#define SD_POWER_OFF			0x03
-#define SD_PARTIAL_POWER_ON		0x01
-#define SD_POWER_ON			0x00
-#define SD_POWER_MASK			0x03
-#define MS_POWER_OFF			0x0C
-#define MS_PARTIAL_POWER_ON		0x04
-#define MS_POWER_ON			0x00
-#define MS_POWER_MASK			0x0C
-#define BPP_POWER_OFF			0x0F
-#define BPP_POWER_5_PERCENT_ON		0x0E
-#define BPP_POWER_10_PERCENT_ON		0x0C
-#define BPP_POWER_15_PERCENT_ON		0x08
-#define BPP_POWER_ON			0x00
-#define BPP_POWER_MASK			0x0F
-#define SD_VCC_PARTIAL_POWER_ON		0x02
-#define SD_VCC_POWER_ON			0x00
-
-/* PWR_GATE_CTRL */
-#define PWR_GATE_EN			0x01
-#define LDO3318_PWR_MASK		0x06
-#define LDO_ON				0x00
-#define LDO_SUSPEND			0x04
-#define LDO_OFF				0x06
-
-/* CARD_CLK_SOURCE */
-#define CRC_FIX_CLK			(0x00 << 0)
-#define CRC_VAR_CLK0			(0x01 << 0)
-#define CRC_VAR_CLK1			(0x02 << 0)
-#define SD30_FIX_CLK			(0x00 << 2)
-#define SD30_VAR_CLK0			(0x01 << 2)
-#define SD30_VAR_CLK1			(0x02 << 2)
-#define SAMPLE_FIX_CLK			(0x00 << 4)
-#define SAMPLE_VAR_CLK0			(0x01 << 4)
-#define SAMPLE_VAR_CLK1			(0x02 << 4)
-
-/* HOST_SLEEP_STATE */
-#define HOST_ENTER_S1			1
-#define HOST_ENTER_S3			2
+#define RTSX_PHASE_MAX			32
+#define RX_TUNING_CNT			3
 
 #define MS_CFG				0xFD40
+#define   SAMPLE_TIME_RISING		0x00
+#define   SAMPLE_TIME_FALLING		0x80
+#define   PUSH_TIME_DEFAULT		0x00
+#define   PUSH_TIME_ODD			0x40
+#define   NO_EXTEND_TOGGLE		0x00
+#define   EXTEND_TOGGLE_CHK		0x20
+#define   MS_BUS_WIDTH_1		0x00
+#define   MS_BUS_WIDTH_4		0x10
+#define   MS_BUS_WIDTH_8		0x18
+#define   MS_2K_SECTOR_MODE		0x04
+#define   MS_512_SECTOR_MODE		0x00
+#define   MS_TOGGLE_TIMEOUT_EN		0x00
+#define   MS_TOGGLE_TIMEOUT_DISEN	0x01
+#define MS_NO_CHECK_INT			0x02
 #define MS_TPC				0xFD41
 #define MS_TRANS_CFG			0xFD42
+#define   WAIT_INT			0x80
+#define   NO_WAIT_INT			0x00
+#define   NO_AUTO_READ_INT_REG		0x00
+#define   AUTO_READ_INT_REG		0x40
+#define   MS_CRC16_ERR			0x20
+#define   MS_RDY_TIMEOUT		0x10
+#define   MS_INT_CMDNK			0x08
+#define   MS_INT_BREQ			0x04
+#define   MS_INT_ERR			0x02
+#define   MS_INT_CED			0x01
 #define MS_TRANSFER			0xFD43
+#define   MS_TRANSFER_START		0x80
+#define   MS_TRANSFER_END		0x40
+#define   MS_TRANSFER_ERR		0x20
+#define   MS_BS_STATE			0x10
+#define   MS_TM_READ_BYTES		0x00
+#define   MS_TM_NORMAL_READ		0x01
+#define   MS_TM_WRITE_BYTES		0x04
+#define   MS_TM_NORMAL_WRITE		0x05
+#define   MS_TM_AUTO_READ		0x08
+#define   MS_TM_AUTO_WRITE		0x0C
 #define MS_INT_REG			0xFD44
 #define MS_BYTE_CNT			0xFD45
 #define MS_SECTOR_CNT_L			0xFD46
@@ -549,14 +192,90 @@
 #define MS_DBUS_H			0xFD48
 
 #define SD_CFG1				0xFDA0
+#define   SD_CLK_DIVIDE_0		0x00
+#define   SD_CLK_DIVIDE_256		0xC0
+#define   SD_CLK_DIVIDE_128		0x80
+#define   SD_BUS_WIDTH_1BIT		0x00
+#define   SD_BUS_WIDTH_4BIT		0x01
+#define   SD_BUS_WIDTH_8BIT		0x02
+#define   SD_ASYNC_FIFO_NOT_RST		0x10
+#define   SD_20_MODE			0x00
+#define   SD_DDR_MODE			0x04
+#define   SD_30_MODE			0x08
+#define   SD_CLK_DIVIDE_MASK		0xC0
 #define SD_CFG2				0xFDA1
+#define   SD_CALCULATE_CRC7		0x00
+#define   SD_NO_CALCULATE_CRC7		0x80
+#define   SD_CHECK_CRC16		0x00
+#define   SD_NO_CHECK_CRC16		0x40
+#define   SD_NO_CHECK_WAIT_CRC_TO	0x20
+#define   SD_WAIT_BUSY_END		0x08
+#define   SD_NO_WAIT_BUSY_END		0x00
+#define   SD_CHECK_CRC7			0x00
+#define   SD_NO_CHECK_CRC7		0x04
+#define   SD_RSP_LEN_0			0x00
+#define   SD_RSP_LEN_6			0x01
+#define   SD_RSP_LEN_17			0x02
+#define   SD_RSP_TYPE_R0		0x04
+#define   SD_RSP_TYPE_R1		0x01
+#define   SD_RSP_TYPE_R1b		0x09
+#define   SD_RSP_TYPE_R2		0x02
+#define   SD_RSP_TYPE_R3		0x05
+#define   SD_RSP_TYPE_R4		0x05
+#define   SD_RSP_TYPE_R5		0x01
+#define   SD_RSP_TYPE_R6		0x01
+#define   SD_RSP_TYPE_R7		0x01
 #define SD_CFG3				0xFDA2
+#define   SD_RSP_80CLK_TIMEOUT_EN	0x01
+
 #define SD_STAT1			0xFDA3
+#define   SD_CRC7_ERR			0x80
+#define   SD_CRC16_ERR			0x40
+#define   SD_CRC_WRITE_ERR		0x20
+#define   SD_CRC_WRITE_ERR_MASK		0x1C
+#define   GET_CRC_TIME_OUT		0x02
+#define   SD_TUNING_COMPARE_ERR		0x01
 #define SD_STAT2			0xFDA4
+#define   SD_RSP_80CLK_TIMEOUT		0x01
+
 #define SD_BUS_STAT			0xFDA5
+#define   SD_CLK_TOGGLE_EN		0x80
+#define   SD_CLK_FORCE_STOP		0x40
+#define   SD_DAT3_STATUS		0x10
+#define   SD_DAT2_STATUS		0x08
+#define   SD_DAT1_STATUS		0x04
+#define   SD_DAT0_STATUS		0x02
+#define   SD_CMD_STATUS			0x01
 #define SD_PAD_CTL			0xFDA6
+#define   SD_IO_USING_1V8		0x80
+#define   SD_IO_USING_3V3		0x7F
+#define   TYPE_A_DRIVING		0x00
+#define   TYPE_B_DRIVING		0x01
+#define   TYPE_C_DRIVING		0x02
+#define   TYPE_D_DRIVING		0x03
 #define SD_SAMPLE_POINT_CTL		0xFDA7
+#define   DDR_FIX_RX_DAT		0x00
+#define   DDR_VAR_RX_DAT		0x80
+#define   DDR_FIX_RX_DAT_EDGE		0x00
+#define   DDR_FIX_RX_DAT_14_DELAY	0x40
+#define   DDR_FIX_RX_CMD		0x00
+#define   DDR_VAR_RX_CMD		0x20
+#define   DDR_FIX_RX_CMD_POS_EDGE	0x00
+#define   DDR_FIX_RX_CMD_14_DELAY	0x10
+#define   SD20_RX_POS_EDGE		0x00
+#define   SD20_RX_14_DELAY		0x08
+#define SD20_RX_SEL_MASK		0x08
 #define SD_PUSH_POINT_CTL		0xFDA8
+#define   DDR_FIX_TX_CMD_DAT		0x00
+#define   DDR_VAR_TX_CMD_DAT		0x80
+#define   DDR_FIX_TX_DAT_14_TSU		0x00
+#define   DDR_FIX_TX_DAT_12_TSU		0x40
+#define   DDR_FIX_TX_CMD_NEG_EDGE	0x00
+#define   DDR_FIX_TX_CMD_14_AHEAD	0x20
+#define   SD20_TX_NEG_EDGE		0x00
+#define   SD20_TX_14_AHEAD		0x10
+#define   SD20_TX_SEL_MASK		0x10
+#define   DDR_VAR_SDCLK_POL_SWAP	0x01
 #define SD_CMD0				0xFDA9
 #define   SD_CMD_START			0x40
 #define SD_CMD1				0xFDAA
@@ -569,14 +288,46 @@
 #define SD_BLOCK_CNT_L			0xFDB1
 #define SD_BLOCK_CNT_H			0xFDB2
 #define SD_TRANSFER			0xFDB3
+#define   SD_TRANSFER_START		0x80
+#define   SD_TRANSFER_END		0x40
+#define   SD_STAT_IDLE			0x20
+#define   SD_TRANSFER_ERR		0x10
+#define   SD_TM_NORMAL_WRITE		0x00
+#define   SD_TM_AUTO_WRITE_3		0x01
+#define   SD_TM_AUTO_WRITE_4		0x02
+#define   SD_TM_AUTO_READ_3		0x05
+#define   SD_TM_AUTO_READ_4		0x06
+#define   SD_TM_CMD_RSP			0x08
+#define   SD_TM_AUTO_WRITE_1		0x09
+#define   SD_TM_AUTO_WRITE_2		0x0A
+#define   SD_TM_NORMAL_READ		0x0C
+#define   SD_TM_AUTO_READ_1		0x0D
+#define   SD_TM_AUTO_READ_2		0x0E
+#define   SD_TM_AUTO_TUNING		0x0F
 #define SD_CMD_STATE			0xFDB5
+#define   SD_CMD_IDLE			0x80
+
 #define SD_DATA_STATE			0xFDB6
+#define   SD_DATA_IDLE			0x80
 
 #define SRCTL				0xFC13
 
 #define DCM_DRP_CTL			0xFC23
+#define   DCM_RESET			0x08
+#define   DCM_LOCKED			0x04
+#define   DCM_208M			0x00
+#define   DCM_TX			0x01
+#define   DCM_RX			0x02
 #define DCM_DRP_TRIG			0xFC24
+#define   DRP_START			0x80
+#define   DRP_DONE			0x40
 #define DCM_DRP_CFG			0xFC25
+#define   DRP_WRITE			0x80
+#define   DRP_READ			0x00
+#define   DCM_WRITE_ADDRESS_50		0x50
+#define   DCM_WRITE_ADDRESS_51		0x51
+#define   DCM_READ_ADDRESS_00		0x00
+#define   DCM_READ_ADDRESS_51		0x51
 #define DCM_DRP_WR_DATA_L		0xFC26
 #define DCM_DRP_WR_DATA_H		0xFC27
 #define DCM_DRP_RD_DATA_L		0xFC28
@@ -587,42 +338,153 @@
 #define SD_DCMPS1_CTL			0xFC2D
 #define SD_VPTX_CTL			SD_VPCLK0_CTL
 #define SD_VPRX_CTL			SD_VPCLK1_CTL
+#define   PHASE_CHANGE			0x80
+#define   PHASE_NOT_RESET		0x40
 #define SD_DCMPS_TX_CTL			SD_DCMPS0_CTL
 #define SD_DCMPS_RX_CTL			SD_DCMPS1_CTL
+#define   DCMPS_CHANGE			0x80
+#define   DCMPS_CHANGE_DONE		0x40
+#define   DCMPS_ERROR			0x20
+#define   DCMPS_CURRENT_PHASE		0x1F
 #define CARD_CLK_SOURCE			0xFC2E
-
+#define   CRC_FIX_CLK			(0x00 << 0)
+#define   CRC_VAR_CLK0			(0x01 << 0)
+#define   CRC_VAR_CLK1			(0x02 << 0)
+#define   SD30_FIX_CLK			(0x00 << 2)
+#define   SD30_VAR_CLK0			(0x01 << 2)
+#define   SD30_VAR_CLK1			(0x02 << 2)
+#define   SAMPLE_FIX_CLK		(0x00 << 4)
+#define   SAMPLE_VAR_CLK0		(0x01 << 4)
+#define   SAMPLE_VAR_CLK1		(0x02 << 4)
 #define CARD_PWR_CTL			0xFD50
+#define   PMOS_STRG_MASK		0x10
+#define   PMOS_STRG_800mA		0x10
+#define   PMOS_STRG_400mA		0x00
+#define   SD_POWER_OFF			0x03
+#define   SD_PARTIAL_POWER_ON		0x01
+#define   SD_POWER_ON			0x00
+#define   SD_POWER_MASK			0x03
+#define   MS_POWER_OFF			0x0C
+#define   MS_PARTIAL_POWER_ON		0x04
+#define   MS_POWER_ON			0x00
+#define   MS_POWER_MASK			0x0C
+#define   BPP_POWER_OFF			0x0F
+#define   BPP_POWER_5_PERCENT_ON	0x0E
+#define   BPP_POWER_10_PERCENT_ON	0x0C
+#define   BPP_POWER_15_PERCENT_ON	0x08
+#define   BPP_POWER_ON			0x00
+#define   BPP_POWER_MASK		0x0F
+#define   SD_VCC_PARTIAL_POWER_ON	0x02
+#define   SD_VCC_POWER_ON		0x00
 #define CARD_CLK_SWITCH			0xFD51
 #define RTL8411B_PACKAGE_MODE		0xFD51
 #define CARD_SHARE_MODE			0xFD52
+#define   CARD_SHARE_MASK		0x0F
+#define   CARD_SHARE_MULTI_LUN		0x00
+#define   CARD_SHARE_NORMAL		0x00
+#define   CARD_SHARE_48_SD		0x04
+#define   CARD_SHARE_48_MS		0x08
+#define   CARD_SHARE_BAROSSA_SD		0x01
+#define   CARD_SHARE_BAROSSA_MS		0x02
 #define CARD_DRIVE_SEL			0xFD53
+#define   MS_DRIVE_8mA			(0x01 << 6)
+#define   MMC_DRIVE_8mA			(0x01 << 4)
+#define   XD_DRIVE_8mA			(0x01 << 2)
+#define   GPIO_DRIVE_8mA		0x01
+#define RTS5209_CARD_DRIVE_DEFAULT	(MS_DRIVE_8mA | MMC_DRIVE_8mA |\
+					XD_DRIVE_8mA | GPIO_DRIVE_8mA)
+#define RTL8411_CARD_DRIVE_DEFAULT	(MS_DRIVE_8mA | MMC_DRIVE_8mA |\
+					XD_DRIVE_8mA)
+#define RTSX_CARD_DRIVE_DEFAULT		(MS_DRIVE_8mA | GPIO_DRIVE_8mA)
+
 #define CARD_STOP			0xFD54
+#define   SPI_STOP			0x01
+#define   XD_STOP			0x02
+#define   SD_STOP			0x04
+#define   MS_STOP			0x08
+#define   SPI_CLR_ERR			0x10
+#define   XD_CLR_ERR			0x20
+#define   SD_CLR_ERR			0x40
+#define   MS_CLR_ERR			0x80
 #define CARD_OE				0xFD55
+#define   SD_OUTPUT_EN			0x04
+#define   MS_OUTPUT_EN			0x08
 #define CARD_AUTO_BLINK			0xFD56
 #define CARD_GPIO_DIR			0xFD57
 #define CARD_GPIO			0xFD58
 #define CARD_DATA_SOURCE		0xFD5B
+#define   PINGPONG_BUFFER		0x01
+#define   RING_BUFFER			0x00
 #define SD30_CLK_DRIVE_SEL		0xFD5A
+#define   DRIVER_TYPE_A			0x05
+#define   DRIVER_TYPE_B			0x03
+#define   DRIVER_TYPE_C			0x02
+#define   DRIVER_TYPE_D			0x01
 #define CARD_SELECT			0xFD5C
+#define   SD_MOD_SEL			2
+#define   MS_MOD_SEL			3
 #define SD30_DRIVE_SEL			0xFD5E
+#define   CFG_DRIVER_TYPE_A		0x02
+#define   CFG_DRIVER_TYPE_B		0x03
+#define   CFG_DRIVER_TYPE_C		0x01
+#define   CFG_DRIVER_TYPE_D		0x00
 #define SD30_CMD_DRIVE_SEL		0xFD5E
 #define SD30_DAT_DRIVE_SEL		0xFD5F
 #define CARD_CLK_EN			0xFD69
+#define   SD_CLK_EN			0x04
+#define   MS_CLK_EN			0x08
 #define SDIO_CTRL			0xFD6B
 #define CD_PAD_CTL			0xFD73
-
+#define   CD_DISABLE_MASK		0x07
+#define   MS_CD_DISABLE			0x04
+#define   SD_CD_DISABLE			0x02
+#define   XD_CD_DISABLE			0x01
+#define   CD_DISABLE			0x07
+#define   CD_ENABLE			0x00
+#define   MS_CD_EN_ONLY			0x03
+#define   SD_CD_EN_ONLY			0x05
+#define   XD_CD_EN_ONLY			0x06
+#define   FORCE_CD_LOW_MASK		0x38
+#define   FORCE_CD_XD_LOW		0x08
+#define   FORCE_CD_SD_LOW		0x10
+#define   FORCE_CD_MS_LOW		0x20
+#define   CD_AUTO_DISABLE		0x40
 #define FPDCTL				0xFC00
+#define   SSC_POWER_DOWN		0x01
+#define   SD_OC_POWER_DOWN		0x02
+#define   ALL_POWER_DOWN		0x07
+#define   OC_POWER_DOWN			0x06
 #define PDINFO				0xFC01
 
 #define CLK_CTL				0xFC02
+#define   CHANGE_CLK			0x01
+#define   CLK_LOW_FREQ			0x01
+
 #define CLK_DIV				0xFC03
+#define   CLK_DIV_1			0x01
+#define   CLK_DIV_2			0x02
+#define   CLK_DIV_4			0x03
+#define   CLK_DIV_8			0x04
 #define CLK_SEL				0xFC04
 
 #define SSC_DIV_N_0			0xFC0F
 #define SSC_DIV_N_1			0xFC10
 #define SSC_CTL1			0xFC11
+#define    SSC_RSTB			0x80
+#define    SSC_8X_EN			0x40
+#define    SSC_FIX_FRAC			0x20
+#define    SSC_SEL_1M			0x00
+#define    SSC_SEL_2M			0x08
+#define    SSC_SEL_4M			0x10
+#define    SSC_SEL_8M			0x18
 #define SSC_CTL2			0xFC12
-
+#define    SSC_DEPTH_MASK		0x07
+#define    SSC_DEPTH_DISALBE		0x00
+#define    SSC_DEPTH_4M			0x01
+#define    SSC_DEPTH_2M			0x02
+#define    SSC_DEPTH_1M			0x03
+#define    SSC_DEPTH_500K		0x04
+#define    SSC_DEPTH_250K		0x05
 #define RCCTL				0xFC14
 
 #define FPGA_PULL_CTL			0xFC1D
@@ -630,6 +492,24 @@
 #define GPIO_CTL			0xFC1F
 
 #define LDO_CTL				0xFC1E
+#define   BPP_ASIC_1V7			0x00
+#define   BPP_ASIC_1V8			0x01
+#define   BPP_ASIC_1V9			0x02
+#define   BPP_ASIC_2V0			0x03
+#define   BPP_ASIC_2V7			0x04
+#define   BPP_ASIC_2V8			0x05
+#define   BPP_ASIC_3V2			0x06
+#define   BPP_ASIC_3V3			0x07
+#define   BPP_REG_TUNED18		0x07
+#define   BPP_TUNED18_SHIFT_8402	5
+#define   BPP_TUNED18_SHIFT_8411	4
+#define   BPP_PAD_MASK			0x04
+#define   BPP_PAD_3V3			0x04
+#define   BPP_PAD_1V8			0x00
+#define   BPP_LDO_POWB			0x03
+#define   BPP_LDO_ON			0x00
+#define   BPP_LDO_SUSPEND		0x02
+#define   BPP_LDO_OFF			0x03
 #define SYS_VER				0xFC32
 
 #define CARD_PULL_CTL1			0xFD60
@@ -642,6 +522,10 @@
 /* PCI Express Related Registers */
 #define IRQEN0				0xFE20
 #define IRQSTAT0			0xFE21
+#define    DMA_DONE_INT			0x80
+#define    SUSPEND_INT			0x40
+#define    LINK_RDY_INT			0x20
+#define    LINK_DOWN_INT		0x10
 #define IRQEN1				0xFE22
 #define IRQSTAT1			0xFE23
 #define TLPRIEN				0xFE24
@@ -653,6 +537,16 @@
 #define DMATC2				0xFE2A
 #define DMATC3				0xFE2B
 #define DMACTL				0xFE2C
+#define   DMA_RST			0x80
+#define   DMA_BUSY			0x04
+#define   DMA_DIR_TO_CARD		0x00
+#define   DMA_DIR_FROM_CARD		0x02
+#define   DMA_EN			0x01
+#define   DMA_128			(0 << 4)
+#define   DMA_256			(1 << 4)
+#define   DMA_512			(2 << 4)
+#define   DMA_1024			(3 << 4)
+#define   DMA_PACK_SIZE_MASK		0x30
 #define BCTL				0xFE2D
 #define RBBC0				0xFE2E
 #define RBBC1				0xFE2F
@@ -693,11 +587,19 @@
 #define RESET_LOAD_REG			0xFE5E
 #define EFUSE_CONTENT			0xFE5F
 #define HOST_SLEEP_STATE		0xFE60
+#define   HOST_ENTER_S1			1
+#define   HOST_ENTER_S3			2
+
 #define SDIO_CFG			0xFE70
 
 #define NFTS_TX_CTRL			0xFE72
 
 #define PWR_GATE_CTRL			0xFE75
+#define   PWR_GATE_EN			0x01
+#define   LDO3318_PWR_MASK		0x06
+#define   LDO_ON			0x00
+#define   LDO_SUSPEND			0x04
+#define   LDO_OFF			0x06
 #define PWD_SUSPEND_EN			0xFE76
 #define LDO_PWR_SEL			0xFE78
 
-- 
1.9.1

