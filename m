Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaBJUI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:08:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaBJTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 062/124] xtensa: xtfpga: fix definitions of platform devices
Date: Mon, 10 Feb 2014 11:40:02 -0800
Message-Id: <1392061264-28124-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit a558d99263936b8a67d4eff8918745a77bfd8c31 upstream.

Remove __initdata attribute, as the devices may be used after init
sections are freed.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/platforms/xtfpga/setup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 4b9951a..6182f28 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -193,7 +193,7 @@ void platform_calibrate_ccount(void)
  *  Ethernet -- OpenCores Ethernet MAC (ethoc driver)
  */
 
-static struct resource ethoc_res[] __initdata = {
+static struct resource ethoc_res[] = {
 	[0] = { /* register space */
 		.start = OETH_REGS_PADDR,
 		.end   = OETH_REGS_PADDR + OETH_REGS_SIZE - 1,
@@ -211,7 +211,7 @@ static struct resource ethoc_res[] __initdata = {
 	},
 };
 
-static struct ethoc_platform_data ethoc_pdata __initdata = {
+static struct ethoc_platform_data ethoc_pdata = {
 	/*
 	 * The MAC address for these boards is 00:50:c2:13:6f:xx.
 	 * The last byte (here as zero) is read from the DIP switches on the
@@ -221,7 +221,7 @@ static struct ethoc_platform_data ethoc_pdata __initdata = {
 	.phy_id = -1,
 };
 
-static struct platform_device ethoc_device __initdata = {
+static struct platform_device ethoc_device = {
 	.name = "ethoc",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(ethoc_res),
@@ -235,13 +235,13 @@ static struct platform_device ethoc_device __initdata = {
  *  UART
  */
 
-static struct resource serial_resource __initdata = {
+static struct resource serial_resource = {
 	.start	= DUART16552_PADDR,
 	.end	= DUART16552_PADDR + 0x1f,
 	.flags	= IORESOURCE_MEM,
 };
 
-static struct plat_serial8250_port serial_platform_data[] __initdata = {
+static struct plat_serial8250_port serial_platform_data[] = {
 	[0] = {
 		.mapbase	= DUART16552_PADDR,
 		.irq		= DUART16552_INTNUM,
@@ -254,7 +254,7 @@ static struct plat_serial8250_port serial_platform_data[] __initdata = {
 	{ },
 };
 
-static struct platform_device xtavnet_uart __initdata = {
+static struct platform_device xtavnet_uart = {
 	.name		= "serial8250",
 	.id		= PLAT8250_DEV_PLATFORM,
 	.dev		= {
-- 
1.8.3.2

