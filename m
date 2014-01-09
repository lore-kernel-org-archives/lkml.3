Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaAIIbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:31:39 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57747 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaAIIbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:31:34 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: horms@verge.net.au
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari.prasannamurthy@linaro.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:SHMOBILE: Enable AUTO_ZRELADDR by default
Date: Thu,  9 Jan 2014 14:01:14 +0530
Message-Id: <1389256274-6308-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables AUTO_ZRELADDR as default config to Renasas R-Mobile and
SH-Mobile platforms.

AUTO_ZRELADDR config enables auto calculation of the decompressed kernel image
address. AUTO_ZRELADDR config is mutually exclusive to ZBOOT_ROM, and also
assumes zImage to be loaded in the first 128MiB from start of memory.

CFT::Call For Testing

Requesting maintainers of R-Mobile and SH-Mobile platforms to evaluate the
changes on the board and comment, as I dont have the board for testing, and
also requesting an ACK.

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <damm@opensource.se>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
Below lkml link is a quoting by Russell which clears the concept of PHYS_VIRT
and ZRELADDR
---------------------------------------------------

https://lkml.org/lkml/2011/10/14/434

-------------------------------------------------
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 8e668e2..077ef9d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -674,6 +674,7 @@ config ARCH_MSM
 config ARCH_SHMOBILE
 	bool "Renesas SH-Mobile / R-Mobile"
 	select ARM_PATCH_PHYS_VIRT
+	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU if SMP
-- 
1.7.10.4

