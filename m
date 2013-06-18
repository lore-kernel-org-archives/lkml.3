Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3FRILr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:11:47 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35407 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3FRILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:11:44 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        ulli.kroll@googlemail.com, arm@kernel.org, florian@openwrt.org,
        kaloz@openwrt.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2] ARM: mm: cpu_fa526_do_idle: remove WFI
Date: Tue, 18 Jun 2013 10:11:05 +0200
Message-Id: <1371543065-5843-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it was already suggested by Russell King and Arnd Bergmann:

https://lkml.org/lkml/2013/5/16/133

moxart and gemini seem to be the only platforms using CPU_FA526,
and instead of pointing arm_pm_idle to an empty function from
platform code, it makes sense to remove WFI code from the processor
specific idle function.

Applies to arm-soc/for-next.

Changes since v1:

1. remove WFI but make sure cpu_fa526_do_idle do not fall through
   to cpu_fa526_dcache_clean_area

Note: moxart boots and prints to UART without this patch, but input is broken.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 arch/arm/mm/proc-fa526.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
index d217e97..aaeb6c1 100644
--- a/arch/arm/mm/proc-fa526.S
+++ b/arch/arm/mm/proc-fa526.S
@@ -81,7 +81,6 @@ ENDPROC(cpu_fa526_reset)
  */
 	.align	4
 ENTRY(cpu_fa526_do_idle)
-	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
 	mov	pc, lr
 
 
-- 
1.7.2.5

