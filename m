Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3AURQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:16:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3AURQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:16:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/15] mfd/vexpress: export vexpress_config_func_{put,get}
Date: Mon, 21 Jan 2013 17:16:03 +0000
Message-Id: <1358788568-11137-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:p5L7DL6xAreb+cNisXmA9EltyjArZ4+1PeRg2uAWtzU
 Lz1AGW+e0AUM107iqXFf76iIQoXR5/1TSUH2Nef5/fHDEzpx+6
 Q2hDvIcWKDGjDskZR6/d9KAwsF8jJ3e0ruWMsvE+2ztaVv9p67
 9VWZTTOQw7zmEe3/KQ6Q36mlFCdBPZtvec6etGajo0GREQkUnv
 t3HfjjlMQqbqU08ICmHO7BrJfG37zHcnCpY6Oy+jB4Fw9gu7bK
 kStEy6vFhEQ0m9uugMiRqGmucwa0wjxlSxCXNn6BL9uTsAPa1N
 bqNqBXFVMFzvxz57PhcUgHhb3XNsm7946XllggfzoVQfs10uNL
 HlXGw4SXVCeZ3C8gXE0s4Ere9PpiTuZS7Xi5Ly5KE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly introduced vexpress mfd driver in linux-3.8-rc
provides access to configuration functions, but the
interfaces are not exported to modules, which breaks
when the vexpress regulator driver tries to use them.

Without this patch, building allmodconfig results in:

ERROR: "__vexpress_config_func_get" [drivers/regulator/vexpress.ko] undefined!
ERROR: "vexpress_config_func_put" [drivers/regulator/vexpress.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/vexpress-config.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index fae15d8..3cb34aa 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -142,6 +142,7 @@ struct vexpress_config_func *__vexpress_config_func_get(struct device *dev,
 
 	return func;
 }
+EXPORT_SYMBOL_GPL(__vexpress_config_func_get);
 
 void vexpress_config_func_put(struct vexpress_config_func *func)
 {
@@ -149,7 +150,7 @@ void vexpress_config_func_put(struct vexpress_config_func *func)
 	of_node_put(func->bridge->node);
 	kfree(func);
 }
-
+EXPORT_SYMBOL_GPL(vexpress_config_func_put);
 
 struct vexpress_config_trans {
 	struct vexpress_config_func *func;
-- 
1.7.10.4

