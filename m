Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3IKFng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:43:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3IKE5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:12 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=clZsl2Ppd3gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ta-iqQOWeV8A:10 a=hD80L64hAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=v3rLFGiuRE8A:10 a=WwgC8nHKvroA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=YQp_XFta9NE7yrG0:21 a=Isc-DGStN6yLMmLI:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.488160985@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@linaro.org>, <stable@kernel.org>
Subject: [169/251] regmap: Add missing header for !CONFIG_REGMAP stubs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0169-regmap-Add-missing-header-for-CONFIG_REGMAP-stubs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

[ Upstream commit 49ccc142f9cbc33fdda18e8fa90c1c5b4a79c0ad ]

regmap.h requires linux/err.h if CONFIG_REGMAP is not defined. Without it I get
error.
CC      drivers/media/platform/exynos4-is/fimc-reg.o
In file included from drivers/media/platform/exynos4-is/fimc-reg.c:14:0:
include/linux/regmap.h: In function ‘regmap_write’:
include/linux/regmap.h:525:10: error: ‘EINVAL’ undeclared (first use in this function)
include/linux/regmap.h:525:10: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/regmap.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..519d5f2 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -15,6 +15,7 @@
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <linux/err.h>
 
 struct module;
 struct device;
-- 
1.7.10.4


