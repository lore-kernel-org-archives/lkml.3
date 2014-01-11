Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaAMMZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:25:50 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:48346 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751384AbaAMMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:24:42 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
Date: Sat, 11 Jan 2014 13:06:29 +0000
Message-Id: <1389445589-21502-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel is built to support multi-arm configurmation with shmobile
support built in, then the drivers/sh is not built. This contains drivers
that are essential to devices support by that configuration, including the
PM runtime code in drivers/sh/pm_runtime.c (which implicitly enables the
bus clocks for all devices).

If CONFIG_ARCH_SHMOBILE_MULTI then build the drivers/sh directory,
but ensure that bits that may conflict (drivers/sh/clk if the common
clock framework is not enabled) are built.

The ARCH_SHMOBILE_MULTI was added by efacfce5f8a ("ARM: shmobile: Introduce
ARCH_SHMOBILE_MULTI") but this has only just recently been found due to
building device-tree only kernels.

Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Linus SH list <linux-sh@vger.kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/Makefile    | 1 +
 drivers/sh/Makefile | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/Makefile b/drivers/Makefile
index 8e3b8b0..abc4744 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
+obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= sh/
 ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 obj-y				+= clocksource/
diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
index fc67f56..86604a5 100644
--- a/drivers/sh/Makefile
+++ b/drivers/sh/Makefile
@@ -3,7 +3,10 @@
 #
 obj-y	:= intc/
 
+ifeq ($(CONFIG_COMMON_CLK),n)
 obj-$(CONFIG_HAVE_CLK)		+= clk/
+endif
+
 obj-$(CONFIG_MAPLE)		+= maple/
 obj-$(CONFIG_SUPERHYWAY)	+= superhyway/
 
-- 
1.8.5.2

