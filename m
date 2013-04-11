Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161620Ab3DKPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:20:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48485 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161509Ab3DKPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:20:56 -0400
Message-ID: <1365693650.4218.4.camel@phoenix>
Subject: [RESEND][PATCH 3/3] regulator: twl: Remove TWL6030_FIXED_RESOURCE
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 23:20:50 +0800
In-Reply-To: <1365693520.4218.1.camel@phoenix>
References: <1365693520.4218.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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
1.7.10.4



