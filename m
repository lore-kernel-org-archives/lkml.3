Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab3FMJNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:13:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6785 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab3FMJNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:13:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Jun 2013 02:11:46 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>
CC: <gnurou@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 0/3] ARM: tegra: add basic support for Trusted Foundations
Date: Thu, 13 Jun 2013 18:12:22 +0900
Message-ID: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New revision of the initial patch, fixed according to the many suggestions
received. (thanks!)

Changes since v1:
- Split patch into logical chunks as suggested by Tomasz
- Simplified smc function according to comments from Russel and David
- Use proper "Trusted Foundations" naming for firmware instead of "SecureOS"
- Very simple firmware infrastructure in mach-tegra to support the use of other
  firmwares
- Presence of secure monitor is signaled through a DT node instead of a "chosen"
  property
- Complain if support for a declared secure monitor is not compiled in

Alexandre Courbot (3):
  ARM: tegra: basic support for Trusted Foundations
  ARM: tegra: split setting of CPU reset handler
  ARM: tegra: set CPU reset handler with firmware op

 Documentation/devicetree/bindings/arm/tegra.txt    | 11 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/configs/tegra_defconfig                   |  1 +
 arch/arm/mach-tegra/Kconfig                        | 14 ++++++
 arch/arm/mach-tegra/Makefile                       |  3 ++
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/firmware.c                     | 40 +++++++++++++++++
 arch/arm/mach-tegra/firmware.h                     | 19 ++++++++
 arch/arm/mach-tegra/reset.c                        | 40 ++++++++++++-----
 arch/arm/mach-tegra/trusted_foundations.c          | 51 ++++++++++++++++++++++
 10 files changed, 171 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/mach-tegra/firmware.c
 create mode 100644 arch/arm/mach-tegra/firmware.h
 create mode 100644 arch/arm/mach-tegra/trusted_foundations.c

-- 
1.8.3

