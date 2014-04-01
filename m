Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaDAQNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:13:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaDAQNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:13:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Wood <scottwood@freescale.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 78/86] i2c: cpm: Fix build by adding of_address.h and of_irq.h
Date: Tue,  1 Apr 2014 09:08:31 -0700
Message-Id: <1396368519-12728-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Wood <scottwood@freescale.com>

commit 5f12c5eca6e6b7aeb4b2028d579f614b4fe7a81f upstream.

Fixes a build break due to the undeclared use of irq_of_parse_and_map()
and of_iomap().  This build break was apparently introduced while the
driver was unbuildable due to the bug fixed by
62c19c9d29e65086e5ae76df371ed2e6b23f00cd ("i2c: Remove usage of
orphaned symbol OF_I2C").  When 62c19c was added in v3.14-rc7,
the driver was enabled again, breaking the powerpc mpc85xx_defconfig
and mpc85xx_smp_defconfig.

62c19c is marked for stable, so this should go there as well.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-cpm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index 2e79c10..209bf1f 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -40,7 +40,9 @@
 #include <linux/i2c.h>
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of_i2c.h>
 #include <sysdev/fsl_soc.h>
-- 
1.8.3.2

