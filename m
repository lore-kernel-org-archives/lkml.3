Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbbAATJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:09:08 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:58320 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbAATJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:09:06 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: ath79: gpio:  Remove some unused functions
Date: Thu,  1 Jan 2015 20:12:05 +0100
Message-Id: <1420139525-2833-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ath79_gpio_function_disable() ath79_gpio_function_enable()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/ath79/common.h |    2 --
 arch/mips/ath79/gpio.c   |   10 ----------
 2 files changed, 12 deletions(-)

diff --git a/arch/mips/ath79/common.h b/arch/mips/ath79/common.h
index a312071..9eb841a 100644
--- a/arch/mips/ath79/common.h
+++ b/arch/mips/ath79/common.h
@@ -24,8 +24,6 @@ unsigned long ath79_get_sys_clk_rate(const char *id);
 
 void ath79_ddr_wb_flush(unsigned int reg);
 
-void ath79_gpio_function_enable(u32 mask);
-void ath79_gpio_function_disable(u32 mask);
 void ath79_gpio_function_setup(u32 set, u32 clear);
 void ath79_gpio_init(void);
 
diff --git a/arch/mips/ath79/gpio.c b/arch/mips/ath79/gpio.c
index 8d025b0..d0a5d92 100644
--- a/arch/mips/ath79/gpio.c
+++ b/arch/mips/ath79/gpio.c
@@ -168,16 +168,6 @@ void ath79_gpio_function_setup(u32 set, u32 clear)
 	spin_unlock_irqrestore(&ath79_gpio_lock, flags);
 }
 
-void ath79_gpio_function_enable(u32 mask)
-{
-	ath79_gpio_function_setup(mask, 0);
-}
-
-void ath79_gpio_function_disable(u32 mask)
-{
-	ath79_gpio_function_setup(0, mask);
-}
-
 void __init ath79_gpio_init(void)
 {
 	int err;
-- 
1.7.10.4

