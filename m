Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3KVQZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:25:03 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43671 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3KVQYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:24:23 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/23] mtd: st_spi_fsm: Provide the default read/write configurations
Date: Fri, 22 Nov 2013 16:22:59 +0000
Message-Id: <1385137380-28968-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message sequences can vary depending on how many pads (lines) are
required to address the chip (mode & dummy), how many data pads (lines)
are required to write out to the chip which will determine speed
amongst other things which are detailed by the SFDP specification. We
are able to use multiple configurations for each chip, but they need
to me matched to a device's capabilities. These configurations are
listed in preference order - most preferred first.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 475bbd1..2b7df68 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -30,6 +30,33 @@
 
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
 
+/*
+ * FSM message sequence configurations:
+ *
+ * All configs are presented in order of preference
+ */
+
+/* Default READ configurations, in order of preference */
+static struct seq_rw_config default_read_configs[] = {
+	{FLASH_FLAG_READ_1_4_4, FLASH_CMD_READ_1_4_4,	0, 4, 4, 0x00, 2, 4},
+	{FLASH_FLAG_READ_1_1_4, FLASH_CMD_READ_1_1_4,	0, 1, 4, 0x00, 4, 0},
+	{FLASH_FLAG_READ_1_2_2, FLASH_CMD_READ_1_2_2,	0, 2, 2, 0x00, 4, 0},
+	{FLASH_FLAG_READ_1_1_2, FLASH_CMD_READ_1_1_2,	0, 1, 2, 0x00, 0, 8},
+	{FLASH_FLAG_READ_FAST,	FLASH_CMD_READ_FAST,	0, 1, 1, 0x00, 0, 8},
+	{FLASH_FLAG_READ_WRITE, FLASH_CMD_READ,		0, 1, 1, 0x00, 0, 0},
+	{0x00,			0,			0, 0, 0, 0x00, 0, 0},
+};
+
+/* Default WRITE configurations */
+static struct seq_rw_config default_write_configs[] = {
+	{FLASH_FLAG_WRITE_1_4_4, FLASH_CMD_WRITE_1_4_4, 1, 4, 4, 0x00, 0, 0},
+	{FLASH_FLAG_WRITE_1_1_4, FLASH_CMD_WRITE_1_1_4, 1, 1, 4, 0x00, 0, 0},
+	{FLASH_FLAG_WRITE_1_2_2, FLASH_CMD_WRITE_1_2_2, 1, 2, 2, 0x00, 0, 0},
+	{FLASH_FLAG_WRITE_1_1_2, FLASH_CMD_WRITE_1_1_2, 1, 1, 2, 0x00, 0, 0},
+	{FLASH_FLAG_READ_WRITE,  FLASH_CMD_WRITE,       1, 1, 1, 0x00, 0, 0},
+	{0x00,			 0,			 0, 0, 0, 0x00, 0, 0},
+};
+
 static struct stfsm_seq stfsm_seq_read_jedec = {
 	.data_size = TRANSFER_SIZE(8),
 	.seq_opc[0] = (SEQ_OPC_PADS_1 |
-- 
1.8.1.2

