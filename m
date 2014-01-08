Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaAHN7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:59:33 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47133 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaAHNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:48:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v4 06/37] mtd: st_spi_fsm: Supply defines for the possible flash command opcodes
Date: Wed,  8 Jan 2014 13:46:49 +0000
Message-Id: <1389188840-14306-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flash chip commands are issued using a set of predefined opcodes. These
are mostly the same for all flash devices, but do differ on occasion.
This patch supplies the majority of the key ones which will be used in
this driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 0eba759..bb0f20a 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -194,6 +194,44 @@
 
 #define STFSM_FLASH_SAFE_FREQ  10000000UL                         /* 10 MHz */
 
+/* Flash Commands */
+#define FLASH_CMD_WREN         0x06
+#define FLASH_CMD_WRDI         0x04
+#define FLASH_CMD_RDID         0x9f
+#define FLASH_CMD_RDSR         0x05
+#define FLASH_CMD_RDSR2                0x35
+#define FLASH_CMD_WRSR         0x01
+#define FLASH_CMD_SE_4K                0x20
+#define FLASH_CMD_SE_32K       0x52
+#define FLASH_CMD_SE           0xd8
+#define FLASH_CMD_CHIPERASE    0xc7
+#define FLASH_CMD_WRVCR                0x81
+#define FLASH_CMD_RDVCR                0x85
+
+#define FLASH_CMD_READ         0x03    /* READ */
+#define FLASH_CMD_READ_FAST    0x0b    /* FAST READ */
+#define FLASH_CMD_READ_1_1_2   0x3b    /* DUAL OUTPUT READ */
+#define FLASH_CMD_READ_1_2_2   0xbb    /* DUAL I/O READ */
+#define FLASH_CMD_READ_1_1_4   0x6b    /* QUAD OUTPUT READ */
+#define FLASH_CMD_READ_1_4_4   0xeb    /* QUAD I/O READ */
+
+#define FLASH_CMD_WRITE                0x02    /* PAGE PROGRAM */
+#define FLASH_CMD_WRITE_1_1_2  0xa2    /* DUAL INPUT PROGRAM */
+#define FLASH_CMD_WRITE_1_2_2  0xd2    /* DUAL INPUT EXT PROGRAM */
+#define FLASH_CMD_WRITE_1_1_4  0x32    /* QUAD INPUT PROGRAM */
+#define FLASH_CMD_WRITE_1_4_4  0x12    /* QUAD INPUT EXT PROGRAM */
+
+#define FLASH_CMD_EN4B_ADDR    0xb7    /* Enter 4-byte address mode */
+#define FLASH_CMD_EX4B_ADDR    0xe9    /* Exit 4-byte address mode */
+
+/* READ commands with 32-bit addressing (N25Q256 and S25FLxxxS) */
+#define FLASH_CMD_READ4                0x13
+#define FLASH_CMD_READ4_FAST   0x0c
+#define FLASH_CMD_READ4_1_1_2  0x3c
+#define FLASH_CMD_READ4_1_2_2  0xbc
+#define FLASH_CMD_READ4_1_1_4  0x6c
+#define FLASH_CMD_READ4_1_4_4  0xec
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
-- 
1.8.3.2

