Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab3EBKvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:51:49 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55488 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab3EBKuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:50:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/8] ARM: ux500: Stop passing Hash DMA channel config information though pdata
Date: Thu,  2 May 2013 11:49:45 +0100
Message-Id: <1367491790-9727-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
References: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA channel configuration information should be setup in the driver.
The Ux500 Hash driver now does this, so there's no need to send it
though here too.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 883dc66..cb7ae23 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -473,11 +473,7 @@ static struct cryp_platform_data u8500_cryp1_platform_data = {
 static struct stedma40_chan_cfg u8500_hash_dma_cfg_tx = {
 		.dir = STEDMA40_MEM_TO_PERIPH,
 		.dev_type = DB8500_DMA_DEV50_HAC1_TX,
-		.src_info.data_width = STEDMA40_WORD_WIDTH,
-		.dst_info.data_width = STEDMA40_WORD_WIDTH,
 		.mode = STEDMA40_MODE_LOGICAL,
-		.src_info.psize = STEDMA40_PSIZE_LOG_16,
-		.dst_info.psize = STEDMA40_PSIZE_LOG_16,
 };
 
 static struct hash_platform_data u8500_hash1_platform_data = {
-- 
1.7.10.4

