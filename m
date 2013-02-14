Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161190Ab3BNWsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:48:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161167Ab3BNWsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Airlie <airlied@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>, Rob Clark <rob@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Tony Lindgren <tony@atomide.com>,
        netdev@vger.kernel.org
Subject: [PATCH 0/9] arm-soc/for-next allyesconfig build regressions
Date: Thu, 14 Feb 2013 23:47:42 +0100
Message-Id: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:cthM1KeP1c4Cm1k7xbcT590E1GnFuVKCSWTEHP08VF3
 Mc6vLhk5Rhnu6oBII31yd2iYtsSMq9X2ASS03R6xZypxRTrAz7
 7WmDc3rOm2nkjXRv14GGiTpts2scehajRv2scCYwA8K94qCghf
 qL1sZl+CFcr5DdMXfl7rMj/qyp4i5oICaDB9FoG9Y4BUStihqc
 k3gPxSokpvpy8grqIxO7/5wmUTl6MFoWXc0OEray2LVjLVeq4X
 DIkh3z2oIJLKhYImGPAYEm+fxUkoXzWZrdx6V+bg+4dbPvZ86b
 ZdZWotU7EjV51Rvd2f4bVKTzxNYgTHIbpY6FB/ybCiBUwcAJlC
 qrtLcj+bo+H8B8GbgUsZuCQWLT6vYEl+UwJHQCBez
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the patches I still need to cleanly build allyesconfig
and allmodconfig on arm-soc/for-next. Please review and provide
Acks where appropriate so we can add the fixes directly to the
branches that introduce the problems, or apply them directly
to a maintainer tree where appropriate.

The bulk of these patches happen to be omap specific, which
does not mean that we had a lot of regressions in omap, but
that we just started including omap in the multiplatform
builds, which has uncovered a number of older problems that
we did not see before.

	Arnd

Arnd Bergmann (9):
  ARM: arch_timer: include linux/errno.h
  ARM: imx: MACH_MX31ADS_WM1133_EV1 needs REGULATOR_WM8350
  ARM: omap2: include linux/errno.h in hwmod_reset
  ARM: omap: add include guard for soc.h
  drm: export drm_vm_open_locked
  net: cwdavinci_cpdma: export symbols for cpsw
  remoteproc: omap: depend on OMAP_MBOX_FWK
  [HACK] ARM: imx: work around v7_cpu_resume link error
  [media] davinci: do not include mach/hardware.h

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Rob Clark <rob@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: netdev@vger.kernel.org

 arch/arm/kernel/arch_timer.c            | 1 +
 arch/arm/mach-imx/Kconfig               | 2 +-
 arch/arm/mach-imx/headsmp.S             | 4 +++-
 arch/arm/mach-omap2/omap_hwmod_reset.c  | 1 +
 arch/arm/mach-omap2/soc.h               | 3 +++
 drivers/gpu/drm/drm_vm.c                | 1 +
 drivers/media/platform/davinci/vpss.c   | 1 -
 drivers/net/ethernet/ti/davinci_cpdma.c | 3 +++
 drivers/remoteproc/Kconfig              | 2 +-
 9 files changed, 14 insertions(+), 4 deletions(-)

-- 
1.8.1.2

