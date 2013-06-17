Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3FQNjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:39:48 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:62854 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab3FQNjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:39:46 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        ulli.kroll@googlemail.com, arm@kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: mm: cpu_fa526_do_idle: remove WFI
Date: Mon, 17 Jun 2013 15:39:20 +0200
Message-Id: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it was already suggested by Russell King and Arnd Bergmann ( https://lkml.org/lkml/2013/5/16/133 ), moxart and gemini seem to be the only platforms using CPU_FA526, and instead of pointing arm_pm_idle to an empty function from platform code, it makes sense to remove WFI code from the processor specific idle function.

Note: moxart boots and prints to UART without this patch, but input is broken.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 arch/arm/mm/proc-fa526.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
index d217e97..85280b1 100644
--- a/arch/arm/mm/proc-fa526.S
+++ b/arch/arm/mm/proc-fa526.S
@@ -81,9 +81,7 @@ ENDPROC(cpu_fa526_reset)
  */
 	.align	4
 ENTRY(cpu_fa526_do_idle)
-	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
-	mov	pc, lr
-
+	nop
 
 ENTRY(cpu_fa526_dcache_clean_area)
 1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-- 
1.7.2.5

