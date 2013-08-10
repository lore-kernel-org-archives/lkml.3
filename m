Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3HJTVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 15:21:01 -0400
Received: from lists.laptop.org ([18.85.2.166]:52814 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3HJTVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 15:21:00 -0400
From: Daniel Drake <dsd@laptop.org>
To: akpm@linux-foundation.org
Cc: dilinger@queued.net, linux-kernel@vger.kernel.org
Subject: [PATCH] olpc-ec: initialise earlier
Message-Id: <20130810192215.B83A2FAB04@dev.laptop.org>
Date: Sat, 10 Aug 2013 15:22:15 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being a low-level component, various drivers (e.g. olpc-battery) assume that
it is ok to communicate with the OLPC Embedded Controller during probe.
Therefore the OLPC EC driver must be initialised before other drivers try to
use it. This was the case until it was recently moved out of arch/x86 and
restructured.

Use arch_initcall so that olpc-ec is readied earlier, matching the
previous behaviour. Fixes various drivers such as olpc-battery and
olpc-xo1-sci.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 0f9f859..f911952 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(void)
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");
-- 
1.8.3.1

