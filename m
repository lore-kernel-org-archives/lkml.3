Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3K2MTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:19:45 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:64821 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab3K2MTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:19:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 02/36] mtd: st_spi_fsm: Supply all register address and bit logic defines
Date: Fri, 29 Nov 2013 12:18:51 +0000
Message-Id: <1385727565-25794-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we provide the FSM's register addresses, register bit names/offsets
and some commands which will prove useful as we start bulk the FMS's
driver out with functionality.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.h | 164 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index df45e1a..b420a43 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -16,6 +16,170 @@
 #ifndef ST_SPI_FSM_H
 #define ST_SPI_FSM_H
 
+/*
+ * FSM SPI Controller Registers
+ */
+#define SPI_CLOCKDIV			0x0010
+#define SPI_MODESELECT			0x0018
+#define SPI_CONFIGDATA			0x0020
+#define SPI_STA_MODE_CHANGE		0x0028
+#define SPI_FAST_SEQ_TRANSFER_SIZE	0x0100
+#define SPI_FAST_SEQ_ADD1		0x0104
+#define SPI_FAST_SEQ_ADD2		0x0108
+#define SPI_FAST_SEQ_ADD_CFG		0x010c
+#define SPI_FAST_SEQ_OPC1		0x0110
+#define SPI_FAST_SEQ_OPC2		0x0114
+#define SPI_FAST_SEQ_OPC3		0x0118
+#define SPI_FAST_SEQ_OPC4		0x011c
+#define SPI_FAST_SEQ_OPC5		0x0120
+#define SPI_MODE_BITS			0x0124
+#define SPI_DUMMY_BITS			0x0128
+#define SPI_FAST_SEQ_FLASH_STA_DATA	0x012c
+#define SPI_FAST_SEQ_1			0x0130
+#define SPI_FAST_SEQ_2			0x0134
+#define SPI_FAST_SEQ_3			0x0138
+#define SPI_FAST_SEQ_4			0x013c
+#define SPI_FAST_SEQ_CFG		0x0140
+#define SPI_FAST_SEQ_STA		0x0144
+#define SPI_QUAD_BOOT_SEQ_INIT_1	0x0148
+#define SPI_QUAD_BOOT_SEQ_INIT_2	0x014c
+#define SPI_QUAD_BOOT_READ_SEQ_1	0x0150
+#define SPI_QUAD_BOOT_READ_SEQ_2	0x0154
+#define SPI_PROGRAM_ERASE_TIME		0x0158
+#define SPI_MULT_PAGE_REPEAT_SEQ_1	0x015c
+#define SPI_MULT_PAGE_REPEAT_SEQ_2	0x0160
+#define SPI_STATUS_WR_TIME_REG		0x0164
+#define SPI_FAST_SEQ_DATA_REG		0x0300
+
+/*
+ * Register: SPI_MODESELECT
+ */
+#define SPI_MODESELECT_CONTIG		0x01
+#define SPI_MODESELECT_FASTREAD		0x02
+#define SPI_MODESELECT_DUALIO		0x04
+#define SPI_MODESELECT_FSM		0x08
+#define SPI_MODESELECT_QUADBOOT		0x10
+
+/*
+ * Register: SPI_CONFIGDATA
+ */
+#define SPI_CFG_DEVICE_ST		0x1
+#define SPI_CFG_DEVICE_ATMEL		0x4
+#define SPI_CFG_MIN_CS_HIGH(x)		(((x) & 0xfff) << 4)
+#define SPI_CFG_CS_SETUPHOLD(x)		(((x) & 0xff) << 16)
+#define SPI_CFG_DATA_HOLD(x)		(((x) & 0xff) << 24)
+
+/*
+ * Register: SPI_FAST_SEQ_TRANSFER_SIZE
+ */
+#define TRANSFER_SIZE(x)		((x) * 8)
+
+/*
+ * Register: SPI_FAST_SEQ_ADD_CFG
+ */
+#define ADR_CFG_CYCLES_ADD1(x)		((x) << 0)
+#define ADR_CFG_PADS_1_ADD1		(0x0 << 6)
+#define ADR_CFG_PADS_2_ADD1		(0x1 << 6)
+#define ADR_CFG_PADS_4_ADD1		(0x3 << 6)
+#define ADR_CFG_CSDEASSERT_ADD1		(1   << 8)
+#define ADR_CFG_CYCLES_ADD2(x)		((x) << (0+16))
+#define ADR_CFG_PADS_1_ADD2		(0x0 << (6+16))
+#define ADR_CFG_PADS_2_ADD2		(0x1 << (6+16))
+#define ADR_CFG_PADS_4_ADD2		(0x3 << (6+16))
+#define ADR_CFG_CSDEASSERT_ADD2		(1   << (8+16))
+
+/*
+ * Register: SPI_FAST_SEQ_n
+ */
+#define SEQ_OPC_OPCODE(x)		((x) << 0)
+#define SEQ_OPC_CYCLES(x)		((x) << 8)
+#define SEQ_OPC_PADS_1			(0x0 << 14)
+#define SEQ_OPC_PADS_2			(0x1 << 14)
+#define SEQ_OPC_PADS_4			(0x3 << 14)
+#define SEQ_OPC_CSDEASSERT		(1   << 16)
+
+/*
+ * Register: SPI_FAST_SEQ_CFG
+ */
+#define SEQ_CFG_STARTSEQ		(1 << 0)
+#define SEQ_CFG_SWRESET			(1 << 5)
+#define SEQ_CFG_CSDEASSERT		(1 << 6)
+#define SEQ_CFG_READNOTWRITE		(1 << 7)
+#define SEQ_CFG_ERASE			(1 << 8)
+#define SEQ_CFG_PADS_1			(0x0 << 16)
+#define SEQ_CFG_PADS_2			(0x1 << 16)
+#define SEQ_CFG_PADS_4			(0x3 << 16)
+
+/*
+ * Register: SPI_MODE_BITS
+ */
+#define MODE_DATA(x)			(x & 0xff)
+#define MODE_CYCLES(x)			((x & 0x3f) << 16)
+#define MODE_PADS_1			(0x0 << 22)
+#define MODE_PADS_2			(0x1 << 22)
+#define MODE_PADS_4			(0x3 << 22)
+#define DUMMY_CSDEASSERT		(1   << 24)
+
+/*
+ * Register: SPI_DUMMY_BITS
+ */
+#define DUMMY_CYCLES(x)			((x & 0x3f) << 16)
+#define DUMMY_PADS_1			(0x0 << 22)
+#define DUMMY_PADS_2			(0x1 << 22)
+#define DUMMY_PADS_4			(0x3 << 22)
+#define DUMMY_CSDEASSERT		(1   << 24)
+
+/*
+ * Register: SPI_FAST_SEQ_FLASH_STA_DATA
+ */
+#define STA_DATA_BYTE1(x)		((x & 0xff) << 0)
+#define STA_DATA_BYTE2(x)		((x & 0xff) << 8)
+#define STA_PADS_1			(0x0 << 16)
+#define STA_PADS_2			(0x1 << 16)
+#define STA_PADS_4			(0x3 << 16)
+#define STA_CSDEASSERT			(0x1 << 20)
+#define STA_RDNOTWR			(0x1 << 21)
+
+/*
+ * FSM SPI Instruction Opcodes
+ */
+#define STFSM_OPC_CMD			0x1
+#define STFSM_OPC_ADD			0x2
+#define STFSM_OPC_STA			0x3
+#define STFSM_OPC_MODE			0x4
+#define STFSM_OPC_DUMMY		0x5
+#define STFSM_OPC_DATA			0x6
+#define STFSM_OPC_WAIT			0x7
+#define STFSM_OPC_JUMP			0x8
+#define STFSM_OPC_GOTO			0x9
+#define STFSM_OPC_STOP			0xF
+
+/*
+ * FSM SPI Instructions (== opcode + operand).
+ */
+#define STFSM_INSTR(cmd, op)		((cmd) | ((op) << 4))
+
+#define STFSM_INST_CMD1			STFSM_INSTR(STFSM_OPC_CMD,	1)
+#define STFSM_INST_CMD2			STFSM_INSTR(STFSM_OPC_CMD,	2)
+#define STFSM_INST_CMD3			STFSM_INSTR(STFSM_OPC_CMD,	3)
+#define STFSM_INST_CMD4			STFSM_INSTR(STFSM_OPC_CMD,	4)
+#define STFSM_INST_CMD5			STFSM_INSTR(STFSM_OPC_CMD,	5)
+#define STFSM_INST_ADD1			STFSM_INSTR(STFSM_OPC_ADD,	1)
+#define STFSM_INST_ADD2			STFSM_INSTR(STFSM_OPC_ADD,	2)
+
+#define STFSM_INST_DATA_WRITE		STFSM_INSTR(STFSM_OPC_DATA,	1)
+#define STFSM_INST_DATA_READ		STFSM_INSTR(STFSM_OPC_DATA,	2)
+
+#define STFSM_INST_STA_RD1		STFSM_INSTR(STFSM_OPC_STA,	0x1)
+#define STFSM_INST_STA_WR1		STFSM_INSTR(STFSM_OPC_STA,	0x1)
+#define STFSM_INST_STA_RD2		STFSM_INSTR(STFSM_OPC_STA,	0x2)
+#define STFSM_INST_STA_WR1_2		STFSM_INSTR(STFSM_OPC_STA,	0x3)
+
+#define STFSM_INST_MODE			STFSM_INSTR(STFSM_OPC_MODE,	0)
+#define STFSM_INST_DUMMY		STFSM_INSTR(STFSM_OPC_DUMMY,	0)
+#define STFSM_INST_WAIT			STFSM_INSTR(STFSM_OPC_WAIT,	0)
+#define STFSM_INST_STOP			STFSM_INSTR(STFSM_OPC_STOP,	0)
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
-- 
1.8.3.2

