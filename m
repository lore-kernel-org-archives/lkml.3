Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaLAK2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:28:50 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50453 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753132AbaLAK1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:27:42 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 07/11] ARM: at91: select ATMEL_EBI when compiling a kernel for at91sam9 or sama5d3
Date: Mon,  1 Dec 2014 11:27:23 +0100
Message-Id: <1417429647-3419-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9* and sama5d* SoCs have an EBI (External Bus Interface).
Select the ATMEL_EBI driver when support for these SoCs is selected.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 0e6d548..a72402a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -49,6 +49,7 @@ config SOC_AT91SAM9
 	select GENERIC_CLOCKEVENTS
 	select MEMORY if USE_OF
 	select ATMEL_SDRAMC if USE_OF
+	select ATMEL_EBI if USE_OF
 
 config SOC_SAMA5
 	bool
@@ -58,6 +59,7 @@ config SOC_SAMA5
 	select USE_OF
 	select MEMORY
 	select ATMEL_SDRAMC
+	select ATMEL_EBI
 
 menu "Atmel AT91 System-on-Chip"
 
-- 
1.9.1

