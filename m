Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab3APQGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab3APQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 134/222] ARM: 7607/1: realview: fix private peripheral memory base for EB rev. B boards
Date: Wed, 16 Jan 2013 13:55:34 -0200
Message-Id: <1358351822-7675-135-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit e6ee4b2b57a8e0d8e551031173de080b338d3969 upstream.

Commit 34ae6c96a6a7 ("ARM: 7298/1: realview: fix mapping of MPCore
private memory region") accidentally broke the definition for the base
address of the private peripheral region on revision B Realview-EB
boards.

This patch uses the correct address for REALVIEW_EB11MP_PRIV_MEM_BASE.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-realview/include/mach/board-eb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-realview/include/mach/board-eb.h b/arch/arm/mach-realview/include/mach/board-eb.h
index 124bce6..a301e61 100644
--- a/arch/arm/mach-realview/include/mach/board-eb.h
+++ b/arch/arm/mach-realview/include/mach/board-eb.h
@@ -47,7 +47,7 @@
 #define REALVIEW_EB_USB_BASE		0x4F000000	/* USB */
 
 #ifdef CONFIG_REALVIEW_EB_ARM11MP_REVB
-#define REALVIEW_EB11MP_PRIV_MEM_BASE	0x1F000000
+#define REALVIEW_EB11MP_PRIV_MEM_BASE	0x10100000
 #define REALVIEW_EB11MP_L220_BASE	0x10102000	/* L220 registers */
 #define REALVIEW_EB11MP_SYS_PLD_CTRL1	0xD8		/* Register offset for MPCore sysctl */
 #else
-- 
1.7.9.5

