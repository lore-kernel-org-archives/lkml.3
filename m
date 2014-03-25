Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaCYIVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:34 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54209 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaCYIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 38/47] mtd: nand: stm_nand_bch: check WP (FLEX)
Date: Tue, 25 Mar 2014 08:19:55 +0000
Message-Id: <1395735604-26706-39-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return status of the Write Protect bit for the NAND device.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 3853e7a..18601e5 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -543,6 +543,22 @@ static void flex_addr(struct nandi_controller *nandi,
 	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
 }
 
+/*
+ * Hamming-FLEX operations (optimised replacements for nand_base.c versions)
+ */
+static int flex_check_wp(struct nandi_controller *nandi)
+{
+	uint8_t status;
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	flex_cmd(nandi, NAND_CMD_STATUS);
+
+	status = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
+
+	return status & NAND_STATUS_WP ? 0 : 1;
+}
+
 static int flex_read_raw(struct nandi_controller *nandi,
 			 uint32_t page_addr,
 			 uint32_t col_addr,
-- 
1.8.3.2

