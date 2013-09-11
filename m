Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3IKE5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3IKE4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:49 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6PnTuKUFziwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=G8OPikjwTnEA:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042933.072482985@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kevin Hilman <khilman@linaro.org>, Mark Brown <broonie@linaro.org>
Subject: [243/251] regmap: Add another missing header for !CONFIG_REGMAP stubs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0243-regmap-Add-another-missing-header-for-CONFIG_REGMAP-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kevin Hilman <khilman@linaro.org>

[ Upstream commit 3f0fa9a808f98fa10a18ba2a73f13d65fda990fb ]

The use of WARN_ON() needs the definitions from bug.h, without it
you can get:

include/linux/regmap.h: In function 'regmap_write':
include/linux/regmap.h:525:2: error: implicit declaration of function 'WARN_ONCE' [-Werror=implicit-function-declaration]

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/regmap.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 519d5f2..db23dde 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/err.h>
+#include <linux/bug.h>
 
 struct module;
 struct device;
-- 
1.7.10.4


