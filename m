Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaCFJZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:25:57 -0500
Received: from sauhun.de ([89.238.76.85]:54994 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaCFJTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:19:32 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] i2c: mv64xxx: fix circular Kconfig dependency
Date: Thu,  6 Mar 2014 10:19:13 +0100
Message-Id: <1394097553-5804-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140306135016.2f026cd81b41cd2474c99124@canb.auug.org.au>
References: <20140306135016.2f026cd81b41cd2474c99124@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 370136bc67c3 ("i2c: mv64xxx: Add reset deassert call")
introduced:

drivers/video/Kconfig:42:error: recursive dependency detected!

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 70bcad9..ce0de47 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -527,8 +527,7 @@ config I2C_MPC
 
 config I2C_MV64XXX
 	tristate "Marvell mv64xxx I2C Controller"
-	depends on (MV64X60 || PLAT_ORION || ARCH_SUNXI)
-	select RESET_CONTROLLER
+	depends on MV64X60 || PLAT_ORION || (ARCH_SUNXI && RESET_CONTROLLER)
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Marvell 64xxx line of host bridges.
-- 
1.9.0

