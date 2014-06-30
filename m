Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaF3Cwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:52:46 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:57128 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaF3Cwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:52:45 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: ulli.kroll@googlemail.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fixes gemmi_idle in file idle.c
Date: Sun, 29 Jun 2014 22:52:40 -0400
Message-Id: <1404096760-5239-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disables the IRQ line in gemmi_idle before calling cpu_do_idle.
In addition, according to the Fixme message in this file fixes
races that may occur due to not disabling the IRQ before calling
cpu_do_idle.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/mach-gemini/idle.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
index ddf8ec9..2880f5a 100644
--- a/arch/arm/mach-gemini/idle.c
+++ b/arch/arm/mach-gemini/idle.c
@@ -17,8 +17,7 @@ static void gemini_idle(void)
 	 * disabled.
 	 */
 
-	/* FIXME: Enabling interrupts here is racy! */
-	local_irq_enable();
+	local_irq_disable();
 	cpu_do_idle();
 }
 
-- 
1.9.1

