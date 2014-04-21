Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaDULty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:49:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56969 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaDULtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:49:32 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>
Subject: [PATCH 0/4] add cpuidle support for Exynos5420
Date: Mon, 21 Apr 2014 17:19:14 +0530
Message-Id: <1398080958-21677-1-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7 cores.

This patchset adds cpuidle support for Exynos5420 SoC based on
generic big.little cpuidle driver.

Tested on SMDK5420.

This patch set depends on:
	1. [PATCH 0/5] MCPM backend for Exynos5420
	   http://www.spinics.net/lists/arm-kernel/msg321666.html

	2. [PATCH v4] arm: exynos: generalize power register address calculation
	   http://www.spinics.net/lists/arm-kernel/msg324024.html
		
Chander Kashyap (4):
  cpuidle: config: Add SOC_EXYNOS5420 entry to select
    cpuidle-big-little driver
  driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
  exynos: cpuidle: do not allow cpuidle registration for Exynos5420
  mcpm: exynos: populate suspend and powered_up callbacks

 arch/arm/mach-exynos/cpuidle.c       |    3 ++
 arch/arm/mach-exynos/mcpm-exynos.c   |   53 ++++++++++++++++++++++++++++++++++
 drivers/cpuidle/Kconfig.arm          |    2 +-
 drivers/cpuidle/cpuidle-big_little.c |    3 +-
 4 files changed, 59 insertions(+), 2 deletions(-)

-- 
1.7.9.5

