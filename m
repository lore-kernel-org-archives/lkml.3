Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3J3U1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:27:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55826 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3J3UZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:25:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 0/6] Krait L1/L2 EDAC driver
Date: Wed, 30 Oct 2013 13:25:30 -0700
Message-Id: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the Krait L1/L2 cache error detection
hardware. The first patch fixes a generic framework bug. The next
two patches lay the groundwork for this driver to be added by 
exporting percpu irq functions as well as adding the Krait l2 indirection
register code. The next two patches add the driver and the binding and 
the final patch hooks it all up by adding the device tree node.

I'm not sure which tree this is supposed to go through. Ideally we could
send the first 3 plus the 5th one through an edac tree. The final dts changes
could go through arm-soc via davidb's tree and the Documentation patch could
go through the devicetree tree.

Changes since v1:
 * Moved binding into cpus node
 * Picked up acks on first two patches
 * Commented krait l2 accessor functions

Stephen Boyd (6):
  edac: Don't try to cancel workqueue when it's never setup
  genirq: export percpu irq functions for module usage
  ARM: Add Krait L2 accessor functions
  edac: Document Krait L1/L2 EDAC driver binding
  edac: Add support for Krait CPU cache error detection
  ARM: dts: msm: Add Krait CPU/L2 nodes

 Documentation/devicetree/bindings/arm/cpus.txt |  49 ++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            |  37 +++
 arch/arm/common/Kconfig                        |   3 +
 arch/arm/common/Makefile                       |   1 +
 arch/arm/common/krait-l2-accessors.c           |  58 +++++
 arch/arm/include/asm/krait-l2-accessors.h      |  20 ++
 drivers/edac/Kconfig                           |   8 +
 drivers/edac/Makefile                          |   2 +
 drivers/edac/edac_device.c                     |   3 +
 drivers/edac/krait_edac.c                      | 346 +++++++++++++++++++++++++
 kernel/irq/manage.c                            |   2 +
 11 files changed, 529 insertions(+)
 create mode 100644 arch/arm/common/krait-l2-accessors.c
 create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
 create mode 100644 drivers/edac/krait_edac.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

