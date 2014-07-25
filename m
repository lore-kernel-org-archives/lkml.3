Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaGYOYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:24:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53440 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751868AbaGYOYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:24:13 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 1/5] ARM: imx: Remove references to platform_bus in mxc code
Date: Fri, 25 Jul 2014 15:23:49 +0100
Message-Id: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus devices created to be parents for other peripherals
were using platform_bus as a parent, not being platform
devices themselves. Remove the references, making them
virtual devices instead.

Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

This patch is a part of effort to remove references to platform_bus
and make it static.

Shawn, Sascha - could you, please, have a look if such change
is acceptable for you?

 arch/arm/mach-imx/devices/devices.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-imx/devices/devices.c b/arch/arm/mach-imx/devices/devices.c
index 1b4366a..8eab544 100644
--- a/arch/arm/mach-imx/devices/devices.c
+++ b/arch/arm/mach-imx/devices/devices.c
@@ -24,12 +24,10 @@
 
 struct device mxc_aips_bus = {
 	.init_name	= "mxc_aips",
-	.parent		= &platform_bus,
 };
 
 struct device mxc_ahb_bus = {
 	.init_name	= "mxc_ahb",
-	.parent		= &platform_bus,
 };
 
 int __init mxc_device_init(void)
-- 
1.9.1

