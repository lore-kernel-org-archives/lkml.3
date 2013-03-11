Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3CKIrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:47:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4358 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3CKIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:47:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 01:46:36 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/5] rtc: tegra: cleanups to remove warning/code lines
Date: Mon, 11 Mar 2013 14:14:23 +0530
Message-ID: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series does the cleanups in the rtc driver as follows:
- Protect suspend/resume with CONFIG_PM_SLEEP.
- Use dev_pm_ops in place of legacy way for suspend/resume.
- Properly reflect teh irq name when doing cat /proc/interrupts.
- Use module_platform_probe() to remove boilerplate code.
- use devm_rtc_device_register.

Changes from V1:
- Use SIMPLE_DEV_PM_OPS
- Correctd the acronym case rtc to RTC in description.
- Add Thierry reviewed by on some of patches.

Laxman Dewangan (5):
  rtc: tegra: protect suspend/resume callbacks with CONFIG_PM_SLEEP
  rtc: tegra: Use struct dev_pm_ops for power management
  rtc: tegra: use module_platform_driver_probe for module init/exit
  rtc: tegra: set irq name as device name
  rtc: tegra: use managed rtc_device_register

 drivers/rtc/rtc-tegra.c |   61 +++++++++++-----------------------------------
 1 files changed, 15 insertions(+), 46 deletions(-)

