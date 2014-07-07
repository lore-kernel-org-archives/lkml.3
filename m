Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaGGPTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:19:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58237 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752050AbaGGPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:19:31 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/5] ARM: at91: select ATMEL_RAMC when using OF
Date: Mon,  7 Jul 2014 17:19:12 +0200
Message-Id: <1404746355-19988-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using device tree, select the Atmel RAM controller driver to handle its
clocks.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 45b55e0f0db6..ad6b2b8b6afd 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -49,6 +49,8 @@ config SOC_AT91SAM9
 	select GENERIC_CLOCKEVENTS
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
+	select MEMORY if USE_OF
+	select ATMEL_RAMC if USE_OF
 
 config SOC_SAMA5
 	bool
@@ -58,6 +60,8 @@ config SOC_SAMA5
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
 	select USE_OF
+	select MEMORY
+	select ATMEL_RAMC
 
 menu "Atmel AT91 System-on-Chip"
 
-- 
1.9.1

