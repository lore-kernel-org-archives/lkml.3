Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbaE3W3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:29:01 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50283 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaE3W27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:28:59 -0400
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
Subject: [PATCH v4 RESEND 0/5] ARM: SMP: support Broadcom mobile SoCs
Date: Fri, 30 May 2014 17:28:51 -0500
Message-Id: <1401488936-21186-1-git-send-email-elder@linaro.org>
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
    - I would prefer to document the binding in a separate file in
      the way suggested here:
        https://lkml.org/lkml/2014/5/20/559
      But for now I'm keeping this independent of that.
    - This series is based on v3.15-rc4, plus one more recently-posted patch:
	https://lkml.org/lkml/2014/4/15/303
    - This series is available here:
	http://git.linaro.org/landing-teams/working/broadcom/kernel.git
	Branch review/bcm-smp-v4

History
v4: - Renamed "platsmp.c" to be "kona_smp.c".
    - Rebased onto v3.15-rc5
v3: - Dropped definition and use of CPU_METHOD_OF_DECLARE_SETUP()
    - Added documentation for "enable-method"
    - Rebased onto v3.15-rc4
v2: - Fixed a Makefile error (:= should have been +=)
    - No longer set CONFIG_NR_CPUS in bcm_defconfig
    - Rebased onto v3.15-rc1

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

