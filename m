Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaBGEfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:35:41 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14009 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBGEfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:35:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Feb 2014 20:34:05 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 0/6] ARM: firmware: improvements to Trusted Foundations support
Date: Fri, 7 Feb 2014 13:35:00 +0900
Message-ID: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These (mostly minor) patches fix a few typos, improve points that
were agreed upon when the Trusted Foundation series was initially
submitted, and more importantly add support for a prepare_idle()
firmware operation that informs the firmware a CPU is doing idle.
Tegra's cpuidle driver is then also updated accordingly.

These patches should be the last step before device trees for NVIDIA
SHIELD and Tegra Note 7 can be submitted.

Changes since v1:
- Do not remove TF support from tegra_defconfig (will automatically be taken
  care of during next configuration update)
- Add a new prepare_idle() operation to firmware_ops that informs the firmware
  a CPU is going idle (vs. asking the firmware to do it itself as do_idle()
  does)
- Fix idle states names in TF implementation of prepare_idle to sound less
  Tegra-specific

Alexandre Courbot (6):
  ARM: trusted_foundations: fix vendor prefix typos
  ARM: trusted_foundations: fallback when TF support is missing
  ARM: firmware: enable Trusted Foundations by default
  ARM: firmware: add prepare_idle() operation
  ARM: trusted_foundations: implement prepare_idle()
  ARM: tegra: cpuidle: use firmware for power down

 arch/arm/firmware/Kconfig                  |  3 ++-
 arch/arm/firmware/trusted_foundations.c    | 20 +++++++++++++++++++-
 arch/arm/include/asm/firmware.h            |  4 ++++
 arch/arm/include/asm/trusted_foundations.h | 13 +++++++++----
 arch/arm/mach-tegra/cpuidle-tegra114.c     | 11 ++++++++++-
 5 files changed, 44 insertions(+), 7 deletions(-)

-- 
1.8.5.3

