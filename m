Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbbAAQmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:42:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43204 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbAAQmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:42:07 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: plat-omap: dma.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:45:05 +0100
Message-Id: <1420130705-29316-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function get_gdma_dev() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/plat-omap/dma.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 24770e5..6416e03 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -151,14 +151,6 @@ static int omap_dma_in_1510_mode(void)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP1
-static inline int get_gdma_dev(int req)
-{
-	u32 reg = OMAP_FUNC_MUX_ARM_BASE + ((req - 1) / 5) * 4;
-	int shift = ((req - 1) % 5) * 6;
-
-	return ((omap_readl(reg) >> shift) & 0x3f) + 1;
-}
-
 static inline void set_gdma_dev(int req, int dev)
 {
 	u32 reg = OMAP_FUNC_MUX_ARM_BASE + ((req - 1) / 5) * 4;
-- 
1.7.10.4

