Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaDONM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:12:58 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33483 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaDONM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:12:56 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] ARM: SMP: support Broadcom mobile SoCs
Date: Tue, 15 Apr 2014 08:12:49 -0500
Message-Id: <1397567574-31599-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds SMP support for two Broadcom mobile SoC families.
It uses CPU_METHOD_OF_DECLARE() (or rather a new variant of that)
so that SMP operations are assigned using device tree rather than
adding it to a machine definition in a board file.

The first patch adds the ability to extract information from device
tree nodes having a matching "enable-method" value.  This allows
additional parameters to be associated with the enable method.  This
is used for the Broadcom SoCs to efficiently determine the location
of a special register used in coordinating the start of secondary
CPUs.

I have not included a device tree document update here; I would like
suggestions on where the new enable method and its parameter should
be documented.  (I presume in .../arm/cpus.txt, but that could get
out of hand as more boards define new enable methods.)

					-Alex

Note:
This series is based on v3.15-rc1, plus one more recently-posted patch:
    http://permalink.gmane.org/gmane.linux.kernel/1683693

History
v2: - Fixed a Makefile error (:= should have been +=)
    - No longer set CONFIG_NR_CPUS in bcm_defconfig
    - Rebased onto v3.15-rc1

This series is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-smp-v2

Alex Elder (5):
  ARM: introduce CPU_METHOD_OF_DECLARE_SETUP()
  ARM: add SMP support for Broadcom mobile SoCs
  ARM: configs: enable SMP in bcm_defconfig
  ARM: dts: enable SMP support for bcm28155
  ARM: dts: enable SMP support for bcm21664

 arch/arm/boot/dts/bcm11351.dtsi |   19 ++++
 arch/arm/boot/dts/bcm21664.dtsi |   19 ++++
 arch/arm/configs/bcm_defconfig  |    1 +
 arch/arm/include/asm/smp.h      |   10 +-
 arch/arm/kernel/devtree.c       |   31 +++++--
 arch/arm/mach-bcm/Kconfig       |   18 +++-
 arch/arm/mach-bcm/Makefile      |    3 +
 arch/arm/mach-bcm/platsmp.c     |  194 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 284 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/mach-bcm/platsmp.c

-- 
1.7.9.5
