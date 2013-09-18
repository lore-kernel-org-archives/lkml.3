Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3IRUsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:48:12 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42079 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3IRUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:48:09 -0400
MIME-Version: 1.0
X-Originating-IP: [64.196.191.133]
In-Reply-To: <523A046E.6040804@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130918194711.GR19937@titan.lakedaemon.net>
	<523A046E.6040804@gmail.com>
Date: Wed, 18 Sep 2013 13:48:08 -0700
Message-ID: <CAOesGMguF33+-mXScLmUy1Kr9JkL36Ah1_ShW_ZuGy4Q0gJefg@mail.gmail.com>
Subject: Re: [PATCH 00/26] ARM: provide common arch init for DT clocks
From: Olof Johansson <olof@lixom.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-rpi-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 12:52 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 09/18/2013 09:47 PM, Jason Cooper wrote:
>>
>> On Wed, Sep 18, 2013 at 07:53:33PM +0200, Sebastian Hesselbarth wrote:
>> ...
>>>
>>> Sebastian Hesselbarth (26):
>>>    ARM: nomadik: move mtu setup to clocksource init
>>>    clk: nomadik: move src init out of nomadik_clk_init
>>>    clk: nomadik: declare OF clock provider
>>>    clk: prima2: declare OF clock provider
>>>    ARM: socfgpa: prepare for arch-wide .init_time callback
>>>    clk: sunxi: declare OF clock provider
>>>    clk: vt8500: parse pmc_base from clock driver
>>>    ARM: vt8500: prepare for arch-wide .init_time callback
>>>    ARM: call of_clk_init from default time_init handler
>>>    ARM: bcm2835: remove custom .init_time hook
>>>    ARM: dove: remove custom .init_time hook
>>>    ARM: exynos: remove custom .init_time hook
>>>    ARM: highbank: remove custom .init_time hook
>>>    ARM: imx: remove custom .init_time hook
>>>    ARM: kirkwood: remove custom .init_time hook
>>>    ARM: mxs: remove custom .init_time hook
>>>    ARM: nomadik: remove custom .init_time hook
>>>    ARM: nspire: remove custom .init_time hook
>>>    ARM: prima2: remove custom .init_time hook
>>>    ARM: rockchip: remove custom .init_time hook
>>>    ARM: socfpga: remove custom .init_time hook
>>>    ARM: sti: remove custom .init_time hook
>>>    ARM: sunxi: remove custom .init_time hook
>>>    ARM: tegra: remove custom .init_time hook
>>>    ARM: vexpress: remove custom .init_time hook
>>>    ARM: vt8500: remove custom .init_time hook
>>>
>>>   arch/arm/kernel/time.c                    |   27 ++---
>>>   arch/arm/mach-bcm2835/bcm2835.c           |    2 -
>>>   arch/arm/mach-dove/board-dt.c             |   11 --
>>>   arch/arm/mach-exynos/common.c             |    8 --
>>>   arch/arm/mach-exynos/common.h             |    1 -
>>>   arch/arm/mach-exynos/mach-exynos4-dt.c    |    2 -
>>>   arch/arm/mach-exynos/mach-exynos5-dt.c    |    2 -
>>>   arch/arm/mach-highbank/highbank.c         |   23 ++---
>>>   arch/arm/mach-imx/clk-imx51-imx53.c       |   29 ++----
>>>   arch/arm/mach-imx/common.h                |    4 -
>>>   arch/arm/mach-imx/imx51-dt.c              |    6 --
>>>   arch/arm/mach-imx/mach-imx53.c            |    6 --
>>>   arch/arm/mach-imx/mach-imx6q.c            |   14 +--
>>>   arch/arm/mach-imx/mach-imx6sl.c           |    7 --
>>>   arch/arm/mach-imx/mach-vf610.c            |    9 --
>>>   arch/arm/mach-kirkwood/board-dt.c         |    8 --
>>>   arch/arm/mach-mxs/mach-mxs.c              |   13 ---
>>>   arch/arm/mach-nomadik/cpu-8815.c          |   36 -------
>>>   arch/arm/mach-nspire/nspire.c             |    9 --
>>>   arch/arm/mach-prima2/common.c             |   11 --
>>>   arch/arm/mach-prima2/common.h             |    1 -
>>>   arch/arm/mach-rockchip/rockchip.c         |    9 --
>>>   arch/arm/mach-socfpga/socfpga.c           |    2 -
>>>   arch/arm/mach-sti/board-dt.c              |   10 +-
>>>   arch/arm/mach-sunxi/sunxi.c               |   10 --
>>>   arch/arm/mach-tegra/tegra.c               |    9 --
>>>   arch/arm/mach-vexpress/v2m.c              |   14 +--
>>>   arch/arm/mach-vt8500/common.h             |   24 -----
>>>   arch/arm/mach-vt8500/vt8500.c             |    6 --
>>>   drivers/clk/clk-bcm2835.c                 |    8 --
>>>   drivers/clk/clk-highbank.c                |   10 +-
>>>   drivers/clk/clk-nomadik.c                 |  161
>>> ++++++++++++++---------------
>>>   drivers/clk/clk-prima2.c                  |   29 ++----
>>>   drivers/clk/clk-vt8500.c                  |   31 ++++--
>>>   drivers/clk/mxs/clk-imx23.c               |   15 +--
>>>   drivers/clk/mxs/clk-imx28.c               |   16 +--
>>>   drivers/clk/sunxi/clk-sunxi.c             |   11 +-
>>>   drivers/clocksource/nomadik-mtu.c         |   11 ++
>>>   include/linux/clk/mxs.h                   |    2 -
>>>   include/linux/clk/sunxi.h                 |   22 ----
>>>   include/linux/platform_data/clk-nomadik.h |    2 -
>>>   41 files changed, 182 insertions(+), 449 deletions(-)
>>>   delete mode 100644 arch/arm/mach-vt8500/common.h
>>>   delete mode 100644 include/linux/clk/sunxi.h
>>>   delete mode 100644 include/linux/platform_data/clk-nomadik.h
>>
>>
>> How would you like to handle this series?
>
>
> Jason,
>
> honestly I don't really know, yet. I was hoping for Arnd and Olof
> decide on that. Maybe they also create a topic branch up to where
> arch-wide of_clk_init is introduced. Then each removal patch can
> go through the independent sub-trees. There may be more machs
> introduced before, that can then also depend on the common branch.

I'd like to see this merged early into arm-soc and have it as a base
branch for other platform branches if there will be much conflicts
(for trivial or small conflicts we can resolve, of course). So please
collect acks and prepare a branch for me to merge, Sebastian. Or if
it's easier I can just apply the patches directly -- just let me know.
But given the tegra dependency it's probably easier to take a branch.

The long tail might be the cases where you rewrote some of the init
code, since that'll need to be tested on those platforms. I wonder if
we can pick up most of the other pieces if that ends up taking a
while.


-Olof
