Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3FZOke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:40:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57199 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab3FZOkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:40:31 -0400
From: Nishanth Menon <nm@ti.com>
To: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nishanth Menon <nm@ti.com>
Subject: [-next PATCH 0/2] ARM: OMAP5: fix build breakage due to SCU usage
Date: Wed, 26 Jun 2013 09:39:45 -0500
Message-ID: <1372257587-21720-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Cortex-A15 based OMAP5 does not use Snoop Control Unit(SCU)[1].
However, there is lot of code that is shared between Cortex-A9 based
OMAP4 and OMAP5, hence functionality code is shared with runtime usage
of SCU based on SoC worked on. However on building with OMAP5 only
generates the following errors:
arch/arm/mach-omap2/built-in.o: In function `scu_gp_set':
arch/arm/mach-omap2/sleep44xx.S:132: undefined reference to `scu_power_mode'
arch/arm/mach-omap2/built-in.o: In function `scu_gp_clear':
arch/arm/mach-omap2/sleep44xx.S:229: undefined reference to `scu_power_mode'
arch/arm/mach-omap2/built-in.o: In function `omap4_smp_init_cpus':
arch/arm/mach-omap2/omap-smp.c:185: undefined reference to `scu_get_core_count'
arch/arm/mach-omap2/built-in.o: In function `omap4_smp_prepare_cpus':
arch/arm/mach-omap2/omap-smp.c:211: undefined reference to `scu_enable'

This was attempted to be "fixed" in various attempts in the past [2] [3].

This series applies on top of the other fixes in discussion for linux-next [4] [5].

Based on:
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git  next-20130626

Nishanth Menon (2):
  ARM: OMAP4: sleep: build OMAP4 specific functions only for OMAP4
  ARM: scu: provide inline dummy functions when SCU is not present

 arch/arm/include/asm/smp_scu.h  |   13 ++++++++++++-
 arch/arm/mach-omap2/sleep44xx.S |    6 +++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

[1] http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0407e/CHDFJICC.html
[2] https://patchwork.kernel.org/patch/2568091/
[3] http://marc.info/?t=137120115400001&r=1&w=2
[4] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/178209.html
[5] https://patchwork.kernel.org/patch/2781471/

Regards,
Nishanth Menon
-- 
1.7.9.5

