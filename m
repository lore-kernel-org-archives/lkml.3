Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397Ab3CTJQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:16:05 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:33505 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3CTJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:15:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] blackfin: twi: Remove bogus #endif
Date: Wed, 20 Mar 2013 10:15:51 +0100
Message-Id: <1363770951-28158-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/blackfin/mach-bf538/boards/ezkit.c:768:2: error: #endif without #if

Introduced by commit cf93feb3a0dee97c7896016a352a3226139fbcf4 ("blackfin:
twi: Move TWI peripheral pin request array to platform data"), which
removed the #if, but forgot about the #endif.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8427477/

 arch/blackfin/mach-bf538/boards/ezkit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index a4fce03..755f0dc 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -764,7 +764,6 @@ static struct platform_device i2c_bfin_twi1_device = {
 	.num_resources = ARRAY_SIZE(bfin_twi1_resource),
 	.resource = bfin_twi1_resource,
 };
-#endif	/* CONFIG_BF542 */
 #endif	/* CONFIG_I2C_BLACKFIN_TWI */
 
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
-- 
1.7.0.4

