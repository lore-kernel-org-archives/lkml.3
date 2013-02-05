Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3BEPFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:05:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3BEPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:05:51 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: Fix build for Allwinner A1X SoCs
Date: Tue,  5 Feb 2013 16:05:47 +0100
Message-Id: <1360076747-2162-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:Ai2CC7V9m99/9AEJrNNl7GSwwrnY5UGlqBF5EPaVYO8
 otLsk+ivaJnTOTnp/koJEzWjXaVqZQRxyMu4MQRj13tza1HxAy
 1yKsggCfJJtWDr0UVlQlGPCCS7a/geCGwi1sf6/2+A+V00RHbr
 FKQbfUSylvUwkL8bwGBj768+RRYhy89UP3oDkArv1XUlZqN1Du
 bWVcFIv5QitbW5YlENvN16Zx3iT+TeTBPhrVhhVLimcP6g/tnR
 A6w8iFstsoVMaWh0NAgaSNT1lMD3YvQK75xZWFlxY1dbjoSHnh
 EDr9zBIVl9Rri43EPv1HaJRoq7YqTTVl/LP0xbiy4wklCZjxEj
 JoHEOsUT+8F2RieBoj1xOW34YTkpJPtNduyxb/6BU1KzG6i/N6
 6vKNc6e7DBxTeJUCc3LZQZGWU+t8nvvk8RORiuhDQafD34cQ5Y
 bmZ8b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85a1819 (clk: sunxi: Use common of_clk_init() function) removed
the source file but didn't update the Makefile, therefore causing the
build to break on Allwinner A1X SoCs.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/clk/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index ce77077..be9392e 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -25,7 +25,6 @@ endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
-obj-$(CONFIG_ARCH_SUNXI)	+= clk-sunxi.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
 obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
-- 
1.8.1.2

