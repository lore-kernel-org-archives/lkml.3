Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3KIJta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 04:49:30 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48174 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3KIJt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 04:49:27 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: [PATCH] regmap: Fix compile warning with value uninitialized
Thread-Topic: [PATCH] regmap: Fix compile warning with value uninitialized
Thread-Index: Ac7dMPDqJNfaHcdQRfGWzwUKLP6MYA==
Date: Sat, 9 Nov 2013 09:49:11 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B39E@szxeml512-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Sat, 9 Nov 2013 14:14:36 +0800
Subject: [PATCH] regmap: Fix compile warning with value uninitialized

Fix compile warning with value uninitialized:
drivers/base/regmap/regmap.c:2173: warning: 'ret' may be used uninitialized in this function

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/base/regmap/regmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9c021d9..4fac073 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2170,7 +2170,8 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
 {
 	struct reg_default *p;
-	int i, ret;
+	int i;
+	int ret = 0;
 	bool bypass;
 
 	map->lock(map->lock_arg);
-- 
1.8.1.5

