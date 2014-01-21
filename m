Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaAUKKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:10:36 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7010 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaAUKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:10:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Jan 2014 02:09:51 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/5] ARM: firmware: improvements to Trusted Foundations support
Date: Tue, 21 Jan 2014 19:10:11 +0900
Message-ID: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These (mostly minor) patches fix a few typos, improve points that
were agreed upon when the Trusted Foundation series was initially
submitted, and more importantly add support for the do_idle() firmware
operation that is needed for cpuidle to be supported. Tegra's cpuidle
driver is also updated accordingly.

These patches should be the last step before the device trees for NVIDIA
SHIELD and Tegra Note 7 can be submitted.

Alexandre Courbot (5):
  ARM: trusted_foundations: fix vendor prefix typos
  ARM: trusted_foundations: fallback when TF support is missing
  ARM: firmware: enable Trusted Foundations by default
  ARM: trusted_foundations: implement do_idle()
  ARM: tegra: cpuidle: use firmware call for power down

 arch/arm/configs/tegra_defconfig           |  1 -
 arch/arm/firmware/Kconfig                  |  3 ++-
 arch/arm/firmware/trusted_foundations.c    | 20 +++++++++++++++++++-
 arch/arm/include/asm/trusted_foundations.h | 13 +++++++++----
 arch/arm/mach-tegra/cpuidle-tegra114.c     |  3 +++
 5 files changed, 33 insertions(+), 7 deletions(-)

-- 
1.8.5.3

