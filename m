Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3KQSyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:54:05 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:38265 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KQSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:53:59 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Cyril Chemparathy <cyril@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd: ti-ssp: Fix build
Date: Sun, 17 Nov 2013 19:53:55 +0100
Message-Id: <1384714435-30474-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    drivers/mfd/ti-ssp.c: In function 'ti_ssp_run':
    drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function 'set_current_state' [-Werror=implicit-function-declaration]
    drivers/mfd/ti-ssp.c:286:381: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
    drivers/mfd/ti-ssp.c:286:381: note: each undeclared identifier is reported only once for each function it appears in
    drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function 'signal_pending' [-Werror=implicit-function-declaration]
    drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function 'schedule' [-Werror=implicit-function-declaration]
    drivers/mfd/ti-ssp.c:286:2: error: implicit declaration of function '__set_current_state' [-Werror=implicit-function-declaration]
    drivers/mfd/ti-ssp.c:286:742: error: 'TASK_RUNNING' undeclared (first use in this function)
    drivers/mfd/ti-ssp.c: In function 'ti_ssp_interrupt':
    drivers/mfd/ti-ssp.c:311:32: error: 'TASK_NORMAL' undeclared (first use in this function)

Add missing #include <linux/sched.h>.

    drivers/mfd/ti-ssp.c: In function 'ti_ssp_probe':
    drivers/mfd/ti-ssp.c:412:12: error: 'struct mfd_cell' has no member named 'data_size'

data_size became unused in commit 40e03f571b2e63827f2afb90ea9aa459612c29e3
("mfd: Drop data_size from mfd_cell struct"), hence remove its
initialization.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/ti-ssp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ti-ssp.c b/drivers/mfd/ti-ssp.c
index 71e3e0c5bf73..a5424579679c 100644
--- a/drivers/mfd/ti-ssp.c
+++ b/drivers/mfd/ti-ssp.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/ti_ssp.h>
 
@@ -409,7 +410,6 @@ static int ti_ssp_probe(struct platform_device *pdev)
 		cells[id].id		= id;
 		cells[id].name		= data->dev_name;
 		cells[id].platform_data	= data->pdata;
-		cells[id].data_size	= data->pdata_size;
 	}
 
 	error = mfd_add_devices(dev, 0, cells, 2, NULL, 0, NULL);
-- 
1.7.9.5

