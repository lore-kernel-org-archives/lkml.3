Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaFFKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:42:52 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:65530 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaFFKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:42:49 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, pebolle@tiscali.nl, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.carpenter@oracle.com
Date: Fri, 06 Jun 2014 19:44:52 +0900
Message-Id: <20140606104452.4423.16947.sendpatchset@w520>
In-Reply-To: <20140606104408.4423.36098.sendpatchset@w520>
References: <20140606104408.4423.36098.sendpatchset@w520>
Subject: [PATCH v3 05/05] staging: board: kzm9d: Board staging support for emxx_udc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Add staging board support for the KZM9D board and add
an emxx_udc platform device to allow in-tree continous 
development of the driver on the KZM9D board.

When DT bindings are ready for the emxx_udc driver then
the platform device in the KZM9D staging board code can
easily be removed. Until then we use platform devices
to continously improve the driver and integration code.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Changes since V2:
 - None

 Changes since V1:
 - Broke out staging board base patch
 - Compile in if CONFIG_ARCH_EMEV2 is selected
 - Make use of board_staging_dt_node_available()

 drivers/staging/board/Makefile |    1 +
 drivers/staging/board/kzm9d.c  |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

--- 0011/drivers/staging/board/Makefile
+++ work/drivers/staging/board/Makefile	2014-05-29 21:40:49.000000000 +0900
@@ -1 +1,2 @@
 obj-y	:= board.o
+obj-$(CONFIG_ARCH_EMEV2)      += kzm9d.o
--- /dev/null
+++ work/drivers/staging/board/kzm9d.c	2014-05-29 21:42:34.000000000 +0900
@@ -0,0 +1,19 @@
+/* Staging board support for KZM9D. Enable not-yet-DT-capable devices here. */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include "board.h"
+
+static const struct resource usbs1_res[] __initconst = {
+	DEFINE_RES_MEM(0xe2800000, 0x2000),
+	DEFINE_RES_IRQ(159),
+};
+
+static void __init kzm9d_init(void)
+{
+	if (!board_staging_dt_node_available(usbs1_res, ARRAY_SIZE(usbs1_res)))
+		platform_device_register_simple("emxx_udc", -1, usbs1_res,
+						ARRAY_SIZE(usbs1_res));
+}
+
+board_staging("renesas,kzm9d", kzm9d_init);
