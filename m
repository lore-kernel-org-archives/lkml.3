Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaDDCRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:17:48 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:43975 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaDDCRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:17:45 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, devicetree@vger.kernel.org,
        arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ARM: SMP: support Broadcom mobile SoCs
Date: Thu,  3 Apr 2014 21:18:06 -0500
Message-Id: <1396577891-2713-1-git-send-email-elder@linaro.org>
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
This series is based on the current arm-soc/for-next branch:
    e98cd72 arm-soc: document samsung merges
Plus one more recently-posted patch:
    http://permalink.gmane.org/gmane.linux.kernel/1677714

This series is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-smp

Alex Elder (5):
  ARM: introduce CPU_METHOD_OF_DECLARE_SETUP()
  ARM: add SMP support for Broadcom mobile SoCs
  ARM: configs: enable SMP in bcm_defconfig
  ARM: dts: enable SMP support for bcm28155
  ARM: dts: enable SMP support for bcm21664

 arch/arm/boot/dts/bcm11351.dtsi |   19 ++++
 arch/arm/boot/dts/bcm21664.dtsi |   19 ++++
 arch/arm/configs/bcm_defconfig  |    2 +
 arch/arm/include/asm/smp.h      |   10 +-
 arch/arm/kernel/devtree.c       |   31 +++++--
 arch/arm/mach-bcm/Kconfig       |   18 +++-
 arch/arm/mach-bcm/Makefile      |    5 +-
 arch/arm/mach-bcm/platsmp.c     |  194 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 286 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/mach-bcm/platsmp.c

-- 
1.7.9.5

