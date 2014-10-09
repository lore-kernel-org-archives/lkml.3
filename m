Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbaJIJFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:05:35 -0400
Received: from mail-bn1on0140.outbound.protection.outlook.com ([157.56.110.140]:10080
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751374AbaJIJDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:38 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 3/6] regmap: cache: fix errno in regcache_hw_init()
Date: Thu, 9 Oct 2014 17:02:54 +0800
Message-ID: <1412845377-17134-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(104016003)(20776003)(64706001)(47776003)(85852003)(89996001)(110136001)(88136002)(105606002)(81156004)(106466001)(229853001)(107046002)(2351001)(95666004)(85306004)(97736003)(50226001)(4396001)(50466002)(48376002)(76482002)(102836001)(62966002)(26826002)(92726001)(92566001)(93916002)(86362001)(46102003)(80022003)(87936001)(76176999)(104166001)(50986999)(31966008)(84676001)(99396003)(87286001)(21056001)(44976005)(19580395003)(19580405001)(6806004)(69596002)(68736004)(120916001)(77156001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0620;H:az84smr01.freescale.net;FPR:;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0620;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kmalloc() fails, we should return -ENOMEM.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index c13b821..8a7c270 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -44,7 +44,7 @@ static int regcache_hw_init(struct regmap *map)
 		map->cache_bypass = 1;
 		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
 		if (!tmp_buf)
-			return -EINVAL;
+			return -ENOMEM;
 		ret = regmap_raw_read(map, 0, tmp_buf,
 				      map->num_reg_defaults_raw);
 		map->cache_bypass = cache_bypass;
-- 
2.1.0.27.g96db324

