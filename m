Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3BPCx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:53:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64931 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3BPCx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:53:56 -0500
Message-ID: <1360983229.6332.5.camel@phoenix>
Subject: [PATCH] regulator: twl: Remove TWL6030_FIXED_RESOURCE
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2013 10:53:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL6030_FIXED_RESOURCE is not used now, remove it.

TWL6030_FIXED_RESOURCE is not used since commit e76ab829cc
"regulator: twl: Remove references to the twl4030 regulator"

twl6030_fixed_resource is removed by commit 029dd3cef
"regulator: twl: Remove another unused variable warning".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/twl-regulator.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 2b3dc5b..611e73e 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -936,19 +936,6 @@ static const struct twlreg_info TWLFIXED_INFO_##label = { \
 		}, \
 	}
 
-#define TWL6030_FIXED_RESOURCE(label, offset, turnon_delay) \
-static struct twlreg_info TWLRES_INFO_##label = { \
-	.base = offset, \
-	.desc = { \
-		.name = #label, \
-		.id = TWL6030_REG_##label, \
-		.ops = &twl6030_fixed_resource, \
-		.type = REGULATOR_VOLTAGE, \
-		.owner = THIS_MODULE, \
-		.enable_time = turnon_delay, \
-		}, \
-	}
-
 #define TWL6025_ADJUSTABLE_SMPS(label, offset) \
 static const struct twlreg_info TWLSMPS_INFO_##label = { \
 	.base = offset, \
-- 
1.7.9.5



