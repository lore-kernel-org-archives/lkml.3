Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaF3WPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:15:46 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41354 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaF3WPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:15:45 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/4] ARM: SMP: support Broadcom mobile SoCs
Date: Mon, 30 Jun 2014 17:15:36 -0500
Message-Id: <1404166540-4457-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds SMP support for two Broadcom mobile SoC families.
It uses CPU_METHOD_OF_DECLARE() so that SMP operations are assigned
using device tree rather than adding it to a machine definition in a
board file.

The enable method starts a secondary core by writing to a register
monitored by CPUs spinning in a ROM-based holding pen loop.  The
address of this register is recorded as a property in the "cpus"
node of the device tree.

					-Alex

Notes:
    - This series previously included the binding as its first patch.  That
      has now been posted separately to facilitate and focus review.
    - This series is based on v3.16-rc1, plus two recently-posted patches:
	http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/264012.html
	http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/264024.html
    - This series, along with the binding patch, is available here:
	http://git.linaro.org/landing-teams/working/broadcom/kernel.git
	Branch review/bcm-smp-v6

History
v6: - Only change was to separate the binding patch from the series.
v5: - No real change; rebased onto v3.16-rc1.
v4: - Renamed "platsmp.c" to be "kona_smp.c".
    - Rebased onto v3.15-rc5
v3: - Dropped definition and use of CPU_METHOD_OF_DECLARE_SETUP()
    - Added documentation for "enable-method"
    - Rebased onto v3.15-rc4
v2: - Fixed a Makefile error (:= should have been +=)
    - No longer set CONFIG_NR_CPUS in bcm_defconfig
    - Rebased onto v3.15-rc1

Alex Elder (4):
  ARM: add SMP support for Broadcom mobile SoCs
  ARM: configs: enable SMP in bcm_defconfig
  ARM: dts: enable SMP support for bcm28155
  ARM: dts: enable SMP support for bcm21664

 arch/arm/boot/dts/bcm11351.dtsi |  19 ++++
 arch/arm/boot/dts/bcm21664.dtsi |  19 ++++
 arch/arm/configs/bcm_defconfig  |   1 +
 arch/arm/mach-bcm/Kconfig       |  18 +++-
 arch/arm/mach-bcm/Makefile      |   3 +
 arch/arm/mach-bcm/kona_smp.c    | 202 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 259 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-bcm/kona_smp.c

-- 
1.9.1
