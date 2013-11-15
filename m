Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3KOLnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:43:33 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32827 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3KOLn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:43:29 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-pm@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, tomasz.figa@gmail.com, yadi.brar01@gmail.com,
        sachin.kamat@linaro.org, myungjoo.ham@samsung.com
Subject: [RFC v2 0/4] Add basic support for ASV
Date: Fri, 15 Nov 2013 17:11:27 +0530
Message-Id: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original cover letter from Yadwinder:
This series is to add basic common infrastructure for ASV.
 Basically ASV is a technique used on samsung SoCs, which provides the
recommended supply voltage for dvfs of arm, mif etc. For a given operating
frequency, the voltage is recommended based on SoC's ASV group.
ASV group gets fussed on SoCs during process of mass production.

This series includes:
 - basic common infrastructue for ASV. It provides common APIs for user drivers
like cpufreq & devfreq and and an interface for SoC specific drivers to
register ASV members(instances)
 - a common platform driver to register ASV members for exynos SoCs
 - an example providing minimal support (only for ARM ASV) for exynos5250 chips

Its just basic skelton which I wanted to get it reviewed or discussed in
early stage, before going ahead on further development based on it.
 Presently example is based on static ASV table provided in SoC specific file,
which I expects to go into DT. But exactly how and where needs to be discussed,
may be in next revisions once we get through the basic skelton.
 Also the location of driver in kernel may also seem odd to someone and
many more things :).

Looking for your valuable reviews and suggestions.

Changes since v1:
* Rebased onto the latest linux-next
* Used devm* and *opp APIs
* Code cleanup and some fixes
* Updated kernel doc and Kconfig text

Yadwinder Singh Brar (4):
  power: asv: Add common ASV support for Samsung SoCs
  power: asv: Add a common ASV driver for Exynos SoCs.
  power: asv: Add support for Exynos5250
  ARM: SAMSUNG: Register static platform device for ASV for Exynos5

 arch/arm/mach-exynos/mach-exynos5-dt.c |    2 +
 drivers/power/Kconfig                  |    1 +
 drivers/power/Makefile                 |    1 +
 drivers/power/asv/Kconfig              |   23 +++++
 drivers/power/asv/Makefile             |    2 +
 drivers/power/asv/asv.c                |  176 ++++++++++++++++++++++++++++++++
 drivers/power/asv/exynos-asv.c         |   78 ++++++++++++++
 drivers/power/asv/exynos-asv.h         |   22 ++++
 drivers/power/asv/exynos5250-asv.c     |  139 +++++++++++++++++++++++++
 include/linux/power/asv-driver.h       |   62 +++++++++++
 include/linux/power/asv.h              |   37 +++++++
 11 files changed, 543 insertions(+)
 create mode 100644 drivers/power/asv/Kconfig
 create mode 100644 drivers/power/asv/Makefile
 create mode 100644 drivers/power/asv/asv.c
 create mode 100644 drivers/power/asv/exynos-asv.c
 create mode 100644 drivers/power/asv/exynos-asv.h
 create mode 100644 drivers/power/asv/exynos5250-asv.c
 create mode 100644 include/linux/power/asv-driver.h
 create mode 100644 include/linux/power/asv.h

-- 
1.7.9.5

