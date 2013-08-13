Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3HMCaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:30:17 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8986 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab3HMCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:30:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Aug 2013 19:30:14 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 0/5] ARM: tegra: support for Trusted Foundations
Date: Tue, 13 Aug 2013 11:29:47 +0900
Message-ID: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the long-overdue third version of this series, hopefully addressing the 
suggestions received in v2.

Since I could confirm that the SMC interface used by Trusted Foundations is not 
Tegra-specific, I have moved core TF support into arch/arm/firmware as a 
proposal to consolidate all implementations of Tomasz Figa's firmware interface 
into that directory.

Changes from v2:
- Moved core TF support into arch/arm/firmware
- Added TF version number in DT bindings
- Cleaned TF registration code
- Tegra kernel now fails if TF is declared in the device tree but support
  is not compiled in
- Tegra kernel now fails if attempt to set CPU reset vector through secure
  monitor returned an error
- Moved update to tegra_defconfig into its own patch

Alexandre Courbot (5):
  ARM: add basic Trusted Foundations support
  ARM: tegra: add support for Trusted Foundations
  ARM: tegra: split setting of CPU reset handler
  ARM: tegra: set CPU reset handler with firmware op
  ARM: tegra: support Trusted Foundations by default

 .../arm/firmware/tl,trusted-foundations.txt        | 16 ++++++
 Documentation/devicetree/bindings/arm/tegra.txt    |  5 ++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/Kconfig                                   |  2 +
 arch/arm/Makefile                                  |  1 +
 arch/arm/configs/tegra_defconfig                   |  1 +
 arch/arm/firmware/Kconfig                          | 22 ++++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 58 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 36 ++++++++++++++
 arch/arm/mach-tegra/Kconfig                        |  1 +
 arch/arm/mach-tegra/Makefile                       |  1 +
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/firmware.c                     | 41 +++++++++++++++
 arch/arm/mach-tegra/firmware.h                     | 19 +++++++
 arch/arm/mach-tegra/reset.c                        | 40 +++++++++++----
 16 files changed, 236 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h
 create mode 100644 arch/arm/mach-tegra/firmware.c
 create mode 100644 arch/arm/mach-tegra/firmware.h

-- 
1.8.3.4

