Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaLGM0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:26:20 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54264 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaLGM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:17 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-omap1: timer32k.c:  Remove unused function
Date: Sun,  7 Dec 2014 13:28:56 +0100
Message-Id: <1417955336-10751-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function omap_32k_timer_read() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap1/timer32k.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 107e7ab..36bf174 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -91,11 +91,6 @@ static inline void omap_32k_timer_write(int val, int reg)
 	omap_writew(val, OMAP1_32K_TIMER_BASE + reg);
 }
 
-static inline unsigned long omap_32k_timer_read(int reg)
-{
-	return omap_readl(OMAP1_32K_TIMER_BASE + reg) & 0xffffff;
-}
-
 static inline void omap_32k_timer_start(unsigned long load_val)
 {
 	if (!load_val)
-- 
1.7.10.4

