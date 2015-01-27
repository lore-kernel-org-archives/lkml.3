Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbbA0MVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:21:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35510 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbbA0MUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 126/126] ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances
Date: Tue, 27 Jan 2015 12:17:11 +0000
Message-Id: <1422361031-19364-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-shmobile/setup-sh73a0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index ad00724a2269..f8584664369a 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -576,6 +576,7 @@ static struct platform_device ipmmu_device = {
 
 static struct renesas_intc_irqpin_config irqpin0_platform_data = {
 	.irq_base = irq_pin(0), /* IRQ0 -> IRQ7 */
+	.control_parent = true,
 };
 
 static struct resource irqpin0_resources[] = {
@@ -637,6 +638,7 @@ static struct platform_device irqpin1_device = {
 
 static struct renesas_intc_irqpin_config irqpin2_platform_data = {
 	.irq_base = irq_pin(16), /* IRQ16 -> IRQ23 */
+	.control_parent = true,
 };
 
 static struct resource irqpin2_resources[] = {
@@ -667,6 +669,7 @@ static struct platform_device irqpin2_device = {
 
 static struct renesas_intc_irqpin_config irqpin3_platform_data = {
 	.irq_base = irq_pin(24), /* IRQ24 -> IRQ31 */
+	.control_parent = true,
 };
 
 static struct resource irqpin3_resources[] = {
-- 
2.1.4

