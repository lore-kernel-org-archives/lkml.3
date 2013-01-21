Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3AURW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:22:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3AURQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:16:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Heiko Schocher <hs@denx.de>,
        Sekhar Nori <nsekhar@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 11/15] mtd: davinci_nand: fix OF support
Date: Mon, 21 Jan 2013 17:16:04 +0000
Message-Id: <1358788568-11137-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3R9FYvVfs9FUkqiMSUn7q49Fbs+fyE/xYytmn8D22ny
 q5RatoT6UJYA1D5Oqx+8AZSPchWredfw7haRQ0dF2NVpT4rRlx
 Ecrhc9SZEmjyUp4bp4YWrL1zL65Y6xBfRIpLPbpV4QsLNacMFg
 1QhocwjlBCIaWjne4SKlaTgKUYHPi+tqzMi3UbQkMwXFlo+uOt
 8Hu3XW+A1H3QTQF4J2bQBUSHoc/276tP312B8fR6qKvRGhwVqw
 wniHxARLBPQn1dgfw6X1YCuAdo5dbuCwG7JqFAWI79spLGs8Nz
 vHBZvP/c1s/206+G3Ip7sIjZteUSLJVMep5uECsUFcludB6xQu
 olEZX9E3YhHe5Aqz+2519JSD3Wz80aPFcv3BgC36B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch cdeadd "mtd: nand: davinci: add OF support for
davinci nand controller" ironically causes a build error
when CONFIG_OF is enabled because of a missing ';'
character:

drivers/mtd/nand/davinci_nand.c:527:1: error: expected ',' or ';' before 'extern'

This is the obvious fix.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Schocher <hs@denx.de>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/mtd/nand/davinci_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 3502606..feae55c 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -523,7 +523,7 @@ static struct nand_ecclayout hwecc4_2048 __initconst = {
 static const struct of_device_id davinci_nand_of_match[] = {
 	{.compatible = "ti,davinci-nand", },
 	{},
-}
+};
 MODULE_DEVICE_TABLE(of, davinci_nand_of_match);
 
 static struct davinci_nand_pdata
-- 
1.7.10.4

