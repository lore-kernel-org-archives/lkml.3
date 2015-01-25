Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbbAYSYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:24:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbbAYSKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3.18 172/183] ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances
Date: Sun, 25 Jan 2015 10:08:14 -0800
Message-Id: <20150125180817.643355034@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit b0ddb319db3d7a1943445f0de0a45c07a7f3457a upstream.

The sh73a0 INTC can't mask interrupts properly most likely due to a
hardware bug. Set the .control_parent flag to delegate masking to the
parent interrupt controller, like was already done for irqpin1.

Without this, accessing the three-axis digital accelerometer ADXL345
on kzm9g through /dev/input/event1 causes an interrupt storm, which
requires a power-cycle to recover from.

This was inspired by a patch for arch/arm/boot/dts/sh73a0.dtsi from
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 341eb5465f67437a ("ARM: shmobile: INTC External IRQ pin driver on sh73a0")
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-shmobile/setup-sh73a0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -598,6 +598,7 @@ static struct platform_device ipmmu_devi
 
 static struct renesas_intc_irqpin_config irqpin0_platform_data = {
 	.irq_base = irq_pin(0), /* IRQ0 -> IRQ7 */
+	.control_parent = true,
 };
 
 static struct resource irqpin0_resources[] = {
@@ -659,6 +660,7 @@ static struct platform_device irqpin1_de
 
 static struct renesas_intc_irqpin_config irqpin2_platform_data = {
 	.irq_base = irq_pin(16), /* IRQ16 -> IRQ23 */
+	.control_parent = true,
 };
 
 static struct resource irqpin2_resources[] = {
@@ -689,6 +691,7 @@ static struct platform_device irqpin2_de
 
 static struct renesas_intc_irqpin_config irqpin3_platform_data = {
 	.irq_base = irq_pin(24), /* IRQ24 -> IRQ31 */
+	.control_parent = true,
 };
 
 static struct resource irqpin3_resources[] = {


