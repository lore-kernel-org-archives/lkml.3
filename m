Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbbAMSZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:25:23 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36772 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbbAMSZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:25:20 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ata: pata_at91: depend on !ARCH_MULTIPLATFORM
Date: Tue, 13 Jan 2015 19:25:17 +0100
Message-Id: <1421173517-21246-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until the driver is corrected to stop using mach/at91isam9_smc.h, it won't
compile in a ARCH_MULTIPLATFORM configuration.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/ata/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a3a13605a9c4..5f601553b9b0 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -835,6 +835,7 @@ config PATA_AT32
 config PATA_AT91
 	tristate "PATA support for AT91SAM9260"
 	depends on ARM && SOC_AT91SAM9
+	depends on !ARCH_MULTIPLATFORM
 	help
 	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
 
-- 
2.1.0

