Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688Ab3EBSpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:45:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55392 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761658Ab3EBSpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:45:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
        Robert Richter <rric@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, cpufreq@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-can@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        oprofile-list@lists.sf.net
Subject: Re: [PATCH, RFC 00/22] ARM randconfig bugs
Date: Thu, 02 May 2013 20:53:44 +0200
Message-ID: <2710056.LHQ0Ee0x8t@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 02, 2013 05:16:04 PM Arnd Bergmann wrote:
> Hi subsystem maintainers,
> 
> This is a set of patches to to fix build errors I hit while trying to
> build lots of randconfig kernels on linux-next.
> 
> Most of them are simple missing dependencies in Kconfig, but some are
> more substantial. I would like to see at least the obvious patches
> get merged for 3.10. If you are happy with the patches, feel free
> to apply them directly, otherwise please provide feedback.
> 
> No single patch out of these is very important though, most of them
> only concern corner cases and don't matter in practice.

For cpufreq and cpuidle:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> Arnd Bergmann (22):
>   can: move CONFIG_HAVE_CAN_FLEXCAN out of CAN_DEV
>   cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
>   cpuidle: calxeda: select ARM_CPU_SUSPEND
>   staging/drm: imx: add missing dependencies
>   drm: always provide debugfs function prototypes
>   gpu/drm: host1x: add dependency on Tegra
>   drm/tilcd: select BACKLIGHT_LCD_SUPPORT
>   OMAPDSS: DPI needs DSI
>   crypto: lz4: don't build on ARM
>   mfd: ab8500: debugfs code depends on gpadc
>   iwlegacy: il_pm_ops is only provided for PM_SLEEP
>   thermal: cpu_cooling: fix stub function
>   staging/logger: use kuid_t internally
>   oprofile: always enable IRQ_WORK
>   USB: EHCI: remove bogus #error
>   USB: UHCI: clarify Kconfig dependencies
>   USB: OHCI: clarify Kconfig dependencies
>   Xen: SWIOTLB is only used on x86
>   staging/solo6x10: depend on CONFIG_FONTS
>   media: coda: select GENERIC_ALLOCATOR
>   davinci: vpfe_capture needs i2c
>   radio-si4713: depend on SND_SOC
> 
>  arch/Kconfig                           |  1 +
>  crypto/Kconfig                         |  2 ++
>  drivers/cpufreq/Kconfig.arm            |  1 +
>  drivers/cpuidle/Kconfig                |  1 +
>  drivers/gpu/drm/tilcdc/Kconfig         |  1 +
>  drivers/gpu/host1x/drm/Kconfig         |  1 +
>  drivers/media/platform/Kconfig         |  1 +
>  drivers/media/platform/davinci/Kconfig |  3 ++
>  drivers/media/radio/Kconfig            |  1 +
>  drivers/mfd/Kconfig                    |  2 +-
>  drivers/net/can/Kconfig                |  6 ++--
>  drivers/net/wireless/iwlegacy/common.h |  2 +-
>  drivers/staging/android/logger.c       |  4 +--
>  drivers/staging/android/logger.h       |  2 +-
>  drivers/staging/imx-drm/Kconfig        |  4 +++
>  drivers/staging/media/solo6x10/Kconfig |  1 +
>  drivers/usb/host/Kconfig               | 65 +++++++++++++++++++++++++++++-----
>  drivers/usb/host/Makefile              |  4 +--
>  drivers/usb/host/ehci-hcd.c            | 17 ---------
>  drivers/usb/host/ohci-hcd.c            | 19 ----------
>  drivers/usb/host/uhci-hcd.c            |  4 +--
>  drivers/video/console/Makefile         |  2 ++
>  drivers/video/omap2/dss/Kconfig        |  1 +
>  drivers/xen/Kconfig                    |  2 +-
>  include/drm/drmP.h                     |  3 +-
>  include/linux/cpu_cooling.h            |  2 +-
>  26 files changed, 91 insertions(+), 61 deletions(-)
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
