Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3GOOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:16:25 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39049 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3GOOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:16:24 -0400
From: Julien Grall <julien.grall@linaro.org>
To: linux@arm.linux.org.uk, stefano.stabellini@eu.citrix.com
Cc: Ian.Campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] arm: choose debug/uncompress.h include when uncompress debug is disabled
Date: Mon, 15 Jul 2013 15:15:06 +0100
Message-Id: <1373897706-15331-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if uncompress debug is disabled, some board will continue to print
information during uncompress step.
By using debug/uncompress.h include, all debug output will be disabled.

This is usefull in Xen environment for DOM0 because the UART is stolen by
Xen.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 arch/arm/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 21cc8a7..86c023d 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -679,7 +679,7 @@ config DEBUG_UNCOMPRESS
 
 config UNCOMPRESS_INCLUDE
 	string
-	default "debug/uncompress.h" if ARCH_MULTIPLATFORM
+	default "debug/uncompress.h" if ARCH_MULTIPLATFORM || !DEBUG_UNCOMPRESS
 	default "mach/uncompress.h"
 
 config EARLY_PRINTK
-- 
1.7.10.4

