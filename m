Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3FDPhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:37:19 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39418 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3FDPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:36:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] ARM: ux500: Silence compiler warnings due to missing __cpuinitdata
Date: Tue,  4 Jun 2013 16:36:48 +0100
Message-Id: <1370360208-6500-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
References: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text.unlikely+0x25c): Section mismatch in reference \
  from the function write_pen_release() to the variable                 \
  .cpuinit.data:pen_release
The function write_pen_release() references
the variable __cpuinitdata pen_release.
This is often because write_pen_release lacks a __cpuinitdata

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/platsmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index 14d9046..3a455d5 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -34,7 +34,7 @@ extern void u8500_secondary_startup(void);
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
  */
-static void write_pen_release(int val)
+static void __cpuinitdata write_pen_release(int val)
 {
 	pen_release = val;
 	smp_wmb();
-- 
1.7.10.4

