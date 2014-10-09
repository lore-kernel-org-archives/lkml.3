Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaJIJEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:04:36 -0400
Received: from mail-bl2on0110.outbound.protection.outlook.com ([65.55.169.110]:11680
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755450AbaJIJDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:42 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 5/6] regmap: cache: use kmalloc_array instead of kmalloc
Date: Thu, 9 Oct 2014 17:02:56 +0800
Message-ID: <1412845377-17134-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(44976005)(6806004)(76482002)(120916001)(93916002)(229853001)(86362001)(26826002)(104166001)(107046002)(2351001)(50466002)(76176999)(50986999)(69596002)(92566001)(92726001)(48376002)(68736004)(31966008)(102836001)(19580395003)(19580405001)(95666004)(84676001)(105606002)(88136002)(50226001)(4396001)(87286001)(99396003)(87936001)(81156004)(106466001)(85852003)(89996001)(85306004)(77156001)(64706001)(62966002)(104016003)(36756003)(46102003)(47776003)(110136001)(97736003)(20776003)(21056001)(80022003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0609;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0609;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl warning for regmap cache.
WARNING : prefer kmalloc_array over kmalloc with multiply

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 45ab909..a06bcd2 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -61,8 +61,8 @@ static int regcache_hw_init(struct regmap *map)
 		if (!regmap_volatile(map, i * map->reg_stride))
 			count++;
 
-	map->reg_defaults = kmalloc(count * sizeof(struct reg_default),
-				      GFP_KERNEL);
+	map->reg_defaults = kmalloc_array(count, sizeof(struct reg_default),
+					  GFP_KERNEL);
 	if (!map->reg_defaults) {
 		ret = -ENOMEM;
 		goto err_free;
-- 
2.1.0.27.g96db324

