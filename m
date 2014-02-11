Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBKQxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:53:45 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20629 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751948AbaBKQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:53:43 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org, arm@kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 0/3] Versatile Express sysregs rework
Date: Tue, 11 Feb 2014 16:53:27 +0000
Message-Id: <1392137610-27842-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's over 6 month since I promised Samuel to rework the
not-really-MFD driver for Versatile Express sysregs. It's
also a while since I sent the RFC for the series, but
finally - it is here!

As suggested by Arnd back then, the VE configuration
infrastructure is now exposing standard regmap interface
instead of a custom one. As requested by Samuel, the sysreg
driver mainly consists of MFD cells definition now.

All this was possible thanks to the first patch, which
tries to address in a simple way an issue discussed
a number of times - a problem of early devices registration
in a "DT-powered" system. It simply makes it possible
to manually create devices for selected nodes at appropriate
init levels and guarantees that such devices will not
be created again during the massive of_platform_populate().

I think it would make sense to merge the whole series
through arm-soc tree so will appreciate opinions and/or
acks from respective maintainers.

Pawel Moll (3):
  driver core & of: Mark of_nodes of added device as populated
  mfd: vexpress: Convert custom func API to regmap
  mfd: vexpress: Define the device as MFD cells

 .../devicetree/bindings/arm/vexpress-sysreg.txt    |  79 ++-
 Documentation/devicetree/bindings/arm/vexpress.txt |  15 +-
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  76 ++-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |  76 ++-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |   5 +-
 arch/arm/mach-vexpress/ct-ca9x4.c                  |  10 +-
 arch/arm/mach-vexpress/v2m.c                       |  25 +-
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi       |   2 +-
 drivers/base/core.c                                |   4 +
 drivers/bus/Kconfig                                |   9 +
 drivers/bus/Makefile                               |   2 +
 drivers/bus/vexpress-config.c                      | 202 ++++++++
 drivers/clk/versatile/clk-vexpress-osc.c           |  94 ++--
 drivers/hwmon/vexpress.c                           |  15 +-
 drivers/mfd/Kconfig                                |  15 +-
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/vexpress-config.c                      | 288 -----------
 drivers/mfd/vexpress-sysreg.c                      | 538 ++++++---------------
 drivers/misc/Kconfig                               |   9 +
 drivers/misc/Makefile                              |   1 +
 drivers/misc/vexpress-syscfg.c                     | 320 ++++++++++++
 drivers/of/device.c                                |  16 +
 drivers/of/platform.c                              |   6 +-
 drivers/power/reset/vexpress-poweroff.c            |  13 +-
 drivers/regulator/vexpress.c                       |  50 +-
 include/linux/of.h                                 |   6 +
 include/linux/of_device.h                          |  11 +
 include/linux/vexpress.h                           |  93 +---
 28 files changed, 1059 insertions(+), 923 deletions(-)
 create mode 100644 drivers/bus/vexpress-config.c
 delete mode 100644 drivers/mfd/vexpress-config.c
 create mode 100644 drivers/misc/vexpress-syscfg.c

-- 
1.8.3.2

