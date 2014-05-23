Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaEWKgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:36:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33169 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaEWKgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:36:04 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-8b-537f2489f7b1
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
Subject: [PATCH v10 0/3] Exynos 5410 support
Date: Fri, 23 May 2014 14:35:40 +0400
Message-id: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xy7qdKvXBBn+2sllMWneAyeLh+pss
	FvOPnGO16H+zkNXi/6PXrBbnXq1ktOhdcJXN4mzTG3aLTY+vsVosbFvCYnF51xw2ixnn9zFZ
	3L7Ma7H0+kUmi6cTLrJZTJi+lsVi3cvpLBate4+wW2z52cFo8bvnE7PF+uenGC3Wz3jNYnFs
	xhJGi6kzfrA7SHismbeG0aOluYfN43JfL5PH31UvmD12zrrL7rFy+Rc2j02rOtk8Xq2eyepx
	59oeNo/NS+o9Xl1j8ejbsorRY/u1ecwenzfJBfBFcdmkpOZklqUW6dslcGU82DuBpaCHr+Jo
	m3AD4y2uLkZODgkBE4nOxueMELaYxIV769m6GLk4hASWMkp8/vSXEcLpYJKYMq2VpYuRg4NN
	QFtiyw4vkAYRAQWJzb3PWEFqmAU+sUn8WNXEBJIQFtCRWHPlCxuIzSKgKvFuVhdYnFfAReLd
	sWuMIHMkgJrnTLKZwMi9gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIhHzZwbj4mNUh
	RgEORiUe3h2ldcFCrIllxZW5hxglOJiVRHjPyNYHC/GmJFZWpRblxxeV5qQWH2Jk4uCUamD0
	jEhJVd6zaUeMR06e6za9j3LPbhbqT9yqEJSg8TtdLTs05Om9LLEJzYW2/5d9K7E6WyYqN7NM
	NLpq6td7n/Y55S8+cbshTq7dpjUx6MVcpxkdtw4q9AbsLPPeyFXwzuBCXGmQkqe7AfdPQevX
	CWIed4ueSe1OtC14X+I4lXn+57VfeX9nHVRiKc5INNRiLipOBAB/7pe1bgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches represent support of Exynos 5410 SoC

The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture

Patches add new platform description, support of clock controller and device
tree for Exynos 5410.

Has been build on Samsung Linux Kernel
  (branch: for-next, commit: 19307a0 Merge branch 'v3.16-next/dt-samsung-2' into for-next)
Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
		    2) Odroid-XU board (exynos_defconfig)

Many thanks for reviewing to Tomasz Figa.

Tarek.

Tarek Dakhran (3):
  ARM: EXYNOS: Add support for EXYNOS5410 SoC
  clk: exynos5410: register clocks using common clock framework
  ARM: dts: Add initial device tree support for EXYNOS5410

 .../devicetree/bindings/clock/exynos5410-clock.txt |   51 +++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   82 ++++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  206 +++++++++++++++++++
 arch/arm/mach-exynos/Kconfig                       |    8 +
 arch/arm/mach-exynos/common.h                      |   11 +-
 arch/arm/mach-exynos/firmware.c                    |    2 +-
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5410.h             |   33 ++++
 10 files changed, 602 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
 create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
 create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
 create mode 100644 drivers/clk/samsung/clk-exynos5410.c
 create mode 100644 include/dt-bindings/clock/exynos5410.h

-- 
1.7.9.5

