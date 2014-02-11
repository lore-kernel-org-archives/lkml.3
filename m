Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaBKTHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaBKTHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.10 25/79] xtensa: xtfpga: fix definitions of platform devices
Date: Tue, 11 Feb 2014 11:05:29 -0800
Message-Id: <20140211184721.654783288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit a558d99263936b8a67d4eff8918745a77bfd8c31 upstream.

Remove __initdata attribute, as the devices may be used after init
sections are freed.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/platforms/xtfpga/setup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -195,7 +195,7 @@ void platform_calibrate_ccount(void)
  *  Ethernet -- OpenCores Ethernet MAC (ethoc driver)
  */
 
-static struct resource ethoc_res[] __initdata = {
+static struct resource ethoc_res[] = {
 	[0] = { /* register space */
 		.start = OETH_REGS_PADDR,
 		.end   = OETH_REGS_PADDR + OETH_REGS_SIZE - 1,
@@ -213,7 +213,7 @@ static struct resource ethoc_res[] __ini
 	},
 };
 
-static struct ethoc_platform_data ethoc_pdata __initdata = {
+static struct ethoc_platform_data ethoc_pdata = {
 	/*
 	 * The MAC address for these boards is 00:50:c2:13:6f:xx.
 	 * The last byte (here as zero) is read from the DIP switches on the
@@ -223,7 +223,7 @@ static struct ethoc_platform_data ethoc_
 	.phy_id = -1,
 };
 
-static struct platform_device ethoc_device __initdata = {
+static struct platform_device ethoc_device = {
 	.name = "ethoc",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(ethoc_res),
@@ -237,13 +237,13 @@ static struct platform_device ethoc_devi
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
@@ -256,7 +256,7 @@ static struct plat_serial8250_port seria
 	{ },
 };
 
-static struct platform_device xtavnet_uart __initdata = {
+static struct platform_device xtavnet_uart = {
 	.name		= "serial8250",
 	.id		= PLAT8250_DEV_PLATFORM,
 	.dev		= {


