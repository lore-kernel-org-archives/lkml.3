Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaEHO4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:56:47 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62060 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaEHO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH] regulator: arizona-ldo1: add missing #include
Date: Thu,  8 May 2014 16:56:30 +0200
Message-Id: <1399560990-1402858-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:M9tp6yhU6Wn84f/shYTCPs7KVVUjavH5dPTZ+0EH5Uy
 bXocE+YnIsrFcWEzMr3PRUIte4p0s69nzfOhvfp1FbgmJgbACf
 bksRtNju7PIRW2oJptuWrEevZkY+NDQ04Yldm6m6lVItXVtNRm
 YfFaq+x1vrXnk/U7WsqImj9l/TTEDY4q9AXwCIMlvF3V0w7l1K
 acbSQELmEdcSn1ay1sewUWjIwphvdKQkqp85aV/wLZeJez6FHj
 uufFLZtxznfsy4twOt6X3oGlUbgwamcGbgVl+QNDu5vnEYadk8
 92HePEnxtkT/4Uop5Mve52CDkhvx70AYqmT0Z2TFVGKymStAJs
 0yG0PiLD4CwWmD5mC5BFnKyxSqKYDE1+EUiC+qlyW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2cce4be9e6b8 "regulator: arizona-ldo1: Add processing of init_data
from device tree" added a call to of_get_child_by_name() but
did not add an #include to the header file declaring that function.

I got a build error when doing randconfig testing on this, which
is fixed by this patch to include of.h.

drivers/regulator/arizona-ldo1.c:192:2: error: implicit declaration of function 'of_get_child_by_name' [-Werror=implicit-function-declaration]
drivers/regulator/arizona-ldo1.c:193:2: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]
drivers/regulator/arizona-ldo1.c:213:2: error: implicit declaration of function 'of_node_put' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/arizona-ldo1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index d3787e1..04f262a 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-- 
1.8.3.2

