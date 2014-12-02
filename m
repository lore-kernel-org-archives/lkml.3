Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaLBR1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:27:30 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:22493 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLBR13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:27:29 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, <arm@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/8] ARM: at91/Kconfig: select board files automatically
Date: Tue, 2 Dec 2014 18:27:21 +0100
Message-ID: <e093d7cf37ec9ff24b0631b0a2e405a7cf7574db.1417541118.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <201411282152.08438.arnd@arndb.de>
References: <201411282152.08438.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

An explicit selection option is not needed for board files so now we select the
board from SoC option.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[nicolas.ferre@atmel.com: remove option's comments; split patch]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 231893d71658..2395c68b3e32 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -174,21 +174,11 @@ config SOC_AT91SAM9N12
 # ----------------------------------------------------------
 endif # SOC_SAM_V4_V5
 
-comment "Generic Board Type"
-
 config MACH_AT91RM9200_DT
-	bool "Atmel AT91RM9200 Evaluation Kits with device-tree support"
-	depends on SOC_AT91RM9200
-	help
-	  Select this if you want to experiment device-tree with
-	  an Atmel RM9200 Evaluation Kit.
+	def_bool SOC_AT91RM9200
 
 config MACH_AT91SAM9_DT
-	bool "Atmel AT91SAM Evaluation Kits with device-tree support"
-	depends on SOC_AT91SAM9
-	help
-	  Select this if you want to experiment device-tree with
-	  an Atmel Evaluation Kit.
+	def_bool SOC_AT91SAM9
 
 # ----------------------------------------------------------
 
-- 
2.1.3

