Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216Ab3EBPRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:17:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab3EBPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:17:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Robert Richter <rric@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, cpufreq@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-can@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        oprofile-list@lists.sf.net
Subject: [PATCH, RFC 00/22] ARM randconfig bugs
Date: Thu,  2 May 2013 17:16:04 +0200
Message-Id: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:V5o9m+oa7kdp/GQmwJ8Xm08vtxMkEfhlrwW+/2/0gsU
 1DF+NtMlp6LrTSEZkhJagFXRTB33k8iyDczznVpqz1zqnY26bB
 ks85pvJzxwyTUFgohXvScoMkALVVfNz98Pxet6FHb7KlVxklDV
 5aVZSaP/xNILups7UHKFZ947RbvObyMIKHgl92gmyn8+Mr5IRp
 N0EZIHT8HaBkiB71ucyXxajV8Yj3J54rbIxTelNSzdVxMzYCqD
 qAewfqB59KkxbFeaVbH+Z/nm9MJYRTDDUus/Rsm4H6taOmD3iE
 D+g81OovcYVZBOezZHJMNS1oz8eJHgpPG4a5qIVsQ3PQeGwD5b
 ZsN8rbz4X/JaFh5999S0/c+4/NPQCidQAIfDBgfzf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi subsystem maintainers,

This is a set of patches to to fix build errors I hit while trying to
build lots of randconfig kernels on linux-next.

Most of them are simple missing dependencies in Kconfig, but some are
more substantial. I would like to see at least the obvious patches
get merged for 3.10. If you are happy with the patches, feel free
to apply them directly, otherwise please provide feedback.

No single patch out of these is very important though, most of them
only concern corner cases and don't matter in practice.

	Arnd

Arnd Bergmann (22):
  can: move CONFIG_HAVE_CAN_FLEXCAN out of CAN_DEV
  cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
  cpuidle: calxeda: select ARM_CPU_SUSPEND
  staging/drm: imx: add missing dependencies
  drm: always provide debugfs function prototypes
  gpu/drm: host1x: add dependency on Tegra
  drm/tilcd: select BACKLIGHT_LCD_SUPPORT
  OMAPDSS: DPI needs DSI
  crypto: lz4: don't build on ARM
  mfd: ab8500: debugfs code depends on gpadc
  iwlegacy: il_pm_ops is only provided for PM_SLEEP
  thermal: cpu_cooling: fix stub function
  staging/logger: use kuid_t internally
  oprofile: always enable IRQ_WORK
  USB: EHCI: remove bogus #error
  USB: UHCI: clarify Kconfig dependencies
  USB: OHCI: clarify Kconfig dependencies
  Xen: SWIOTLB is only used on x86
  staging/solo6x10: depend on CONFIG_FONTS
  media: coda: select GENERIC_ALLOCATOR
  davinci: vpfe_capture needs i2c
  radio-si4713: depend on SND_SOC

 arch/Kconfig                           |  1 +
 crypto/Kconfig                         |  2 ++
 drivers/cpufreq/Kconfig.arm            |  1 +
 drivers/cpuidle/Kconfig                |  1 +
 drivers/gpu/drm/tilcdc/Kconfig         |  1 +
 drivers/gpu/host1x/drm/Kconfig         |  1 +
 drivers/media/platform/Kconfig         |  1 +
 drivers/media/platform/davinci/Kconfig |  3 ++
 drivers/media/radio/Kconfig            |  1 +
 drivers/mfd/Kconfig                    |  2 +-
 drivers/net/can/Kconfig                |  6 ++--
 drivers/net/wireless/iwlegacy/common.h |  2 +-
 drivers/staging/android/logger.c       |  4 +--
 drivers/staging/android/logger.h       |  2 +-
 drivers/staging/imx-drm/Kconfig        |  4 +++
 drivers/staging/media/solo6x10/Kconfig |  1 +
 drivers/usb/host/Kconfig               | 65 +++++++++++++++++++++++++++++-----
 drivers/usb/host/Makefile              |  4 +--
 drivers/usb/host/ehci-hcd.c            | 17 ---------
 drivers/usb/host/ohci-hcd.c            | 19 ----------
 drivers/usb/host/uhci-hcd.c            |  4 +--
 drivers/video/console/Makefile         |  2 ++
 drivers/video/omap2/dss/Kconfig        |  1 +
 drivers/xen/Kconfig                    |  2 +-
 include/drm/drmP.h                     |  3 +-
 include/linux/cpu_cooling.h            |  2 +-
 26 files changed, 91 insertions(+), 61 deletions(-)

-- 
1.8.1.2

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Robert Richter <rric@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: cpufreq@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-can@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: oprofile-list@lists.sf.net

