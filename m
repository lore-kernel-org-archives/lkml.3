Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaIVUPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:15:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59976 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaIVUPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:15:38 -0400
From: Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [GIT PULL] qcom SoC changes for v3.18
Date: Mon, 22 Sep 2014 15:15:35 -0500
Message-Id: <A246CCDC-948C-429E-9FC5-934D317EB9D4@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Olav Haugan <ohaugan@codeaurora.org>, markivx@codeaurora.org
To: arm@kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.18

for you to fetch changes up to 525fbb55947177cdae507b0d292f43c2c9a75a47:

  ARM: qcom: Move scm-boot files to drivers/soc and include/soc (2014-09-18 18:14:01 -0500)

----------------------------------------------------------------
Qualcomm ARM Based SoC Updates for v3.18

* Moved scm support into drivers/soc/qcom (allows for use by drivers)
* Various bug fixes and minor feature additions to scm code
* Added big-endian support to debug MSM uart

----------------------------------------------------------------
Lina Iyer (2):
      ARM: qcom: Add SCM warmboot flags for quad core targets.
      ARM: qcom: Move scm-boot files to drivers/soc and include/soc

Olav Haugan (1):
      ARM: qcom: scm: Add logging of actual return code from scm call

Stephen Boyd (6):
      ARM: debug: Update MSM and QCOM DEBUG_LL help
      ARM: debug: msm: Support big-endian CPUs
      ARM: qcom: scm: Fix incorrect cache invalidation
      ARM: qcom: scm: Get cacheline size from CTR
      ARM: qcom: scm: Move the scm driver to drivers/soc/qcom
      ARM: qcom: scm: Add atomic SCM APIs

Vikram Mulukutla (1):
      ARM: qcom: scm: Flush the command buffer only instead of the entire cache

 arch/arm/Kconfig.debug                             |   5 +-
 arch/arm/include/debug/msm.S                       |   6 +
 arch/arm/mach-qcom/Kconfig                         |   3 -
 arch/arm/mach-qcom/Makefile                        |   3 -
 arch/arm/mach-qcom/platsmp.c                       |   2 +-
 arch/arm/mach-qcom/scm-boot.c                      |  39 ------
 drivers/soc/qcom/Kconfig                           |   2 +
 drivers/soc/qcom/Makefile                          |   2 +
 {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c     | 131 ++++++++++++++++++---
 .../arm/mach-qcom => include/soc/qcom}/scm-boot.h  |   2 +
 {arch/arm/mach-qcom => include/soc/qcom}/scm.h     |   5 +-
 11 files changed, 135 insertions(+), 65 deletions(-)
 delete mode 100644 arch/arm/mach-qcom/scm-boot.c
 rename {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c (67%)
 rename {arch/arm/mach-qcom => include/soc/qcom}/scm-boot.h (92%)
 rename {arch/arm/mach-qcom => include/soc/qcom}/scm.h (80%)
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

