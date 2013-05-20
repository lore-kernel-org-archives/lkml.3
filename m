Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3ETTeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:34:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:51820 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3ETTeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:34:04 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19TWCYaEbpTsD31T2a1aTb7LKU2NyUl8y0JKfvOSn
	SrHuAYWUWfvC0G
From: Peter Huewe <peterhuewe@gmx.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] powerpc/platforms/83xx/mcu_mpc8349emitx: Use module_i2c_driver to register driver
Date: Mon, 20 May 2013 21:39:09 +0200
Message-Id: <1369078749-3197-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_i2c_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index 624cb51..4b8ea95 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -231,18 +231,7 @@ static struct i2c_driver mcu_driver = {
 	.id_table = mcu_ids,
 };
 
-static int __init mcu_init(void)
-{
-	return i2c_add_driver(&mcu_driver);
-}
-module_init(mcu_init);
-
-static void __exit mcu_exit(void)
-{
-	i2c_del_driver(&mcu_driver);
-}
-module_exit(mcu_exit);
-
+module_i2c_driver(mcu_driver);
 MODULE_DESCRIPTION("Power Management and GPIO expander driver for "
 		   "MPC8349E-mITX-compatible MCU");
 MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
-- 
1.8.1.5

