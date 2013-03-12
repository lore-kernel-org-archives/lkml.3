Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3CLKOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:14:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13876 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3CLKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:14:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Mar 2013 03:07:33 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 09/17] sh: replace CONFIG_GENERIC_GPIO by CONFIG_GPIOLIB
Date: Tue, 12 Mar 2013 19:12:22 +0900
Message-ID: <1363083150-30964-10-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH GPIO drivers all use gpiolib and CONFIG_GENERIC_GPIO is only selected
through CONFIG_GPIOLIB, yet some compilation units depended on
CONFIG_GENERIC_GPIO. Make them depend on CONFIG_GPIOLIB instead since it
is more accurate and prepares us for the future removal of
CONFIG_GENERIC_GPIO.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/sh/boards/mach-sdk7786/Makefile | 2 +-
 arch/sh/boards/mach-x3proto/Makefile | 2 +-
 arch/sh/kernel/cpu/sh2a/Makefile     | 2 +-
 arch/sh/kernel/cpu/sh3/Makefile      | 2 +-
 arch/sh/kernel/cpu/sh4a/Makefile     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/sh/boards/mach-sdk7786/Makefile b/arch/sh/boards/mach-sdk7786/Makefile
index 8ae56e9..45d32e3 100644
--- a/arch/sh/boards/mach-sdk7786/Makefile
+++ b/arch/sh/boards/mach-sdk7786/Makefile
@@ -1,4 +1,4 @@
 obj-y	:= fpga.o irq.o nmi.o setup.o
 
-obj-$(CONFIG_GENERIC_GPIO)	+= gpio.o
+obj-$(CONFIG_GPIOLIB)		+= gpio.o
 obj-$(CONFIG_HAVE_SRAM_POOL)	+= sram.o
diff --git a/arch/sh/boards/mach-x3proto/Makefile b/arch/sh/boards/mach-x3proto/Makefile
index 708c21c..0cbe3d0 100644
--- a/arch/sh/boards/mach-x3proto/Makefile
+++ b/arch/sh/boards/mach-x3proto/Makefile
@@ -1,3 +1,3 @@
 obj-y += setup.o ilsel.o
 
-obj-$(CONFIG_GENERIC_GPIO)	+= gpio.o
+obj-$(CONFIG_GPIOLIB)		+= gpio.o
diff --git a/arch/sh/kernel/cpu/sh2a/Makefile b/arch/sh/kernel/cpu/sh2a/Makefile
index 130984c..92f0da4 100644
--- a/arch/sh/kernel/cpu/sh2a/Makefile
+++ b/arch/sh/kernel/cpu/sh2a/Makefile
@@ -21,5 +21,5 @@ pinmux-$(CONFIG_CPU_SUBTYPE_SH7203)	:= pinmux-sh7203.o
 pinmux-$(CONFIG_CPU_SUBTYPE_SH7264)	:= pinmux-sh7264.o
 pinmux-$(CONFIG_CPU_SUBTYPE_SH7269)	:= pinmux-sh7269.o
 
-obj-$(CONFIG_GENERIC_GPIO)		+= $(pinmux-y)
+obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= ubc.o
diff --git a/arch/sh/kernel/cpu/sh3/Makefile b/arch/sh/kernel/cpu/sh3/Makefile
index 6f13f33..d3634ae 100644
--- a/arch/sh/kernel/cpu/sh3/Makefile
+++ b/arch/sh/kernel/cpu/sh3/Makefile
@@ -30,4 +30,4 @@ clock-$(CONFIG_CPU_SUBTYPE_SH7712)	:= clock-sh7712.o
 pinmux-$(CONFIG_CPU_SUBTYPE_SH7720)	:= pinmux-sh7720.o
 
 obj-y	+= $(clock-y)
-obj-$(CONFIG_GENERIC_GPIO)	+= $(pinmux-y)
+obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
diff --git a/arch/sh/kernel/cpu/sh4a/Makefile b/arch/sh/kernel/cpu/sh4a/Makefile
index 8fc6ec2..0705df7 100644
--- a/arch/sh/kernel/cpu/sh4a/Makefile
+++ b/arch/sh/kernel/cpu/sh4a/Makefile
@@ -47,6 +47,6 @@ pinmux-$(CONFIG_CPU_SUBTYPE_SHX3)	:= pinmux-shx3.o
 
 obj-y					+= $(clock-y)
 obj-$(CONFIG_SMP)			+= $(smp-y)
-obj-$(CONFIG_GENERIC_GPIO)		+= $(pinmux-y)
+obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= ubc.o
-- 
1.8.1.5

