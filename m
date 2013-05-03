Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab3ECOfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:35:05 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61070 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520Ab3ECOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 41/63] ARM: ux500: Stop passing Cryp DMA channel config information though pdata
Date: Fri,  3 May 2013 15:32:27 +0100
Message-Id: <1367591569-32197-42-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA channel configuration information should be setup in the driver.
The Ux500 Cryp driver now does this, so there's no need to send it
though here too.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index cb7ae23..7f756cc 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -453,20 +453,12 @@ static struct cryp_platform_data u8500_cryp1_platform_data = {
 		.mem_to_engine = {
 				.dir = STEDMA40_MEM_TO_PERIPH,
 				.dev_type = DB8500_DMA_DEV48_CAC1,
-				.src_info.data_width = STEDMA40_WORD_WIDTH,
-				.dst_info.data_width = STEDMA40_WORD_WIDTH,
 				.mode = STEDMA40_MODE_LOGICAL,
-				.src_info.psize = STEDMA40_PSIZE_LOG_4,
-				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
 		},
 		.engine_to_mem = {
 				.dir = STEDMA40_PERIPH_TO_MEM,
 				.dev_type = DB8500_DMA_DEV48_CAC1,
-				.src_info.data_width = STEDMA40_WORD_WIDTH,
-				.dst_info.data_width = STEDMA40_WORD_WIDTH,
 				.mode = STEDMA40_MODE_LOGICAL,
-				.src_info.psize = STEDMA40_PSIZE_LOG_4,
-				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
 		}
 };
 
-- 
1.7.10.4

