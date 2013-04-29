Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab3D2T1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:27:19 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50418 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab3D2T1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:27:16 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] ARM: dove: fix Dove cpu type from V7 to PJ4
Date: Mon, 29 Apr 2013 21:26:52 +0200
Message-Id: <1367263612-17596-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will enable iWMMXt
extensions on Dove.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Andrew Lunn <andrew@lunn.ch>
---
Note: This patch is rebased on v3.9 and patch message has been modified
to point out that iWMMXt is now enforced on CPU_PJ4.

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1cacda4..3c5e4da 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -555,7 +555,7 @@ config ARCH_IXP4XX
 config ARCH_DOVE
 	bool "Marvell Dove"
 	select ARCH_REQUIRE_GPIOLIB
-	select CPU_V7
+	select CPU_PJ4
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
 	select PINCTRL
-- 
1.7.10.4

