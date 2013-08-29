Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3H2J6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:58:01 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19389 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3H2J55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:57:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Aug 2013 02:55:23 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 0/5] ARM: tegra: support for Trusted Foundations
Date: Thu, 29 Aug 2013 18:57:43 +0900
Message-ID: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version revised according to comments received for v3. Hopefully
it will be good enough to be merged.

Changes since v3:
- Added of_register_trusted_foundations() function to avoid duplicate
  device tree parsing code in arch files
- Added ability to initialize Trusted Foundations through platform data
- Changed TF version number to integers
- Refactored Kconfig menu for more clarity

A few requests could not reasonably be implemented:

TF version probing at runtime (requested by Dave) seems impossible
unfortunately. TF just does not provide an interface that allows such
queries. In the downstream Tegra kernel the TF version is
even hardcoded into the kernel.

Use of a firmware_op instance for non-firmware behavior (requested by
Stephen) would make it necessary to have a dedicated non-firmware
registration function that takes implementations from various different
files and would require these implementations to be exported. Checking
the return code of call_firmware_op() at call sites seems to be easier
to handle and is how current users of firmware_ops do.

Alexandre Courbot (5):
  ARM: add basic Trusted Foundations support
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
 arch/arm/firmware/Kconfig                          | 26 +++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 83 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 48 +++++++++++++
 arch/arm/mach-tegra/Kconfig                        |  1 +
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/reset.c                        | 40 ++++++++---
 13 files changed, 217 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

-- 
1.8.4

