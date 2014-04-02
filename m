Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaDBU3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:29:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42812 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 33/40] i2c: cpm: Fix build by adding of_address.h and of_irq.h
Date: Wed,  2 Apr 2014 22:13:19 +0200
Message-Id: <6bff9edc55815ca1e9c6d44e7eb33b5bbfd1688c.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Wood <scottwood@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-cpm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index b2b8aa9adc0e..c5121459196b 100644
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
 #include <sysdev/fsl_soc.h>
 #include <asm/cpm.h>
-- 
1.9.1

