Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbbALSne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:43:34 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56612 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754646AbbALSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:42:24 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/7] ARM: at91: remove useless config MACH_AT91RM9200_DT
Date: Mon, 12 Jan 2015 19:42:11 +0100
Message-Id: <1421088136-10172-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421088136-10172-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rm9200 is only supported through DT, remove CONFIG_MACH_AT91RM9200_DT
and use CONFIG_SOC_AT91RM9200 instead.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig  | 3 ---
 arch/arm/mach-at91/Makefile | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2395c68b3e32..34725b296e4d 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -174,9 +174,6 @@ config SOC_AT91SAM9N12
 # ----------------------------------------------------------
 endif # SOC_SAM_V4_V5
 
-config MACH_AT91RM9200_DT
-	def_bool SOC_AT91RM9200
-
 config MACH_AT91SAM9_DT
 	def_bool SOC_AT91SAM9
 
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 7b6424d40764..55fc93f5638b 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -19,7 +19,7 @@ obj-$(CONFIG_SOC_SAMA5D3)	+= sama5d3.o
 obj-$(CONFIG_SOC_SAMA5D4)	+= sama5d4.o
 
 # AT91SAM board with device-tree
-obj-$(CONFIG_MACH_AT91RM9200_DT) += board-dt-rm9200.o
+obj-$(CONFIG_SOC_AT91RM9200) += board-dt-rm9200.o
 obj-$(CONFIG_MACH_AT91SAM9_DT) += board-dt-sam9.o
 
 # SAMA5 board with device-tree
-- 
2.1.0

