Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaCAId4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 03:33:56 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48280 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaCAIdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 03:33:38 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] phy: mvebu-sata: prepare new Dove DT Kconfig variable
Date: Sat,  1 Mar 2014 09:33:21 +0100
Message-Id: <1393662801-17950-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393662801-17950-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393662801-17950-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
DT-only MACH_DOVE Kconfig.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Kishon,

Mark Brown requested to take the corresponding ASoC patch through
his tree. Therefore, I have split the former patch into individual subsystem
patches. This patch also received an update, to not break bisectability
we add DT-enabled MACH_DOVE and maintain ARCH_DOVE, which is non-DT only
after conversion. ARCH_DOVE will be removed, when legacy mach-dove will
be removed.

Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index c7a551c2d5f1..e81daff7b5a3 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -24,7 +24,7 @@ config PHY_EXYNOS_MIPI_VIDEO
 
 config PHY_MVEBU_SATA
 	def_bool y
-	depends on ARCH_KIRKWOOD || ARCH_DOVE
+	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
 	depends on OF
 	select GENERIC_PHY
 
-- 
1.8.5.3

