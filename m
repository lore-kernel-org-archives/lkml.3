Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3HNXFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:05:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35815 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3HNXFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:05:07 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Mark Brown <broonie@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH] regmap: Add another missing header for !CONFIG_REGMAP stubs
Date: Wed, 14 Aug 2013 16:05:02 -0700
Message-Id: <1376521502-9370-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of WARN_ON() needs the definitions from bug.h, without it
you can get:

include/linux/regmap.h: In function 'regmap_write':
include/linux/regmap.h:525:2: error: implicit declaration of function 'WARN_ONCE' [-Werror=implicit-function-declaration]

Cc: Mark Brown <broonie@linaro.org> 
Signed-off-by: Kevin Hilman <khilman@linaro.org> 
--- 
This one has been showing up in linux-next for a bit under various ARM
defconfigs (specifically ape6evm_defconfig and lager_defconfig)u

 include/linux/regmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index bafda87..a10380b 100644
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
1.8.3

