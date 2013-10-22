Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3JVOIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:08:48 -0400
Received: from gloria.sntech.de ([95.129.55.99]:36255 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3JVOIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:08:47 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 0/5] ARM: rockchip: add smp functionality
Date: Tue, 22 Oct 2013 16:08:44 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>,
        Matt Sealey <neko@bakuhatsu.net>, Fabio Estevam <festevam@gmail.com>,
        Kevin Hilman <khilman@linaro.org>
References: <201310221600.13562.heiko@sntech.de>
In-Reply-To: <201310221600.13562.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201310221608.45192.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gaah, there I just learned about the arm@kernel.org address and still didn't 
remember when digging up this old recipient list - which of course resulted in 
Kevin not being included.

Additionally I also had the old devicetree list included.

So I'll do it again shortly :-)


Sorry for the noise
Heiko

Am Dienstag, 22. Oktober 2013, 16:00:13 schrieb Heiko Stübner:
> This series enables the use of the additional cores on Rockchip
> Cortex-A9 SoCs.
> 
> To achieve this, add the scu, the needed sram and power-management-unit.
> 
> Tested on both a BQ Curie2 (rk3066a / dual core) and
> on a Radxa Rock (rk3188 / quad core).
> 
> changes since v4:
> - rebase on top of the recent rk3188 board support
> - implement suggestion from Matt Sealey in moving the sram-limit from
>   marking reserved regions to marking available regions - hopefully
>   I got the usage right :-)
> - remove __CPUINIT as suggested by Fabio Estevam
> 
> changes since v3:
> - address comments from Rob Herring:
>   - split the gathering of the reserve-data into a separate loop
>   - spelling and style fixes
> - first patch only included for reference, already part of the
>   char-misc git tree
> 
> changes since v2:
> - rework the sram allocation following the suggestion from Philipp Zabel
> 
> changes since v1:
> - add reserved block feature for mmio-sram, to not use two logical
>   sram nodes
> - the sram content is kept intact while the device is running, so
>   copying the trampoline is only needed once
> 
> Heiko Stuebner (5):
>   misc: sram: add ability to limit used sram areas
>   ARM: rockchip: add snoop-control-unit
>   ARM: rockchip: add sram dt nodes and documentation
>   ARM: rockchip: add power-management-unit dt node
>   ARM: rockchip: add smp bringup code
> 
>  .../devicetree/bindings/arm/rockchip/pmu.txt       |   16 ++
>  .../devicetree/bindings/arm/rockchip/smp-sram.txt  |   24 +++
>  Documentation/devicetree/bindings/misc/sram.txt    |    8 +
>  arch/arm/boot/dts/rk3066a.dtsi                     |    6 +
>  arch/arm/boot/dts/rk3188.dtsi                      |    6 +
>  arch/arm/boot/dts/rk3xxx.dtsi                      |   10 +
>  arch/arm/mach-rockchip/Kconfig                     |    1 +
>  arch/arm/mach-rockchip/Makefile                    |    1 +
>  arch/arm/mach-rockchip/core.h                      |   22 +++
>  arch/arm/mach-rockchip/headsmp.S                   |   30 ++++
>  arch/arm/mach-rockchip/platsmp.c                   |  195
> ++++++++++++++++++++ arch/arm/mach-rockchip/rockchip.c                  | 
>   2 +
>  drivers/misc/sram.c                                |   51 ++++-
>  13 files changed, 368 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu.txt
>  create mode 100644
> Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt create mode
> 100644 arch/arm/mach-rockchip/core.h
>  create mode 100644 arch/arm/mach-rockchip/headsmp.S
>  create mode 100644 arch/arm/mach-rockchip/platsmp.c

