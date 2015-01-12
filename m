Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbbALSnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:43:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56617 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755681AbbALSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:25 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/7] ARM: at91: remove useless config MACH_AT91SAM9_DT
Date: Mon, 12 Jan 2015 19:42:12 +0100
Message-Id: <1421088136-10172-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that at91sam9 SoCs are only supported through DT, remove
CONFIG_MACH_AT91SAM9_DT and use CONFIG_SOC_AT91SAM9 instead.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig  | 5 -----
 arch/arm/mach-at91/Makefile | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 34725b296e4d..cec0fb5d621a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -174,11 +174,6 @@ config SOC_AT91SAM9N12
 # ----------------------------------------------------------
 endif # SOC_SAM_V4_V5
 
-config MACH_AT91SAM9_DT
-	def_bool SOC_AT91SAM9
-
-# ----------------------------------------------------------
-
 comment "AT91 Feature Selections"
 
 config AT91_SLOW_CLOCK
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 55fc93f5638b..9165a4aa7f0d 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
 
 # AT91SAM board with device-tree
 obj-$(CONFIG_SOC_AT91RM9200) += board-dt-rm9200.o
-obj-$(CONFIG_MACH_AT91SAM9_DT) += board-dt-sam9.o
+obj-$(CONFIG_SOC_AT91SAM9) += board-dt-sam9.o
 
 # SAMA5 board with device-tree
 obj-$(CONFIG_SOC_SAMA5)		+= board-dt-sama5.o
-- 
2.1.0

