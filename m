Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab3HJP0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:26:01 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48196 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934117Ab3HJP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:26:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,851,1367964000"; 
   d="scan'208";a="29005203"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-pxa/stargate2.c: use ARRAY_AND_SIZE consistently
Date: Sat, 10 Aug 2013 17:25:53 +0200
Message-Id: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Because ARRAY_AND_SIZE changes the apparent arity of a function, if it is
used for one call to a given function, it would be better, if possible, to
use it for all of them.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@call@
identifier f;
expression e;
expression list[n] es;
@@

f(es,ARRAY_AND_SIZE(e),...)

@@
expression e;
identifier call.f;
expression list[call.n] ess;
@@

f(ess,
- e,ARRAY_SIZE(e)
+ ARRAY_AND_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arm/mach-pxa/stargate2.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 62aea3e..ee7a42e 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -608,12 +608,10 @@ static void __init imote2_init(void)
 
 	imote2_stargate2_init();
 
-	platform_add_devices(imote2_devices, ARRAY_SIZE(imote2_devices));
+	platform_add_devices(ARRAY_AND_SIZE(imote2_devices));
 
-	i2c_register_board_info(0, imote2_i2c_board_info,
-				ARRAY_SIZE(imote2_i2c_board_info));
-	i2c_register_board_info(1, imote2_pwr_i2c_board_info,
-				ARRAY_SIZE(imote2_pwr_i2c_board_info));
+	i2c_register_board_info(0, ARRAY_AND_SIZE(imote2_i2c_board_info));
+	i2c_register_board_info(1, ARRAY_AND_SIZE(imote2_pwr_i2c_board_info));
 
 	pxa_set_mci_info(&imote2_mci_platform_data);
 	pxa_set_udc_info(&imote2_udc_info);
@@ -990,8 +988,7 @@ static void __init stargate2_init(void)
 	platform_add_devices(ARRAY_AND_SIZE(stargate2_devices));
 
 	i2c_register_board_info(0, ARRAY_AND_SIZE(stargate2_i2c_board_info));
-	i2c_register_board_info(1, stargate2_pwr_i2c_board_info,
-				ARRAY_SIZE(stargate2_pwr_i2c_board_info));
+	i2c_register_board_info(1, ARRAY_AND_SIZE(stargate2_pwr_i2c_board_info));
 
 	pxa_set_mci_info(&stargate2_mci_platform_data);
 

