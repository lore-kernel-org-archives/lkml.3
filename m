Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3CLJ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:58:38 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48388 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab3CLJ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:58:36 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH V4 0/4] cpufreq: exynos5440: support for cpufreq driver
Date: Tue, 12 Mar 2013 15:28:15 +0530
Message-Id: <1363082299-10561-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Submitting the V4 version of exynos5440 cpufreq driver. This patchset addresses
all the coding and design concerns raised especially by Viresh.

Changes in V4:
* Added dev_err logs instead of pr_err.
* Used the devm_ioremap_resource API.
* Implemented several coding guidelines and minor error comments from Sylwester,
  Russell and Viresh.

Changes in V3:
* Converted the driver to probe based as suggested by Viresh. This is also
  beneficial for multiplatform kernel.
* Other coding guidelines related changes.
* Moved the DT node outside cpu0 node as the driver is now a platform
  driver.

Changes in V2:
* Added OPP library support to parse DT parameters.
* Removed a hack to handle interrupts in bootup.
* Implemented other review comments from Viresh and Inder.

All these patches are dependent on Thomas Abraham common clock patches.
(http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg15860.html)
This whole patch series is based on 3.9-rc2.

Amit Daniel Kachhap (4):
  cpufreq: exynos: Adding cpufreq driver for exynos5440
  cpufreq: exynos: Remove error return even if no soc is found
  arm: exynos: Enable OPP library support for exynos5440
  dts: Add cpufreq controller node for Exynos5440 SoC

 .../bindings/cpufreq/cpufreq-exynos5440.txt        |   29 ++
 arch/arm/boot/dts/exynos5440.dtsi                  |   12 +
 arch/arm/mach-exynos/Kconfig                       |    2 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 +
 drivers/cpufreq/Kconfig.arm                        |    9 +
 drivers/cpufreq/Makefile                           |    1 +
 drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
 drivers/cpufreq/exynos5440-cpufreq.c               |  466 ++++++++++++++++++++
 8 files changed, 522 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
 create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c

