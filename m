Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3IOJux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:50:53 -0400
Received: from gnurou.org ([207.192.72.5]:40436 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab3IOJue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:50:34 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: gnurou@gmail.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v6 0/5] ARM: support for Trusted Foundations secure monitor
Date: Sun, 15 Sep 2013 18:40:23 +0900
Message-Id: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sixth attempt at the support for Trusted Foundations, which allows many
Tegra-based (and quite possibly other) devices sold on the market to boot and
be used with an upstream kernel.

v5 did not receive many comments on the code itself, so I hope this means
the patch set is converging well. Most remarks were about the lack of clarity
about what Trusted Foundations is and how it fits with respect to SMC calling
conventions and the PSCI standard (spoiler: it does not fit).

Change against v5:
- added a no-op of_register_trusted_foundations() for the case where neither
  Trusted Foundations nor device tree support are enabled
- made it clear in the commit message and source file that TF does not follow
  the SMC calling convention, is totally independant of PSIC and only matters
  to devices that come with a bootloader that enables it.

Alexandre Courbot (5):
  ARM: add basic support for Trusted Foundations
  ARM: tegra: add support for Trusted Foundations
  ARM: tegra: split setting of CPU reset handler
  ARM: tegra: set CPU reset handler with firmware op
  ARM: tegra: support Trusted Foundations by default

 .../arm/firmware/tl,trusted-foundations.txt        | 17 +++++
 Documentation/devicetree/bindings/arm/tegra.txt    |  5 ++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/Kconfig                                   |  2 +
 arch/arm/Makefile                                  |  1 +
 arch/arm/configs/tegra_defconfig                   |  1 +
 arch/arm/firmware/Kconfig                          | 28 ++++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 79 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 70 +++++++++++++++++++
 arch/arm/mach-tegra/Kconfig                        |  1 +
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/reset.c                        | 40 ++++++++---
 13 files changed, 237 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

-- 
1.8.4

