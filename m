Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3CLKN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:13:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3853 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CLKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:13:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 03:13:10 -0700
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
Subject: [RFC 01/17] arm: remove unneeded select GENERIC_GPIO
Date: Tue, 12 Mar 2013 19:12:14 +0900
Message-ID: <1363083150-30964-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the selection of GENERIC_GPIO for S3C24XX and S5PC100 in
preparation of the removal of this option.

ARCH_REQUIRE_GPIOLIB (which also selects GENERIC_GPIO) is already
selected whenever these machines are chosen anyway, so this
patch should not have any side-effect.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ad06749..26b6ddd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -773,7 +773,6 @@ config ARCH_S3C24XX
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_GPIO
 	select HAVE_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
@@ -832,7 +831,6 @@ config ARCH_S5PC100
 	select CLKSRC_MMIO
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_GPIO
 	select HAVE_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
-- 
1.8.1.5

