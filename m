Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbaIRWdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:33:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38898 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaIRWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:33:13 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] watchdog: add support for QCOM WDT
Date: Thu, 18 Sep 2014 17:26:58 -0500
Message-Id: <cover.1411078425.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for the Watchdog Timer (WDT) found in the Krait
Processor Sub-system (KPSS) of the MSM8960, APQ8064, and IPQ8064 chips.

This driver is implemented ontop of WATCHDOG_CORE, and therefore its primary
interface is through userspace.  The implemantion is currently very basic (i.e.
it doesn't support PRETIMEOUT, even though it could be implemented through the
WDT's BARK functionality).  It should also be fairly easy to extend this driver
in the future to support newer chipsets as well.

Patch 3 also extends the driver to also register a restart_notifier, making it
possible for the WDT to act as a restart mechanism if more favorable mechanisms
don't work.  This is important for some boards which don't support PS_HOLD,
like the IPQ8064-based AP148 board.

Josh Cartwright (3):
  watchdog: qcom: add support for KPSS WDT
  watchdog: qcom: document device tree bindings
  watchdog: qcom: register a restart notifier

 .../devicetree/bindings/watchdog/qcom-wdt.txt      |  21 +++
 drivers/watchdog/Kconfig                           |  10 ++
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/qcom-wdt.c                        | 176 +++++++++++++++++++++
 4 files changed, 208 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
 create mode 100644 drivers/watchdog/qcom-wdt.c

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

