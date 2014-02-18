Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaBRO5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:57:32 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:46497 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaBRO5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:23 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 21/35] mtd: st_spi_fsm: Provide the default read/write configurations
Date: Tue, 18 Feb 2014 14:55:48 +0000
Message-Id: <1392735362-1245-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
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

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 208b6c3..576712c 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -375,6 +375,33 @@ static struct flash_info flash_types[] = {
 	{ NULL, 0x000000, 0, 0, 0, 0, 0, NULL },
 };
 
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
+	{0x00,			 0,			0, 0, 0, 0x00, 0, 0},
+};
+
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
 
 static struct stfsm_seq stfsm_seq_read_jedec = {
-- 
1.8.3.2

