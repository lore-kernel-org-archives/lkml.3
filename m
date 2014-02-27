Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaB0VqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:46:03 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54626 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbaB0VqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:46:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KH75z1CM+MIpuwTh0K4dmLYG9mAfyPfk=
X-DKIM: OpenDKIM Filter v2.0.1 titan E67C0535CB7
Date: Thu, 27 Feb 2014 16:45:43 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: dove: move Dove DT to MVEBU
Message-ID: <20140227214543.GK1872@titan.lakedaemon.net>
References: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:28:01PM +0100, Sebastian Hesselbarth wrote:
> Thanks to DT conversion effort, Marvell Dove with DT support is now
> ready to leave mach-dove and hop into mach-mvebu. As discussed with
> MVEBU maintainers, we first add dove.c now and keep on migrating
> it with Armada 3xx SoCs the next cycle.
> 
> Patch 1 adds a DT node for the system controller found on Marvell
> MVEBU SoCs.
> 
> Patch 2 copies an approach taken by Andrew Lunn for Kirkwood-to-MVEBU
> patches, that add MACH_DOVE for Dove in mach-mvebu to distinguish it
> from ARCH_DOVE in mach-dove, where drivers still support both non-DT
> and DT.
> 
> Patch 3 then moves mach-dove/board-dt.c to mach-mvebu/dove.c with
> minor cleanups and converts drivers/phy/Kconfig to MACH_DOVE for
> a DT-only driver.
> 
> Patch 4 finally adds MACH_DOVE and some of its drivers to multi_v7
> defconfig.
> 
> The patches are based on v3.14-rc4, recently posted mvebu/pinctrl-cleanup
> and mvebu/pinctrl-dove branches: v3.14-rc4 is required for a irqchip
> driver fix when SPARSE_IRQ is set, the pinctrl branches remove hard-coded
> addresses from Dove's pinctrl driver.

If I were to base this series on v3.14-rc1, I would need to pull in

  mvebu/pinctrl-dove (which draws in mvebu/pinctrl-cleanup)
  mvebu/irqchip-fixes

and that should be all.  iiuc, these are boot-time requirements, not
build or merge requirements, correct?

thx,

Jason.

> An unstable branch with above dependencies met, is available at
> 
> https://github.com/shesselba/linux-dove.git unstable/dove-mvebu-for-3.15_v1
> 
> Sebastian Hesselbarth (4):
>   ARM: dove: add system controller node
>   ARM: dove: prepare new Dove DT Kconfig variable
>   ARM: mvebu: move DT Dove to MVEBU
>   ARM: add Marvell Dove and some drivers to multi_v7 defconfig
> 
>  arch/arm/boot/dts/Makefile                           | 12 ++++++------
>  arch/arm/boot/dts/dove.dtsi                          |  5 +++++
>  arch/arm/configs/multi_v7_defconfig                  |  4 ++++
>  arch/arm/mach-dove/Kconfig                           | 12 ------------
>  arch/arm/mach-dove/Makefile                          |  1 -
>  arch/arm/mach-mvebu/Kconfig                          | 12 ++++++++++++
>  arch/arm/mach-mvebu/Makefile                         |  1 +
>  arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} | 20 ++++++++------------
>  drivers/mmc/host/Kconfig                             |  2 +-
>  drivers/phy/Kconfig                                  |  2 +-
>  drivers/thermal/Kconfig                              |  2 +-
>  drivers/watchdog/Kconfig                             |  2 +-
>  sound/soc/kirkwood/Kconfig                           |  2 +-
>  13 files changed, 41 insertions(+), 36 deletions(-)
>  rename arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} (61%)
> 
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> -- 
> 1.8.5.3
> 
