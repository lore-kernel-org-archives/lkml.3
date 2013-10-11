Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3JKVpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:45:50 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12828 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3JKVpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:45:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Oct 2013 14:41:31 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v8 0/5] ARM: support for Trusted Foundations secure monitor
Date: Fri, 11 Oct 2013 14:45:33 -0700
Message-ID: <1381527938-22840-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this has received enough review to be merged (although a few more
acks/review especially from DT people on patch 1 would be nice). Thanks
everyone for all the input and comments!

Trusted Foundations is an ARM secure monitor that is used by many Tegra-based
retail devices (like SHIELD and TegraNote). Adding support to it allows these
devices to boot on a purely upstream kernel.

Public documentation about Trusted Foundations is scarce, but over the various
versions of this patch it has been established that it does not follow the ARM
SMC convention and also has no connection whatsoever with PSCI. As such, it
requires an implementation of its own and the firmware interface introduced by
Tomasz provides an adequate framework for it.

Changes since v7:
- explicitly request the TF DT node to be under /firmware/ in the bindings
  documentation
- renamed arguments of tf_generic_smc() (suggestion made by Linus W. some time
  ago that I overlooked).
- fixed multi-line comment style

TODO in a future patchset:
- disable TF-dependant features (SMP, cpuidle) if TF cannot be supported instead
  or doing an early panic
- complete TF support with idle and L2 cache handling (ongoing)

Alexandre Courbot (5):
  ARM: add basic support for Trusted Foundations
  ARM: tegra: add support for Trusted Foundations
  ARM: tegra: split setting of CPU reset handler
  ARM: tegra: set CPU reset handler with firmware op
  ARM: tegra: support Trusted Foundations by default

 .../arm/firmware/tl,trusted-foundations.txt        | 20 ++++++
 Documentation/devicetree/bindings/arm/tegra.txt    |  5 ++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/Kconfig                                   |  2 +
 arch/arm/Makefile                                  |  1 +
 arch/arm/configs/tegra_defconfig                   |  1 +
 arch/arm/firmware/Kconfig                          | 28 ++++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 79 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 68 +++++++++++++++++++
 arch/arm/mach-tegra/Kconfig                        |  1 +
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/reset.c                        | 40 ++++++++---
 13 files changed, 238 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

-- 
1.8.4

