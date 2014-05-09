Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaEINB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:01:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46788 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaEINBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:01:54 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: mturquette@linaro.org, t.figa@samsung.com, kgene.kim@samsung.com,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org
Subject: [PATCH 0/4] Add framework to support clkout
Date: Fri,  9 May 2014 18:30:06 +0530
Message-Id: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MUX/GATE register for XCLKOUT doesn't resides within PMU domain,
this can be accessed through a regmap provided by syscon driver. Adding
another clock provider to handle regmap based handing of XCLKOUT.

Dependency:
1. [PATCH v3] mfd: syscon: Support early initialization
http://article.gmane.org/gmane.linux.kernel/1679446

Also we need to find a suitable place to call early_syscon_init(), after
the device tree has been unflattened and before clock initialization.

While testing, I called this before of_clk_init() in arch/arm/kernel/time.c,
but that place is too generic. Calling anywhere from exynos.c is not
working ATM.

Tushar Behera (4):
  clk: samsung: out: Add infrastructure to register CLKOUT
  clk: samsung: exynos5420: Add xclkout debug clock
  clk: samsung: exynos5250: Add xclkout debug clock
  ARM: dts: Add pmu-syscon handle for Exynos5420/Exynos5250 clock

 arch/arm/boot/dts/exynos5250.dtsi      |    1 +
 arch/arm/boot/dts/exynos5420.dtsi      |    1 +
 drivers/clk/samsung/Makefile           |    2 +-
 drivers/clk/samsung/clk-exynos5250.c   |   14 +++
 drivers/clk/samsung/clk-exynos5420.c   |   14 +++
 drivers/clk/samsung/clk-out.c          |  181 ++++++++++++++++++++++++++++++++
 drivers/clk/samsung/clk.h              |   33 ++++++
 include/dt-bindings/clock/exynos5250.h |    3 +
 include/dt-bindings/clock/exynos5420.h |    5 +-
 9 files changed, 252 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/samsung/clk-out.c

-- 
1.7.9.5

