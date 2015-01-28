Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbbA2K0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:26:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756372AbbA2JAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 125/176] ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances
Date: Wed, 28 Jan 2015 15:29:15 +0100
Message-Id: <95985112abd0102b6e95f5e7499d5717235511ea.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-shmobile/setup-sh73a0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index 22de17417fd7..a10565d720c5 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -746,6 +746,7 @@ static struct platform_device ipmmu_device = {
 
 static struct renesas_intc_irqpin_config irqpin0_platform_data = {
 	.irq_base = irq_pin(0), /* IRQ0 -> IRQ7 */
+	.control_parent = true,
 };
 
 static struct resource irqpin0_resources[] = {
@@ -807,6 +808,7 @@ static struct platform_device irqpin1_device = {
 
 static struct renesas_intc_irqpin_config irqpin2_platform_data = {
 	.irq_base = irq_pin(16), /* IRQ16 -> IRQ23 */
+	.control_parent = true,
 };
 
 static struct resource irqpin2_resources[] = {
@@ -837,6 +839,7 @@ static struct platform_device irqpin2_device = {
 
 static struct renesas_intc_irqpin_config irqpin3_platform_data = {
 	.irq_base = irq_pin(24), /* IRQ24 -> IRQ31 */
+	.control_parent = true,
 };
 
 static struct resource irqpin3_resources[] = {
-- 
2.2.2

