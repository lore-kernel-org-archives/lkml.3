Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaETRnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:43:53 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:63066 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaETRnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:43:50 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, jason@lakedaemon.net,
        lorenzo.pieralisi@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rdunlap@infradead.org, rjui@broadcom.com, robh+dt@kernel.org,
        rvaswani@codeaurora.org
Subject: [PATCH v4 0/5] ARM: SMP: support Broadcom mobile SoCs
Date: Tue, 20 May 2014 12:43:45 -0500
Message-Id: <1400607830-10989-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trouble posting patches today.  I'm very sorry about the duplicates.]

This series adds SMP support for two Broadcom mobile SoC families.
It uses CPU_METHOD_OF_DECLARE() so that SMP operations are assigned
using device tree rather than adding it to a machine definition in a
board file.

The enable method starts a secondary core by writing to a register
monitored by CPUs spinning in a ROM-based holding pen loop.  The
address of this register is recorded as a property in the "cpus"
node of the device tree.

					-Alex

Note:
This series is based on v3.15-rc4, plus one more recently-posted patch:
    http://permalink.gmane.org/gmane.linux.kernel/1683693

History
v3: - Renamed "platsmp.c" to be "kona_smp.c".
    - Rebased onto v3.15-rc5
v3: - Dropped definition and use of CPU_METHOD_OF_DECLARE_SETUP()
    - Added documentation for "enable-method"
    - Rebased onto v3.15-rc4
v2: - Fixed a Makefile error (:= should have been +=)
    - No longer set CONFIG_NR_CPUS in bcm_defconfig
    - Rebased onto v3.15-rc1

This series is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-smp-v4

Alex Elder (5):
  devicetree: bindings: document Broadcom CPU enable method
  ARM: add SMP support for Broadcom mobile SoCs
  ARM: configs: enable SMP in bcm_defconfig
  ARM: dts: enable SMP support for bcm28155
  ARM: dts: enable SMP support for bcm21664

 Documentation/devicetree/bindings/arm/cpus.txt |  12 ++
 arch/arm/boot/dts/bcm11351.dtsi                |  19 +++
 arch/arm/boot/dts/bcm21664.dtsi                |  19 +++
 arch/arm/configs/bcm_defconfig                 |   1 +
 arch/arm/mach-bcm/Kconfig                      |  18 ++-
 arch/arm/mach-bcm/Makefile                     |   3 +
 arch/arm/mach-bcm/kona_smp.c                   | 202 +++++++++++++++++++++++++
 7 files changed, 271 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-bcm/kona_smp.c

-- 
1.9.1

