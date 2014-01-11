Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaAKTrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:47:32 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40221 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaAKTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:13 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH RFC 00/10] Generic Device Tree based power domain look-up
Date: Sat, 11 Jan 2014 20:42:42 +0100
Message-Id: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till now there was no single generic method to bind devices to their
power domains using Device Tree. Each platform has been doing this using
its own way, example of which are Exynos power domain bindings [1] and
look-up code [2].

This series is intended to change this and provide generic DT bindings for
power domain specification and generic code performing look-up of power
domains and binding them to devices.

Patches 1, 2, 3 are not directly related to this series, but they are
dependencies of further patches making mach-s3c64xx a user of introduced
code. Patch 4 is the most important part of this series, as it's the one
introducing $subject. Further patches are fixing and adding two users,
mach-exynos (removing the legacy code) and mach-s3c64xx (no DT support for
power domains before). Last two patches are adding display support for
Mini6410 board, including a node for display controller (FIMD) which is
a power domain consumer.

Successfully tested on S3C6410-based Mini6410 board.

Tomasz Figa (10):
  ARM: s3c64xx: pm: Use name field of generic_pm_domain
  ARM: s3c64xx: pm: Add always_on field to s3c64xx_pm_domain struct
  ARM: s3c64xx: pm: Add pwr_stat bit for domain G
  base: power: Add generic OF-based power domain look-up
  ARM: exynos: Move to generic power domain bindings
  ARM: s3c64xx: pm: Add device tree based power domain instantiation
  ARM: s3c64xx: dt: Enable SoC-level power management
  ARM: dts: s3c64xx: Add nodes for power domains
  ARM: dts: s3c64xx: Add node for display controller
  ARM: dts: s3c6410-mini6410: Add support for LCD screen

 .../bindings/arm/exynos/power_domain.txt           |  12 +-
 .../devicetree/bindings/power/power_domain.txt     |  51 ++++
 arch/arm/boot/dts/s3c6400.dtsi                     |   1 +
 arch/arm/boot/dts/s3c6410-mini6410.dts             |  33 ++
 arch/arm/boot/dts/s3c6410.dtsi                     |   1 +
 arch/arm/boot/dts/s3c64xx.dtsi                     |  13 +
 arch/arm/mach-exynos/pm_domains.c                  |  80 +----
 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c            |   8 +
 arch/arm/mach-s3c64xx/pm.c                         | 106 +++++--
 drivers/base/power/domain.c                        | 339 +++++++++++++++++++++
 include/dt-bindings/arm/s3c64xx-power-domains.h    |  26 ++
 include/linux/pm_domain.h                          |  34 +++
 kernel/power/Kconfig                               |   4 +
 13 files changed, 597 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt
 create mode 100644 include/dt-bindings/arm/s3c64xx-power-domains.h

-- 
1.8.5.2

