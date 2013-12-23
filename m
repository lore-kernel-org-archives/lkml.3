Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3LWSSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 13:18:47 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37425 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3LWSSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:18:46 -0500
MIME-Version: 1.0
In-Reply-To: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org>
Date: Mon, 23 Dec 2013 20:18:44 +0200
Message-ID: <CAArO44vC4WKGHSqHX3+Mo5+jcNuyJLkh94+SPd4H+aZYAroYzw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ARM: OMAP: raw read and write endian fix
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2013 20:10, Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
> This series does trivial replacement of __raw_xxx functions with xxx_relaxed
> endian-neutral variants in 'mach-omap2' and 'plat-omap' directories.
> Some code here most probably won't be used in BE mode (like debug-leds for
> OMAP1 boards), but changes are made anyway to remove __raw_xxx() functions
> completely and simplify future grep'ing for new __raw_xxx() entries.
>
> This is a part of RFC series [1].
> Based on v3.13-rc5.
>
> [1] http://www.spinics.net/lists/linux-omap/msg99927.html
>
> Victor Kamensky (4):
>   ARM: OMAP2+: raw read and write endian fix
>   ARM: OMAP: dmtimer: raw read and write endian fix
>   ARM: OMAP: counter-32k: raw read and write endian fix
>   ARM: OMAP: debug-leds: raw read and write endian fix
>
>  arch/arm/mach-omap2/board-flash.c         |    4 +--
>  arch/arm/mach-omap2/clkt2xxx_dpllcore.c   |    2 +-
>  arch/arm/mach-omap2/clkt2xxx_osc.c        |    8 +++---
>  arch/arm/mach-omap2/clkt2xxx_sys.c        |    2 +-
>  arch/arm/mach-omap2/clkt_clksel.c         |   10 +++----
>  arch/arm/mach-omap2/clkt_dpll.c           |    6 ++---
>  arch/arm/mach-omap2/clkt_iclk.c           |    8 +++---
>  arch/arm/mach-omap2/clock.c               |   16 +++++------
>  arch/arm/mach-omap2/clock36xx.c           |    6 ++---
>  arch/arm/mach-omap2/cm2xxx_3xxx.h         |    4 +--
>  arch/arm/mach-omap2/cm33xx.c              |    4 +--
>  arch/arm/mach-omap2/cm3xxx.c              |    8 +++---
>  arch/arm/mach-omap2/cm44xx.c              |    8 +++---
>  arch/arm/mach-omap2/cminst44xx.c          |    4 +--
>  arch/arm/mach-omap2/control.c             |   20 +++++++-------
>  arch/arm/mach-omap2/dma.c                 |    4 +--
>  arch/arm/mach-omap2/dpll3xxx.c            |   32 +++++++++++-----------
>  arch/arm/mach-omap2/dpll44xx.c            |   12 ++++-----
>  arch/arm/mach-omap2/gpmc.c                |    8 +++---
>  arch/arm/mach-omap2/id.c                  |    2 +-
>  arch/arm/mach-omap2/irq.c                 |    4 +--
>  arch/arm/mach-omap2/mux.c                 |    8 +++---
>  arch/arm/mach-omap2/omap-hotplug.c        |    4 +--
>  arch/arm/mach-omap2/omap-mpuss-lowpower.c |   18 ++++++-------
>  arch/arm/mach-omap2/omap-smp.c            |    4 +--
>  arch/arm/mach-omap2/omap-wakeupgen.c      |   42 ++++++++++++++---------------
>  arch/arm/mach-omap2/omap4-common.c        |   16 +++++------
>  arch/arm/mach-omap2/omap_hwmod.c          |   10 +++----
>  arch/arm/mach-omap2/omap_phy_internal.c   |    6 ++---
>  arch/arm/mach-omap2/prcm_mpu44xx.c        |    4 +--
>  arch/arm/mach-omap2/prm2xxx.h             |    2 +-
>  arch/arm/mach-omap2/prm2xxx_3xxx.h        |    4 +--
>  arch/arm/mach-omap2/prm33xx.c             |    4 +--
>  arch/arm/mach-omap2/prm3xxx.h             |    2 +-
>  arch/arm/mach-omap2/prm44xx.c             |    4 +--
>  arch/arm/mach-omap2/prminst44xx.c         |    4 +--
>  arch/arm/mach-omap2/sdrc.h                |    8 +++---
>  arch/arm/mach-omap2/sdrc2xxx.c            |    4 +--
>  arch/arm/mach-omap2/sr_device.c           |    2 +-
>  arch/arm/mach-omap2/sram.c                |   16 +++++------
>  arch/arm/mach-omap2/timer.c               |    8 +++---
>  arch/arm/mach-omap2/vc.c                  |    4 +--
>  arch/arm/mach-omap2/wd_timer.c            |    8 +++---
>  arch/arm/plat-omap/counter_32k.c          |    6 ++---
>  arch/arm/plat-omap/debug-leds.c           |   14 +++++-----
>  arch/arm/plat-omap/dmtimer.c              |    8 +++---
>  arch/arm/plat-omap/include/plat/dmtimer.h |   16 +++++------
>  47 files changed, 199 insertions(+), 199 deletions(-)
>
> --
> 1.7.9.5
>

+lists

-- 
Regards,
Taras Kondratiuk
