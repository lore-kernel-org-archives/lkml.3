Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaDAETU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:19:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaDAENh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:13:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Scott Wood <scottwood@freescale.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.13 09/22] i2c: cpm: Fix build by adding of_address.h and of_irq.h
Date: Mon, 31 Mar 2014 21:08:39 -0700
Message-Id: <20140401040705.312926524@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-cpm.c |    2 ++
 1 file changed, 2 insertions(+)

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


