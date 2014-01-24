Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaAXMxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:53:01 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:33780 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaAXMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v4 03/15] [WIP] ARM: shmobile: genmai legacy: Add preliminary RSPI pinmux setup
Date: Fri, 24 Jan 2014 13:49:39 +0100
Message-Id: <1390567791-8988-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

This does not work yet, as there's no pinmux configuration in
setup-r7s72100.c

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v4:
  - The platform device basename was changed from "rspi" to "rspi-rz"
v3:
  - No changes
v2:
  - New

 arch/arm/mach-shmobile/board-genmai.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/mach-shmobile/board-genmai.c b/arch/arm/mach-shmobile/board-genmai.c
index 0b01b7f7e240..3d02167967ec 100644
--- a/arch/arm/mach-shmobile/board-genmai.c
+++ b/arch/arm/mach-shmobile/board-genmai.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/platform_device.h>
 #include <linux/sh_eth.h>
 #include <linux/spi/rspi.h>
@@ -77,9 +78,25 @@ static const struct spi_board_info spi_info[] __initconst = {
 	},
 };
 
+static const struct pinctrl_map genmai_pinctrl_map[] = {
+	/* RSPI4 */
+	PIN_MAP_MUX_GROUP_DEFAULT("rspi-rz.4", "pfc-r7s72100",
+				  "rspi4_rspck_p4_0", "rspi4"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rspi-rz.4", "pfc-r7s72100",
+				  "rspi4_ssl0_p4_1", "rspi4"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rspi-rz.4", "pfc-r7s72100",
+				  "rspi4_mosi_p4_2", "rspi4"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rspi-rz.4", "pfc-r7s72100",
+				  "rspi4_miso_p4_3", "rspi4"),
+};
+
 static void __init genmai_add_standard_devices(void)
 {
 	r7s72100_clock_init();
+	pinctrl_register_mappings(genmai_pinctrl_map,
+				  ARRAY_SIZE(genmai_pinctrl_map));
+	/* FIXME there's no pinmux configuration in setup-r7s72100.c yet */
+	/* r7s72100_pinmux_init(); */
 	r7s72100_add_dt_devices();
 
 	r7s72100_register_rspi(0);
-- 
1.7.9.5

