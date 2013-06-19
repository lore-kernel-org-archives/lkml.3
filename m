Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3FSSSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:18:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSSSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:18:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v11 resend 10/11] arm, change reboot_mode to use enum reboot_mode
Date: Wed, 19 Jun 2013 20:16:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
References: <1370519244-49918-1-git-send-email-holt@sgi.com> <12642293.RmlRtOVM54@wuerfel> <20130619102141.411c8e39.akpm@linux-foundation.org>
In-Reply-To: <20130619102141.411c8e39.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201306192016.00659.arnd@arndb.de>
X-Provags-ID: V02:K0:GdJA9uXb1eojTA9qkqwN3355BiDya+O3P5IGv/iPmbF
 BvPH/krdKA+dtTGeJy3ClOm0F1qeUxahUP+Hw5dvRMLRXd/G0J
 7Qnl4z70F7UV+tMisrMbVVnDyiT8ZlMg8795oqvfKe8NULpaJG
 2nmKGcFKEVLdfogq+jlK1MkelvutH3ImiwowngM8ZHbd7oOHbM
 2eJggopzNzKGH4cEadBE3mgtMOsOJcjutGtCdvN/75/hK/HYRX
 CRSV0HyDlrav/4XDbC9CV5Vr3zwUZ4nvt5KnioY4xL039UwGJg
 Z/Kkn0AC8P7MoObUj04Gnw2xp60kMBPHYZ344tUXI4Jm056m3m
 8lcaqfoZZ+oWeUet2jps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Andrew Morton wrote:
> This patchset gets a lot of rejects which I keep on fixing up.  Please
> merge up early in the merge window and compile-test (and review) the
> linux-next changes to make sure I didn't muck up the reject-fixing,
> then we should be fine.

Ok, good. The patch below is what I used locally to get everything to
build. Please fold that into the larger patch.

	Arnd

>From cc87f1a209e88d007f93c5c52813d523b753657b Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 19 Jun 2013 12:54:48 +0200
Subject: [PATCH] ARM: use enum reboot_type on new platforms

The interface has changed with "reboot: arm: change reboot_mode to
use enum reboot_mode" that is getting merged through the -mm tree.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index fe4d9ff..7c1bbe2e 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
+#include <linux/reboot.h>
 
 #include <asm/setup.h>
 #include <asm/mach/map.h>
@@ -49,7 +50,7 @@ static const char *keystone_match[] __initconst = {
 	NULL,
 };
 
-void keystone_restart(char mode, const char *cmd)
+void keystone_restart(enum reboot_mode mode, const char *cmd)
 {
 	u32 val;
 
diff --git a/arch/arm/mach-omap2/omap4-restart.c b/arch/arm/mach-omap2/omap4-restart.c
index 652adde..41dfd7d 100644
--- a/arch/arm/mach-omap2/omap4-restart.c
+++ b/arch/arm/mach-omap2/omap4-restart.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/reboot.h>
 #include "prminst44xx.h"
 
 /**
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index ef5b84f..c2c9083 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -26,6 +26,7 @@
 #include <linux/of_platform.h>
 #include <linux/of.h>
 #include <linux/irqchip.h>
+#include <linux/reboot.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -92,7 +93,7 @@ static void __init zynq_map_io(void)
 	zynq_scu_map_io();
 }
 
-static void zynq_system_reset(char mode, const char *cmd)
+static void zynq_system_reset(enum reboot_mode mode, const char *cmd)
 {
 	zynq_slcr_system_reset();
 }
