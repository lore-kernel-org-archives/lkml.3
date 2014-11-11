Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaKKRcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:32:55 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53289 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751306AbaKKRcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:32:51 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: arm@kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v3 0/2] arm64: Add support for Juno development board
Date: Tue, 11 Nov 2014 17:32:09 +0000
Message-Id: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds device tree support for ARM's AArch64 Juno development
board. It enables use of various peripherals on the board, from USB and
networking to I2C and PL011 UART.

The patches can also be found in the repository at:

   git://github.com/ARM-software/linux.git juno/dts-for-armsoc

for you to fetch.


Changes vs v2:
  - rebased on top of arm-soc/next/cleanup
  - Split the flat device tree into several files. Although some
    commonality still remains in the main .dts file with other
    devices trees (see psci node) it is not clear what benefits can
    be gained from moving such a small node into its own file.
  - Ordered nodes according to their address space
  - Removed ulpi_phy node as it was redundant and the bindings non-standard.

v2 version: http://lkml.org/lkml/2014/11/10/242

Best regards,
Liviu

Liviu Dudau (2):
  arm64: Create link to include/dt-bindings to enable C preprocessor
    use.
  arm64: Add Juno board device tree.

 arch/arm64/boot/dts/arm/Makefile              |   1 +
 arch/arm64/boot/dts/arm/juno-clocks.dtsi      |  45 ++++++
 arch/arm64/boot/dts/arm/juno-motherboard.dtsi | 129 +++++++++++++++
 arch/arm64/boot/dts/arm/juno.dts              | 218 ++++++++++++++++++++++++++
 arch/arm64/boot/dts/include/dt-bindings       |   1 +
 5 files changed, 394 insertions(+)
 create mode 100644 arch/arm64/boot/dts/arm/juno-clocks.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/juno-motherboard.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/juno.dts
 create mode 120000 arch/arm64/boot/dts/include/dt-bindings

-- 
2.1.3

