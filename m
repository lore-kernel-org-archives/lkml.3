Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3J1K2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:28:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8257 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3J1K2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:28:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Oct 2013 03:28:25 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v9 0/5] ARM: support for Trusted Foundations secure monitor
Date: Mon, 28 Oct 2013 19:28:33 +0900
Message-ID: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New attempt to get this merged. ;)

The last open discussion topic for this series is whether to move this into
drivers/ instead of having it depend on ARM. The problem is that the firmware
framework this series is built upon resides in arch/arm/. It would possibly
make sense to move it out of there as well, but doing so requires Tomasz
opinion on the matter and unfortunately I haven't been able to get feedback
from him, even after trying to contact him privately.

At the current state of things, this should be of little concern anyway.
Trusted Foundations is for the moment indeed ARM-only, and both the
Trusted Foundations driver and firmware framework can be moved out of
arch/arm/ at any time without introducing any incompatibility.

Also I have some inprovements to this driver waiting to be submitted, but
would like to get this generally-accepted part merged first instead of
adding new code that will probably need several new rounds of revisions.

Changelog from v8:
- moved includes that depended on config symbols to the top of the file
- use linux/*.h instead of asm/*.h

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
 arch/arm/include/asm/trusted_foundations.h         | 67 ++++++++++++++++++
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
1.8.4.1

