Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaAYVaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:30:00 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:56924 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaAYV35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:29:57 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 9/9] ARM: dts: omap3-gta04: Add ti,omap36xx to compatible property to avoid problems with booting.
Date: Sat, 25 Jan 2014 22:29:03 +0100
Message-Id: <1390685343-11663-10-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390685343-11663-1-git-send-email-marek@goldelico.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without that change booting leads to crash with more warnings like below:
[    0.284454] omap_hwmod: uart4: cannot clk_get main_clk uart4_fck
[    0.284484] omap_hwmod: uart4: cannot _init_clocks
[    0.284484] ------------[ cut here ]------------
[    0.284545] WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2543 _init+0x300/0x3e4()
[    0.284545] omap_hwmod: uart4: couldn't init clocks
[    0.284576] Modules linked in:
[    0.284606] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-next-20140124-00020-gd2aefec-dirty #26
[    0.284637] [<c00151c0>] (unwind_backtrace) from [<c0011e20>] (show_stack+0x10/0x14)
[    0.284667] [<c0011e20>] (show_stack) from [<c0568544>] (dump_stack+0x7c/0x94)
[    0.284729] [<c0568544>] (dump_stack) from [<c003ff94>] (warn_slowpath_common+0x6c/0x90)
[    0.284729] [<c003ff94>] (warn_slowpath_common) from [<c003ffe8>] (warn_slowpath_fmt+0x30/0x40)
[    0.284759] [<c003ffe8>] (warn_slowpath_fmt) from [<c07d1be8>] (_init+0x300/0x3e4)
[    0.284790] [<c07d1be8>] (_init) from [<c07d217c>] (__omap_hwmod_setup_all+0x40/0x8c)
[    0.284820] [<c07d217c>] (__omap_hwmod_setup_all) from [<c0008918>] (do_one_initcall+0xe8/0x14c)
[    0.284851] [<c0008918>] (do_one_initcall) from [<c07c5c18>] (kernel_init_freeable+0x104/0x1c8)
[    0.284881] [<c07c5c18>] (kernel_init_freeable) from [<c0563524>] (kernel_init+0x8/0x118)
[    0.284912] [<c0563524>] (kernel_init) from [<c000e368>] (ret_from_fork+0x14/0x2c)
[    0.285064] ---[ end trace 63de210ad43b627d ]---

Reference:
https://lkml.org/lkml/2013/10/8/553

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index ea1b94d..998fe1e 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -13,7 +13,7 @@
 
 / {
 	model = "OMAP3 GTA04";
-	compatible = "ti,omap3-gta04", "ti,omap3";
+	compatible = "ti,omap3-gta04", "ti,omap36xx", "ti,omap3";
 
 	cpus {
 		cpu@0 {
-- 
1.8.3.2

