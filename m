Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaDRCbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:31:35 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55902 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaDRCa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:30:28 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] ARM: bcm: rename "kona.h" and "kona.c"
Date: Thu, 17 Apr 2014 21:30:15 -0500
Message-Id: <1397788215-20279-11-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397788215-20279-1-git-send-email-elder@linaro.org>
References: <1397788215-20279-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These source files contain only level-2 cache initialization code,
so rename them to make that fact more obvious.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/Makefile                    |    2 +-
 arch/arm/mach-bcm/board_bcm21664.c            |    2 +-
 arch/arm/mach-bcm/board_bcm281xx.c            |    2 +-
 arch/arm/mach-bcm/{kona.c => kona_l2_cache.c} |    0
 arch/arm/mach-bcm/{kona.h => kona_l2_cache.h} |    0
 5 files changed, 3 insertions(+), 3 deletions(-)
 rename arch/arm/mach-bcm/{kona.c => kona_l2_cache.c} (100%)
 rename arch/arm/mach-bcm/{kona.h => kona_l2_cache.h} (100%)

diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index d5b60fe..7312921 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_ARCH_BCM_281XX)	+= board_bcm281xx.o
 obj-$(CONFIG_ARCH_BCM_21664)	+= board_bcm21664.o
 
 # BCM281XX and BCM21664 L2 cache control
-obj-$(CONFIG_ARCH_BCM_MOBILE_L2_CACHE) += kona.o
+obj-$(CONFIG_ARCH_BCM_MOBILE_L2_CACHE) += kona_l2_cache.o
 
 # Support for secure monitor traps
 obj-$(CONFIG_ARCH_BCM_MOBILE_SMC) += bcm_kona_smc.o
diff --git a/arch/arm/mach-bcm/board_bcm21664.c b/arch/arm/mach-bcm/board_bcm21664.c
index ab96c3f..62c036b 100644
--- a/arch/arm/mach-bcm/board_bcm21664.c
+++ b/arch/arm/mach-bcm/board_bcm21664.c
@@ -17,7 +17,7 @@
 #include <asm/mach/arch.h>
 #include <asm/io.h>
 
-#include "kona.h"
+#include "kona_l2_cache.h"
 
 #define RSTMGR_DT_STRING		"brcm,bcm21664-resetmgr"
 
diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
index 6be54c1..1ac59fc 100644
--- a/arch/arm/mach-bcm/board_bcm281xx.c
+++ b/arch/arm/mach-bcm/board_bcm281xx.c
@@ -17,7 +17,7 @@
 
 #include <asm/mach/arch.h>
 
-#include "kona.h"
+#include "kona_l2_cache.h"
 
 #define SECWDOG_OFFSET			0x00000000
 #define SECWDOG_RESERVED_MASK		0xe2000000
diff --git a/arch/arm/mach-bcm/kona.c b/arch/arm/mach-bcm/kona_l2_cache.c
similarity index 100%
rename from arch/arm/mach-bcm/kona.c
rename to arch/arm/mach-bcm/kona_l2_cache.c
diff --git a/arch/arm/mach-bcm/kona.h b/arch/arm/mach-bcm/kona_l2_cache.h
similarity index 100%
rename from arch/arm/mach-bcm/kona.h
rename to arch/arm/mach-bcm/kona_l2_cache.h
-- 
1.7.9.5

