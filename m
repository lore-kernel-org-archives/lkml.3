Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaDDT5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:57:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37876 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaDDT5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:57:34 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH v6 0/5] Krait L1/L2 EDAC driver
Date: Fri,  4 Apr 2014 12:57:25 -0700
Message-Id: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the Krait L1/L2 cache error detection
hardware. The second patch adds the Krait L2 indirection
register code. This patch is in need of an ACK from ARM folks.
The next two patches add the driver and the binding and 
the final patch fixes up the DT nodes to match the binding (this last
one should go through the arm-soc tree).

NOTE: the DT binding patches rely on Lorenzo's cache DT binding document[1]

Changes since v5:
 * Don't rely on platform device being created from cpus node
 * Get interrupts from L1 cache node
 * Rework binding to be in cache document

Changes since v4:
 * Prefixed l2 accessors functions with krait_
 * Dropped first two patches as Boris says he picked them up

Changes since v3:
 * Fixed l1_irq handler to properly dereference dev_id

Changes since v2:
 * Picked up acks
 * s/an/a/ in DT binding

Stephen Boyd (5):
  genirq: export percpu irq functions for module usage
  ARM: Add Krait L2 register accessor functions
  devicetree: bindings: Document Krait cache error interrupts
  edac: Add support for Krait CPU cache error detection
  ARM: dts: msm: Fix Krait CPU/L2 nodes

 Documentation/devicetree/bindings/arm/cache.txt |  48 ++-
 arch/arm/boot/dts/qcom-msm8960.dtsi             |  29 +-
 arch/arm/boot/dts/qcom-msm8974.dtsi             |  49 +++-
 arch/arm/common/Kconfig                         |   3 +
 arch/arm/common/Makefile                        |   1 +
 arch/arm/common/krait-l2-accessors.c            |  58 ++++
 arch/arm/include/asm/krait-l2-accessors.h       |  20 ++
 drivers/edac/Kconfig                            |   8 +
 drivers/edac/Makefile                           |   2 +
 drivers/edac/krait_edac.c                       | 370 ++++++++++++++++++++++++
 kernel/irq/manage.c                             |   2 +
 11 files changed, 568 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm/common/krait-l2-accessors.c
 create mode 100644 arch/arm/include/asm/krait-l2-accessors.h
 create mode 100644 drivers/edac/krait_edac.c

[1] http://www.spinics.net/lists/arm-kernel/msg308540.html

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

