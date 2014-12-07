Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaLGMYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:24:14 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37711 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaLGMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:24:12 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-omap1: irq.c:  Remove unused function
Date: Sun,  7 Dec 2014 13:26:49 +0100
Message-Id: <1417955210-10576-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function irq_bank_readl() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap1/irq.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-omap1/irq.c b/arch/arm/mach-omap1/irq.c
index 122ef67..a8a533d 100644
--- a/arch/arm/mach-omap1/irq.c
+++ b/arch/arm/mach-omap1/irq.c
@@ -64,11 +64,6 @@ u32 omap_irq_flags;
 static unsigned int irq_bank_count;
 static struct omap_irq_bank *irq_banks;
 
-static inline unsigned int irq_bank_readl(int bank, int offset)
-{
-	return omap_readl(irq_banks[bank].base_reg + offset);
-}
-
 static inline void irq_bank_writel(unsigned long value, int bank, int offset)
 {
 	omap_writel(value, irq_banks[bank].base_reg + offset);
-- 
1.7.10.4

