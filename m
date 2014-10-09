Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaJIJD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:03:59 -0400
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:50416
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755424AbaJIJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:35 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 2/6] regmap: cache: cleanup regcache_hw_init().
Date: Thu, 9 Oct 2014 17:02:53 +0800
Message-ID: <1412845377-17134-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(87936001)(99396003)(120916001)(76482002)(21056001)(77156001)(89996001)(88136002)(19580395003)(104166001)(6806004)(68736004)(69596002)(85852003)(87286001)(19580405001)(84676001)(44976005)(64706001)(48376002)(50466002)(93916002)(86362001)(4396001)(50226001)(105606002)(26826002)(81156004)(106466001)(97736003)(36756003)(102836001)(80022003)(46102003)(62966002)(20776003)(47776003)(92726001)(92566001)(229853001)(107046002)(50986999)(85306004)(2351001)(110136001)(31966008)(95666004)(76176999)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0622;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0622;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the redundant code for regmap cache.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regcache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 4896804..c13b821 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -57,12 +57,9 @@ static int regcache_hw_init(struct regmap *map)
 	}
 
 	/* calculate the size of reg_defaults */
-	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++) {
-		val = regcache_get_val(map, map->reg_defaults_raw, i);
-		if (regmap_volatile(map, i * map->reg_stride))
-			continue;
-		count++;
-	}
+	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++)
+		if (!regmap_volatile(map, i * map->reg_stride))
+			count++;
 
 	map->reg_defaults = kmalloc(count * sizeof(struct reg_default),
 				      GFP_KERNEL);
-- 
2.1.0.27.g96db324

