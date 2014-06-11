Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaFKGHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:07:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17210 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaFKGHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:07:53 -0400
Date: Wed, 11 Jun 2014 09:07:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] mfd: vexpress: use after free in
 vexpress_syscfg_regmap_init()
Message-ID: <20140611060725.GC7569@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return NULL if regmap_init() fails instead of continuing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
index 73068e5..2c0ddb2 100644
--- a/drivers/misc/vexpress-syscfg.c
+++ b/drivers/misc/vexpress-syscfg.c
@@ -231,10 +231,12 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
 	func->regmap = regmap_init(dev, NULL, func,
 			&vexpress_syscfg_regmap_config);
 
-	if (IS_ERR(func->regmap))
+	if (IS_ERR(func->regmap)) {
 		kfree(func);
-	else
-		list_add(&func->list, &syscfg->funcs);
+		return NULL;
+	}
+
+	list_add(&func->list, &syscfg->funcs);
 
 	return func->regmap;
 }
