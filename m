Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3AYWqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:46:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60500 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3AYWqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:46:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: [PATCH 09/19] mfd/twl4030: don't warn about uninitialized return code
Date: Fri, 25 Jan 2013 22:44:08 +0000
Message-Id: <1359153858-31992-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VQ5cUH2vucZWuoAoG+xWGFbjtgiKN8zBUHiZFmHj2x6
 BowfukFhISCVzkS2QgXiEAAzi2EZT6FA4sGbCJcz8j9Xaed21G
 ps6D/rslt2qSHImOgdqlUISaeMH2LXbjomq/Ey4+kuYecbnTJI
 mrflvZdXkpHQBNWHUA9IY7xEgfY8E4EmRncn0BmLcZPTvqIJFp
 nVZ+9OF9Fll4fESay/5vFKfE36xEw5uCoY3O+Geyy2s4jSxrzz
 RIKMMzaJRnxm4okUDIt9QXt7qVAp3h+TG3L665uEejWEGxM2yG
 vkiM8FzPfuN1u/cjcnO7W6ZKQkX7TWs95d/hw2kFblnLCWghtg
 DxMDM5udLdlhP//MizOBUtUVjVBASAiP6WQ3h9mI8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the twl4030_write_script function gets called with
a zero length argument, its return value does not
get set. We know that all scripts have a nonzero
length, but returning an error in case they ever
do is probably appropriate.

Without this patch, building omap2plus_defconfig results in:

drivers/mfd/twl4030-power.c: In function 'load_twl4030_script':
drivers/mfd/twl4030-power.c:414:5: error: 'err' may be used uninitialized in this function

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Kristo, Tero" <t-kristo@ti.com>
---
 drivers/mfd/twl4030-power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 4dae241..dd362c1 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -159,7 +159,7 @@ out:
 static int twl4030_write_script(u8 address, struct twl4030_ins *script,
 				       int len)
 {
-	int err;
+	int err = -EINVAL;
 
 	for (; len; len--, address++, script++) {
 		if (len == 1) {
-- 
1.8.0

