Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3AOIEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:04:51 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34709 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3AOIEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:04:50 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] ARM: davinci: da850 evm: pass platform data for adv7343 encoder
Date: Tue, 15 Jan 2013 13:34:41 +0530
Message-Id: <1358237081-2584-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch the adv7343 encoder was being set to default
configuration which caused display not to work on this board.
This patch passes the necessary platform data required for adv7343
encoder to work on da850 evm.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 This patch is dependent on http://patchwork.linuxtv.org/patch/16272/

 arch/arm/mach-davinci/board-da850-evm.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 0299915..d0e3ec3 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1256,11 +1256,24 @@ static struct vpif_capture_config da850_vpif_capture_config = {
 };
 
 /* VPIF display configuration */
+
+static struct adv7343_platform_data adv7343_pdata = {
+	.mode_config = {
+		.dac_3 = 1,
+		.dac_2 = 1,
+		.dac_1 = 1,
+	},
+	.sd_config = {
+		.sd_dac_out1 = 1,
+	},
+};
+
 static struct vpif_subdev_info da850_vpif_subdev[] = {
 	{
 		.name = "adv7343",
 		.board_info = {
 			I2C_BOARD_INFO("adv7343", 0x2a),
+			.platform_data = &adv7343_pdata,
 		},
 	},
 };
-- 
1.7.4.1

