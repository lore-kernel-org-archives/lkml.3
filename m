Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3IED2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:28:23 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17414 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3IED2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:28:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Sep 2013 20:28:20 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
CC: <gnurou@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 0/5] ARM: support for Trusted Foundations secure monitor
Date: Thu, 5 Sep 2013 12:27:55 +0900
Message-ID: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After several rounds of reviews, this patchset should be close to maturity. This
fifth version gathers the Reviewed-by tags, addresses the (hopefully) last
issues, and seeks the Acked-bys of ARM maintainers to be merged, probably
through the Tegra tree.

Changes since v4:
- Added ifdefs to isolate open firmware-dependant code
- Changed BUGS() into more appropriate calls to panic()
- Fix hard-fail when TF support is not compiled in
- Make Tegra documentation reference the TF binding
- Tested extensively

As there is no consensus on the matter, I have left the TF version in device
tree as two separate nodes. Comments for or against this and references to prior
practices regarding version handling in the device tree are welcome.

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
 arch/arm/firmware/Kconfig                          | 25 +++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 82 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 53 ++++++++++++++
 arch/arm/mach-tegra/Kconfig                        |  1 +
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/reset.c                        | 40 ++++++++---
 13 files changed, 220 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

-- 
1.8.4

