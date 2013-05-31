Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3EaWY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:24:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab3EaWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:24:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 00/15] Linux-3.10 ARM randconfig fixes
Date: Sat,  1 Jun 2013 00:22:37 +0200
Message-Id: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:PmrgznzmcWb2teth0ejGnztA1S22q2w8O/HK7e37i1e
 iwLT5DbzODGfiwwyGnQpQEv2SlXvl2mId7JApanUcCm4nvnaVZ
 v4UDDeKl5i75eppVitoGmjo8n980t3zkjwQ1DQTYFsmdWwNRW+
 ekaTNq6gInlhhLn1MdmIDc79AEqLglHI0hbQKL0oNs7fsTxhlI
 4AZ6s5PVcTciMagyYFia8YbClTMMnuzppJwthNT3uqcDzN/GqS
 8byrtGgJqM8IIPMFNCUscsdX+BibNS/0uJM6K26ppG07ospAUf
 dvVOmzQOXM/mpeyb90l4GcHu/kmMJSiR9GL4PBJgYvGvAfUc4Q
 hcQCrlsWqr5b7oVdBT+fgIOd9HyizlDvMpH2MYWFx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi subsystem maintainers,

These are a few patches left over from doing randconfig tests
a couple of weeks ago. Please apply them directly into your
trees unless you see problems. All patches can theoretically
be seen as bug fixes for 3.10, but they are not critical,
so applying them for 3.11 is fine as well.

	Arnd

Arnd Bergmann (15):
  irqdomain: export irq_domain_add_simple
  mtd: omap2: allow bulding as a module
  drm/nouveau: use mdelay instead of large udelay constants
  [SCSI] nsp32: use mdelay instead of large udelay constants
  hwrng: bcm2835: fix MODULE_LICENSE tag
  cpuidle: calxeda: select ARM_CPU_SUSPEND
  cpufreq: spear needs cpufreq table
  thermal: cpu_cooling: fix stub function
  drm: always provide debugfs function prototypes
  drm/tilcd: select BACKLIGHT_LCD_SUPPORT
  iwlegacy: il_pm_ops is only provided for PM_SLEEP
  [media] davinci: vpfe_capture needs i2c
  [media] omap3isp: include linux/mm_types.h
  clk: tegra: provide tegra_periph_reset_assert alternative
  OF: remove #ifdef from linux/of_platform.h

 drivers/char/hw_random/bcm2835-rng.c               |  2 +-
 drivers/cpufreq/Kconfig.arm                        |  1 +
 drivers/cpuidle/Kconfig                            |  1 +
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |  3 ++-
 drivers/gpu/drm/tilcdc/Kconfig                     |  1 +
 drivers/media/platform/davinci/Kconfig             |  3 +++
 drivers/media/platform/omap3isp/ispqueue.h         |  1 +
 drivers/mtd/nand/Kconfig                           |  2 +-
 drivers/net/wireless/iwlegacy/common.h             |  6 +++---
 drivers/scsi/nsp32.c                               |  2 +-
 include/drm/drmP.h                                 |  3 +--
 include/linux/clk/tegra.h                          |  5 +++++
 include/linux/cpu_cooling.h                        |  4 ++--
 include/linux/of_platform.h                        | 14 +++-----------
 kernel/irq/irqdomain.c                             |  1 +
 15 files changed, 27 insertions(+), 22 deletions(-)

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-pm@vger.kernel.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org


-- 
1.8.1.2

