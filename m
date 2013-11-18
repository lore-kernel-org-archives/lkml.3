Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3KRM3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:29:25 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:12676 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KRM3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:29:20 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>,
        =?iso-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>,
        "levex@linux.com" <levex@linux.com>
Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value
Thread-Topic: [PATCH] regmap: Fix 'ret' would return an uninitialized value
Thread-Index: Ac7kWcL5xgLbWHL4Tn20TZiQZqZlqA==
Date: Mon, 18 Nov 2013 12:29:02 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F254A8BE3@szxeml512-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.19]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Mon, 18 Nov 2013 20:21:49 +0800
Subject: [PATCH] regmap: Fix 'ret' would return an uninitialized value

This patch give a warning when calling regmap_register_patch with
parameter num_regs <= 0.

When the num_regs parameter is zero and krealloc doesn't fail,
then the code would return an uninitialized value. However,
calling this function with num_regs == 0, would be a waste as it
essentially does nothing.

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/base/regmap/regmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9c021d9..9a36ac1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2173,6 +2173,10 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	int i, ret;
 	bool bypass;
 
+	if (WARN_ONCE(num_regs <= 0, "invalid registers number (%d)\n",
+	    num_regs))
+		return 0;
+
 	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
-- 
1.8.1.5

