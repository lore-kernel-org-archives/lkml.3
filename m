Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaBJKLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:11:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34718 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaBJKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:11:08 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ef-52f8a5b85452
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v6 0/3] Exynos 5410 support
Date: Mon, 10 Feb 2014 19:08:28 +0900
Message-id: <1392026911-21308-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xK7o7lv4IMrjaa2Axad0BJouH62+y
	WMw/co7Vov/NQlaL/49es1qce7WS0aJ3wVU2i7NNb9gtNj2+xmqxsG0Ji8XlXXPYLGac38dk
	cfsyr8XS6xeZLJ5OuMhmMWH6WhaLdS+ns1i07j3CbrHlZwejxe+eT8wW65+fYrRYP+M1i8Wx
	GUsYLabO+MHuIOGxZt4aRo+W5h42j8t9vUwef1e9YPbYOesuu8fK5V/YPDat6mTzeLV6JqvH
	nWt72Dw2L6n3eHWNxaNvyypGj+3X5jF7fN4kF8AXxWWTkpqTWZZapG+XwJXx4EwjS8EJoYol
	O6+xNTD+4O1i5OSQEDCR6NkyhQXCFpO4cG89WxcjF4eQwFJGiaa3PxhBEkICvUwS16eYdjFy
	cLAJaEts2eEFEhYRUJDY3PuMFaSeWeATm8SPVU1MIAlhoJoFx56BDWURUJV4+vk0K0gvr4Cr
	xPaVWRC7FCW6n01gm8DIvYCRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSIR82cG4+JjV
	IUYBDkYlHt6df74HCbEmlhVX5h5ilOBgVhLhnTvvR5AQb0piZVVqUX58UWlOavEhRiYOTqkG
	Rj2GiQ+tVz+4cizu+8aWvY+85ZTMLsp9XL0lq3L54nzdB6eUuzZPNmpWC9dltDc7P/PHuRNG
	a8v/bGnybmnv6fA/Yvjo3mu1x8+jtx/erRAcc22e7vNpPM89Xzcf4Z+apRcxR9b6Xt2udQc9
	mR4yXLMXs50rq9ydftfkPvvf0pbgaybbDn7b9UOJpTgj0VCLuag4EQB5IYGjbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture

Patches add new platform description, support of clock controller and device 
tree for Exynos 5410.

Dual cluster support for Exynos 5410 (EDCS) has been removed from this series 
This patches is activating only the big cluster (2xA15 cores)

EDCS patch, which allows all 8 CPU cores (4 x A7 and 4 x A15) 
to run at the same time, will be released separately

Has been build on v3.14-rc1
Has been tested on Exynos 5410 reference board (exynos_defconfig)

Thanks for all your comments to Tomasz Figa, Dave Martin and Nicolas Pitre.
I hope, this is enough clean and hasn't any dependencies to go through 
Samsung tree.

Tarek.


Changelog:

v6:
	small changes in Makefiles for resolving conflicts related to changes in 
	Samsung tree.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |   54 +++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   72 ++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  140 ++++++++++++
 arch/arm/mach-exynos/Kconfig                       |   10 +
 arch/arm/mach-exynos/common.c                      |   18 ++
 arch/arm/mach-exynos/include/mach/map.h            |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    1 +
 arch/arm/mach-exynos/platsmp.c                     |    2 +
 arch/arm/plat-samsung/include/plat/cpu.h           |    8 +
 arch/arm/plat-samsung/include/plat/map-s5p.h       |    3 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5410.c               |  239 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |   32 +++
 14 files changed, 582 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.7.10.4

