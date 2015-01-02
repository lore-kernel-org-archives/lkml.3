Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbbABVCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:02:15 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63336 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:02:13 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: m68k: 68360: config:  Remove unused function
Date: Fri,  2 Jan 2015 22:05:14 +0100
Message-Id: <1420232714-3989-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function BSP_set_clock_mmss() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/m68k/68360/config.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/m68k/68360/config.c b/arch/m68k/68360/config.c
index 17ec416..fd1f948 100644
--- a/arch/m68k/68360/config.c
+++ b/arch/m68k/68360/config.c
@@ -106,19 +106,6 @@ void hw_timer_init(irq_handler_t handler)
   pquicc->timer_tgcr  = tgcr_save;
 }
 
-int BSP_set_clock_mmss(unsigned long nowtime)
-{
-#if 0
-  short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;
-
-  tod->second1 = real_seconds / 10;
-  tod->second2 = real_seconds % 10;
-  tod->minute1 = real_minutes / 10;
-  tod->minute2 = real_minutes % 10;
-#endif
-  return 0;
-}
-
 void BSP_reset (void)
 {
   local_irq_disable();
-- 
1.7.10.4

