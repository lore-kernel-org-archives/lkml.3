Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaAWKcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:32:07 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:37898 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaAWKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:01 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 08/37] mtd: devices: Provide header for shared OPCODEs and SFDP commands
Date: Thu, 23 Jan 2014 10:30:56 +0000
Message-Id: <1390473085-24626-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JEDEC have helped to standardise a great deal of the commands which
can be issued to a Serial Flash devices. Many of the Serial Flash
Discoverable Parameters (SFDP) commands are generic across devices.
This patch provides a shared point where these commands can be
defined.

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/serial_flash_cmds.h | 81 +++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.c        |  2 +
 2 files changed, 83 insertions(+)
 create mode 100644 drivers/mtd/devices/serial_flash_cmds.h

diff --git a/drivers/mtd/devices/serial_flash_cmds.h b/drivers/mtd/devices/serial_flash_cmds.h
new file mode 100644
index 0000000..4f0c2c7
--- /dev/null
+++ b/drivers/mtd/devices/serial_flash_cmds.h
@@ -0,0 +1,81 @@
+/*
+ * Generic/SFDP Flash Commands and Device Capabilities
+ *
+ * Copyright (C) 2013 Lee Jones <lee.jones@lianro.org>
+ *
+ * This code is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _MTD_SERIAL_FLASH_CMDS_H
+#define _MTD_SERIAL_FLASH_CMDS_H
+
+/* Generic Flash Commands/OPCODEs */
+#define FLASH_CMD_WREN		0x06
+#define FLASH_CMD_WRDI		0x04
+#define FLASH_CMD_RDID		0x9f
+#define FLASH_CMD_RDSR		0x05
+#define FLASH_CMD_RDSR2		0x35
+#define FLASH_CMD_WRSR		0x01
+#define FLASH_CMD_SE_4K		0x20
+#define FLASH_CMD_SE_32K	0x52
+#define FLASH_CMD_SE		0xd8
+#define FLASH_CMD_CHIPERASE	0xc7
+#define FLASH_CMD_WRVCR		0x81
+#define FLASH_CMD_RDVCR		0x85
+
+/* JEDEC Standard - Serial Flash Discoverable Parmeters (SFDP) Commands */
+#define FLASH_CMD_READ		0x03	/* READ */
+#define FLASH_CMD_READ_FAST	0x0b	/* FAST READ */
+#define FLASH_CMD_READ_1_1_2	0x3b	/* DUAL OUTPUT READ */
+#define FLASH_CMD_READ_1_2_2	0xbb	/* DUAL I/O READ */
+#define FLASH_CMD_READ_1_1_4	0x6b	/* QUAD OUTPUT READ */
+#define FLASH_CMD_READ_1_4_4	0xeb	/* QUAD I/O READ */
+
+#define FLASH_CMD_WRITE		0x02	/* PAGE PROGRAM */
+#define FLASH_CMD_WRITE_1_1_2	0xa2	/* DUAL INPUT PROGRAM */
+#define FLASH_CMD_WRITE_1_2_2	0xd2	/* DUAL INPUT EXT PROGRAM */
+#define FLASH_CMD_WRITE_1_1_4	0x32	/* QUAD INPUT PROGRAM */
+#define FLASH_CMD_WRITE_1_4_4	0x12	/* QUAD INPUT EXT PROGRAM */
+
+#define FLASH_CMD_EN4B_ADDR	0xb7	/* Enter 4-byte address mode */
+#define FLASH_CMD_EX4B_ADDR	0xe9	/* Exit 4-byte address mode */
+
+/* READ commands with 32-bit addressing */
+#define FLASH_CMD_READ4		0x13
+#define FLASH_CMD_READ4_FAST	0x0c
+#define FLASH_CMD_READ4_1_1_2	0x3c
+#define FLASH_CMD_READ4_1_2_2	0xbc
+#define FLASH_CMD_READ4_1_1_4	0x6c
+#define FLASH_CMD_READ4_1_4_4	0xec
+
+/* Configuration flags */
+#define FLASH_FLAG_SINGLE	0x000000ff
+#define FLASH_FLAG_READ_WRITE	0x00000001
+#define FLASH_FLAG_READ_FAST	0x00000002
+#define FLASH_FLAG_SE_4K	0x00000004
+#define FLASH_FLAG_SE_32K	0x00000008
+#define FLASH_FLAG_CE		0x00000010
+#define FLASH_FLAG_32BIT_ADDR	0x00000020
+#define FLASH_FLAG_RESET	0x00000040
+#define FLASH_FLAG_DYB_LOCKING	0x00000080
+
+#define FLASH_FLAG_DUAL		0x0000ff00
+#define FLASH_FLAG_READ_1_1_2	0x00000100
+#define FLASH_FLAG_READ_1_2_2	0x00000200
+#define FLASH_FLAG_READ_2_2_2	0x00000400
+#define FLASH_FLAG_WRITE_1_1_2	0x00001000
+#define FLASH_FLAG_WRITE_1_2_2	0x00002000
+#define FLASH_FLAG_WRITE_2_2_2	0x00004000
+
+#define FLASH_FLAG_QUAD		0x00ff0000
+#define FLASH_FLAG_READ_1_1_4	0x00010000
+#define FLASH_FLAG_READ_1_4_4	0x00020000
+#define FLASH_FLAG_READ_4_4_4	0x00040000
+#define FLASH_FLAG_WRITE_1_1_4	0x00100000
+#define FLASH_FLAG_WRITE_1_4_4	0x00200000
+#define FLASH_FLAG_WRITE_4_4_4	0x00400000
+
+#endif /* _MTD_SERIAL_FLASH_CMDS_H */
diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 8a10f16..fe4f3c1 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -21,6 +21,8 @@
 #include <linux/io.h>
 #include <linux/of.h>
 
+#include "serial_flash_cmds.h"
+
 /*
  * FSM SPI Controller Registers
  */
-- 
1.8.3.2

