Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab3GZWFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:05:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57575 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZWF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:05:29 -0400
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [GIT PULL] msm gpio fixes for 3.11
Date: Fri, 26 Jul 2013 15:05:22 -0700
Message-Id: <1374876322-2222-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-3.11-fix1

for you to fetch changes up to 8fd62389a778c902c7e8532594ea924bbaf465e8:

  ARM: msm: Consolidate gpiomux for older architectures (2013-07-26 14:55:38 -0700)

----------------------------------------------------------------
Fixes for MSM for 3.11

Two small fixes for MSM.

The first fixes the a gpio controller register address.  I didn't see
any acks from the devicetree maintainers, so I've copied them on this
pull request.  The change itself is minor, and just to the register
address.

The second change removes the gpiomux V1 code from MSM.  This was
breaking compilation for some of the targets.

----------------------------------------------------------------
Rohit Vaswani (2):
      ARM: msm: dts: Fix the gpio register address for msm8960
      ARM: msm: Consolidate gpiomux for older architectures

 arch/arm/boot/dts/msm8960-cdp.dts |  4 ++--
 arch/arm/mach-msm/Kconfig         |  3 +--
 arch/arm/mach-msm/gpiomux-v1.c    | 33 ---------------------------------
 arch/arm/mach-msm/gpiomux.h       | 10 ----------
 4 files changed, 3 insertions(+), 47 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c
