Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaIXUIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:08:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61607 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750871AbaIXUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:08:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Ben Skeggs <bskeggs@redhat.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Chris Ball <chris@printf.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, "Du, Wenkai" <wenkai.du@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>, intel-gfx@lists.freedesktop.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Jani Nikula <jani.nikula@intel.com>, Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        patches@opensource.wolfsonmicro.com,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Clark <robdclark@gmail.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Thierry Reding <treding@nvidia.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 00/27] add pm_runtime_last_busy_and_autosuspend() helper
Date: Wed, 24 Sep 2014 22:28:07 +0200
Message-ID: <6374313.I12loOK9hA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2014 09:44:50 PM Vinod Koul wrote:
> This patch series adds a simple macro pm_runtime_last_busy_and_autosuspend()
> which invokes pm_runtime_mark_last_busy() and pm_runtime_put_autosuspend()
> sequentially. Then we do a tree wide update of current patterns which are
> present. As evident from log below this pattern is frequent in the
> kernel.
> 
> This series can be found at
> git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/slave-dma.git
> topic/pm_runtime_last_busy_and_autosuspend
> 
> Fengguang's kbuild has tested it so it shouldn't break things for anyone.
> Barring one patch (explictyly mentioned in its changelog) rest are simple
> replacements.
> 
> If all are okay, this should be merged thru PM tree as it depends on macro
> addition.
> 
> Subhransu S. Prusty (1):
>   PM: Add helper pm_runtime_last_busy_and_autosuspend()
> 
> Vinod Koul (26):
>   dmaengine: ste_dma: use pm_runtime_last_busy_and_autosuspend helper
>   extcon: arizona: use pm_runtime_last_busy_and_autosuspend helper
>   drm/i915: use pm_runtime_last_busy_and_autosuspend helper
>   drm/nouveau: use pm_runtime_last_busy_and_autosuspend helper
>   drm/radeon: use pm_runtime_last_busy_and_autosuspend helper
>   vga_switcheroo: use pm_runtime_last_busy_and_autosuspend helper
>   i2c: designware: use pm_runtime_last_busy_and_autosuspend helper
>   i2c: omap: use pm_runtime_last_busy_and_autosuspend helper
>   i2c: qup: use pm_runtime_last_busy_and_autosuspend helper
>   mfd: ab8500-gpadc: use pm_runtime_last_busy_and_autosuspend helper
>   mfd: arizona: use pm_runtime_last_busy_and_autosuspend helper
>   mei: use pm_runtime_last_busy_and_autosuspend helper
>   mmc: use pm_runtime_last_busy_and_autosuspend helper
>   mmc: mmci: use pm_runtime_last_busy_and_autosuspend helper
>   mmc: omap_hsmmc: use pm_runtime_last_busy_and_autosuspend helper
>   mmc: sdhci-pxav3: use pm_runtime_last_busy_and_autosuspend helper
>   mmc: sdhci: use pm_runtime_last_busy_and_autosuspend helper
>   NFC: trf7970a: use pm_runtime_last_busy_and_autosuspend helper
>   pm2301-charger: use pm_runtime_last_busy_and_autosuspend helper
>   spi: omap2-mcspi: use pm_runtime_last_busy_and_autosuspend helper
>   spi: orion: use pm_runtime_last_busy_and_autosuspend helper
>   spi: ti-qspi: use pm_runtime_last_busy_and_autosuspend helper
>   spi: core: use pm_runtime_last_busy_and_autosuspend helper
>   tty: serial: omap: use pm_runtime_last_busy_and_autosuspend helper
>   usb: musb: omap2430: use pm_runtime_last_busy_and_autosuspend helper
>   video: fbdev: use pm_runtime_last_busy_and_autosuspend helper
> 
>  Documentation/power/runtime_pm.txt          |    4 ++
>  drivers/dma/ste_dma40.c                     |   30 ++++---------
>  drivers/extcon/extcon-arizona.c             |    6 +--
>  drivers/gpu/drm/i915/intel_pm.c             |    3 +-
>  drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c       |    9 +---
>  drivers/gpu/drm/radeon/radeon_connectors.c  |   15 ++----
>  drivers/gpu/drm/radeon/radeon_drv.c         |    5 +-
>  drivers/gpu/drm/radeon/radeon_kms.c         |    6 +--
>  drivers/gpu/vga/vga_switcheroo.c            |    7 +--
>  drivers/i2c/busses/i2c-designware-core.c    |    3 +-
>  drivers/i2c/busses/i2c-omap.c               |    6 +--
>  drivers/i2c/busses/i2c-qup.c                |    3 +-
>  drivers/mfd/ab8500-gpadc.c                  |    6 +--
>  drivers/mfd/arizona-irq.c                   |    3 +-
>  drivers/misc/mei/client.c                   |   12 ++----
>  drivers/mmc/core/core.c                     |    3 +-
>  drivers/mmc/host/mmci.c                     |   12 ++----
>  drivers/mmc/host/omap_hsmmc.c               |   19 ++-------
>  drivers/mmc/host/sdhci-pxav3.c              |    6 +--
>  drivers/mmc/host/sdhci.c                    |    3 +-
>  drivers/nfc/trf7970a.c                      |    3 +-
>  drivers/power/pm2301_charger.c              |    3 +-
>  drivers/spi/spi-omap2-mcspi.c               |    9 +---
>  drivers/spi/spi-orion.c                     |    3 +-
>  drivers/spi/spi-ti-qspi.c                   |    5 +-
>  drivers/spi/spi.c                           |    6 +--
>  drivers/tty/serial/omap-serial.c            |   60 +++++++++------------------
>  drivers/usb/musb/omap2430.c                 |    6 +--
>  drivers/video/fbdev/auo_k190x.c             |    9 +---
>  include/linux/pm_runtime.h                  |    6 +++
>  31 files changed, 97 insertions(+), 177 deletions(-)

OK, I guess this is as good as it gets.

What tree would you like it go through?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
