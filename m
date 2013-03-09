Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3CISMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:12:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5504 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3CISMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:12:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 09 Mar 2013 10:11:42 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] rtc: tegra: cleanups to remove warning/code lines
Date: Sat, 9 Mar 2013 23:39:44 +0530
Message-ID: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan (5):
  rtc: tegra: protect suspend/resume callbacks with CONFIG_PM_SLEEP
  rtc: tegra: Use struct dev_pm_ops for power management
  rtc: tegra: use module_platform_driver_probe for module init/exit
  rtc: tegra: set irq name as device name
  rtc: tegra: use managed rtc_device_register

 drivers/rtc/rtc-tegra.c |   62 ++++++++++++----------------------------------
 1 files changed, 16 insertions(+), 46 deletions(-)

