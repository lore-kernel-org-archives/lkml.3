Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaIYRyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:54:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51089 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaIYRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:54:29 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 0/3] watchdog: add support for QCOM WDT
Date: Thu, 25 Sep 2014 12:48:50 -0500
Message-Id: <cover.1411667144.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
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

Changes since v2:
  - "input clock phandle" -> "input clock" in device tree documentation
  - Fixup error handling paths during probe()
  - Use a more sane timeout (128ms), and add msleep()
  - Add some additional sanitation for clock rates

Changes since v1:
  - Make use of clock API instead of using a 'clock-frequency' property
  - Setup default timeout of 30 seconds when one is not specified
  - Add remove() function to allow for module unloading
  - Don't acquire/release watchdog lock on restart
  - Don't bail completely if restart_handler registration fails

Josh Cartwright (3):
  watchdog: qcom: add support for KPSS WDT
  watchdog: qcom: document device tree bindings
  watchdog: qcom: register a restart notifier

 .../devicetree/bindings/watchdog/qcom-wdt.txt      |  22 ++
 drivers/watchdog/Kconfig                           |  13 ++
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/qcom-wdt.c                        | 227 +++++++++++++++++++++
 4 files changed, 263 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
 create mode 100644 drivers/watchdog/qcom-wdt.c

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

