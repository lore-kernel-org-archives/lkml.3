Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbaGOROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:53 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59730 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaGORCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:12 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 42/94] ARM: DRA7/AM43XX: fix header definition for omap44xx_restart
Date: Tue, 15 Jul 2014 20:00:57 +0300
Message-Id: <1405443709-15288-42-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

omap44xx_restart is defined as a static void inline when DRA7/AM437X is
defined alone, which implies that the restart function is no longer
functional even though it is built in. So, fix the definition of the
same.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/common.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index b2d252b..dc571f1 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -162,7 +162,8 @@ static inline void omap3xxx_restart(enum reboot_mode mode, const char *cmd)
 }
 #endif
 
-#if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
+#if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5) || \
+	defined(CONFIG_SOC_DRA7XX) || defined(CONFIG_SOC_AM43XX)
 void omap44xx_restart(enum reboot_mode mode, const char *cmd);
 #else
 static inline void omap44xx_restart(enum reboot_mode mode, const char *cmd)
-- 
1.7.10.4

