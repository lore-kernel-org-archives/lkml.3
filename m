Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaJIJFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:05:20 -0400
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:62240
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755435AbaJIJDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:39 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 4/6] regmap: cache: speed regcache_hw_init() up.
Date: Thu, 9 Oct 2014 17:02:55 +0800
Message-ID: <1412845377-17134-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(93916002)(89996001)(62966002)(80022003)(97736003)(85852003)(47776003)(104016003)(87286001)(92726001)(31966008)(86362001)(76176999)(19580395003)(44976005)(6806004)(104166001)(88136002)(50986999)(46102003)(87936001)(68736004)(69596002)(26826002)(85306004)(36756003)(4396001)(20776003)(102836001)(50226001)(81156004)(106466001)(48376002)(92566001)(105606002)(99396003)(2351001)(229853001)(21056001)(19580405001)(84676001)(64706001)(110136001)(50466002)(120916001)(76482002)(95666004)(77156001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0618;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0618;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may speed regcache_hw_init() up for some cases that there
has volatile registers.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 8a7c270..45ab909 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -71,9 +71,9 @@ static int regcache_hw_init(struct regmap *map)
 	/* fill the reg_defaults */
 	map->num_reg_defaults = count;
 	for (i = 0, j = 0; i < map->num_reg_defaults_raw; i++) {
-		val = regcache_get_val(map, map->reg_defaults_raw, i);
 		if (regmap_volatile(map, i * map->reg_stride))
 			continue;
+		val = regcache_get_val(map, map->reg_defaults_raw, i);
 		map->reg_defaults[j].reg = i * map->reg_stride;
 		map->reg_defaults[j].def = val;
 		j++;
-- 
2.1.0.27.g96db324

