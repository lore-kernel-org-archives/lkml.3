Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaBKRxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:53:34 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56020 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751694AbaBKRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:52:49 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v2 2/2] mfd: vexpress-sysreg: Add syscon labels as platform data
Date: Tue, 11 Feb 2014 17:52:45 +0000
Message-Id: <1392141165-14338-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
References: <20140211174829.GJ15081@lee--X1>
 <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds platform data with label names for syscon
registers in the relevant MFD cells.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-sysreg.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index ece5ac8..952df84 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -17,6 +17,7 @@
 #include <linux/mfd/core.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/platform_data/syscon.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
@@ -132,6 +133,10 @@ void __init vexpress_sysreg_early_init(void __iomem *base)
 
 /* The sysreg block is just a random collection of various functions... */
 
+static struct syscon_platform_data vexpress_sysreg_sys_id_pdata = {
+	.label = "sys_id",
+};
+
 static struct bgpio_pdata vexpress_sysreg_sys_led_pdata = {
 	.label = "sys_led",
 	.base = -1,
@@ -150,6 +155,14 @@ static struct bgpio_pdata vexpress_sysreg_sys_flash_pdata = {
 	.ngpio = 1,
 };
 
+static struct syscon_platform_data vexpress_sysreg_sys_misc_pdata = {
+	.label = "sys_misc",
+};
+
+static struct syscon_platform_data vexpress_sysreg_sys_procid_pdata = {
+	.label = "sys_procid",
+};
+
 static struct mfd_cell vexpress_sysreg_cells[] = {
 	{
 		.name = "syscon",
@@ -157,6 +170,8 @@ static struct mfd_cell vexpress_sysreg_cells[] = {
 		.resources = (struct resource []) {
 			DEFINE_RES_MEM(SYS_ID, 0x4),
 		},
+		.platform_data = &vexpress_sysreg_sys_id_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_id_pdata),
 	}, {
 		.name = "basic-mmio-gpio",
 		.of_compatible = "arm,vexpress-sysreg,sys_led",
@@ -190,12 +205,16 @@ static struct mfd_cell vexpress_sysreg_cells[] = {
 		.resources = (struct resource []) {
 			DEFINE_RES_MEM(SYS_MISC, 0x4),
 		},
+		.platform_data = &vexpress_sysreg_sys_misc_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_misc_pdata),
 	}, {
 		.name = "syscon",
 		.num_resources = 1,
 		.resources = (struct resource []) {
 			DEFINE_RES_MEM(SYS_PROCID0, 0x8),
 		},
+		.platform_data = &vexpress_sysreg_sys_procid_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_procid_pdata),
 	}, {
 		.name = "vexpress-syscfg",
 		.num_resources = 1,
-- 
1.8.3.2

