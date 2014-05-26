Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaEZDXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:23:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26989 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaEZDXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:23:46 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-9c-5382b3bead3d
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
Subject: [PATCH v11 0/3] Exynos 5410 support
Date: Mon, 26 May 2014 07:23:30 +0400
Message-id: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xq7r7NjcFG7z8Kmoxad0BJouH62+y
	WMw/co7Vov/NQlaL/49es1qce7WS0aJ3wVU2i7NNb9gtNj2+xmqxsG0Ji8XlXXPYLGac38dk
	cfsyr8XS6xeZLJ5OuMhmMWH6WhaLdS+ns1i07j3CbrHlZwejxe+eT8wW65+fYrRYP+M1i8Wx
	GUsYLabO+MHuIOGxZt4aRo+W5h42j8t9vUwef1e9YPbYOesuu8fK5V/YPDat6mTzeLV6JqvH
	nWt72Dw2L6n3eHWNxaNvyypGj+3X5jF7fN4kF8AXxWWTkpqTWZZapG+XwJUxr0mzYBdfxam7
	GxkbGDu4uxg5OSQETCSu3rnGBGGLSVy4t56ti5GLQ0hgKaPEkhkPWSGcDiaJ15uWMHcxcnCw
	CWhLbNnhBdIgIqAgsbn3GVgNs8AnNokfq5rAJgkL6Eg8WNrGCmKzCKhKTL5/lh3E5hVwlfhy
	7jMTyBwJoOY5k2wmMHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESIV93MC49ZnWI
	UYCDUYmH90VeU7AQa2JZcWXuIUYJDmYlEd4LuUAh3pTEyqrUovz4otKc1OJDjEwcnFINjCoT
	pXOuinK/1f7hMc0tMj9U4rZI//fzf0517GZNZDLR+ZKzt3G73eWM4J1/Wydqi/bkvnK5+Oq7
	gl3E7cCHm8+uO7aC+1q1PpvjEzGe+2UC0mwCbF7vF9ypeVDmUvdkDpPArLNW7y5oOPTdPnC7
	fGF6rUJ/0qGlLJpetR//mffbTXV70bTvtBJLcUaioRZzUXEiAExG7hxuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture

Patches add new platform description, support of clock controller and device
tree for Exynos 5410.

Has been build on Samsung Linux Kernel
  (branch: for-next, commit: 97eae6c Merge branch 'v3.16-next/multiplatform' into for-next)

Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
		    2) Exynos 5410 reference board (multi_v7_defconfig)
		    3) Odroid-XU board (exynos_defconfig)
		    4) Odroid-XU board (multi_v7_defconfig)

I hope this is clean and would be applied.

Tarek.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |   45 +++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   82 ++++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  206 +++++++++++++++++++
 arch/arm/mach-exynos/Kconfig                       |    5 +
 arch/arm/mach-exynos/common.h                      |   12 +-
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |   33 ++++
 9 files changed, 592 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.7.9.5

