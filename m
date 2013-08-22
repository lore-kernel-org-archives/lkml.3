Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3HVW5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:57:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56741 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3HVW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:57:04 -0400
Message-Id: <cover.1377202730.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Thu, 22 Aug 2013 15:18:50 -0500
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH RFC v2 0/3] Add support for the System Power Management Interface (SPMI)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The System Power Management Interface (SPMI) is a high-speed,
low-latency, bi-directional, two-wire serial bus suitable for real-time
control of voltage and frequency scaled multi-core application
processors and its power management of auxiliary components. SPMI
obsoletes a number of legacy, custom point-to-point interfaces and
provides a low pin count, high-speed control bus for up to 4 Master and
16 Slave devices.

SPMI is specified by the MIPI (Mobile Industry Process Interface)
Alliance [1].

Introduced in this patchset are the core SPMI bus components, as well an
implementation of an SPMI controller, the "PMIC arbiter", which is used
on the Qualcomm Snapdragon 800 series of SoCs to communicate with
off-chip Power Management ICs (PMICs).  Notably missing from this
patchset is an implementation of an SPMI device/slave driver, which is
still forthcoming.  With this patchset in it's current state, it is
possible to perform register accesses to a slave via debugfs.

Changes from v1[2]:
  - Adopted patch (1/5) to #define for_each_available_node() shim
    in the !CONFIG_OF case
  - Moved device tree logic out of drivers/of and into spmi.c core (this
    mirrors what SPI is doing, and what i2c will soon be doing)
  - Move of_spmi_add_devices() call into spmi_device_add(), so drivers don't
    have to call it explicitly
  - Unconditionally build in debugfs code (rely on the underlying
    CONFIG_DEBUG_FS switch to throw unused code away)
  - Change pr_* print functions to their dev_* equivalents
  - Fix copy_{to,from}_user error handling
  - Renamed "board_lock" to "ctrl_idr_lock" to better describe it's purpose
  - Rework device object lifetime management
  - Rename PMIC arb binding document, add description of PMIC arb
  - Add generic SPMI device tree bindings

[1]: http://www.mipi.org/specifications/system-power-management-interface
[2]: http://thread.gmane.org/gmane.linux.ports.arm.msm/4886

Josh Cartwright (2):
  spmi: add generic SPMI controller binding documentation
  spmi: document the PMIC arbiter SPMI bindings

Kenneth Heitke (2):
  spmi: Linux driver framework for SPMI
  spmi: Add MSM PMIC Arbiter SPMI controller

Sylwester Nawrocki (1):
  of: Add empty for_each_available_child_of_node() macro definition

 .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  36 ++
 Documentation/devicetree/bindings/spmi/spmi.txt    |  36 ++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/spmi/Kconfig                               |  24 +
 drivers/spmi/Makefile                              |   6 +
 drivers/spmi/spmi-dbgfs.c                          | 580 +++++++++++++++++++++
 drivers/spmi/spmi-dbgfs.h                          |  25 +
 drivers/spmi/spmi-pmic-arb.c                       | 416 +++++++++++++++
 drivers/spmi/spmi.c                                | 491 +++++++++++++++++
 include/linux/mod_devicetable.h                    |   8 +
 include/linux/of.h                                 |   3 +
 include/linux/spmi.h                               | 355 +++++++++++++
 13 files changed, 1983 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi.txt
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-dbgfs.c
 create mode 100644 drivers/spmi/spmi-dbgfs.h
 create mode 100644 drivers/spmi/spmi-pmic-arb.c
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/linux/spmi.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

