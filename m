Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3HPSKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:10:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39842 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3HPSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:10:07 -0400
Message-Id: <cover.1376596224.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Thu, 15 Aug 2013 14:50:24 -0500
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH RFC 0/3] Add support for the System Power Management Interface (SPMI)
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
on several Qualcomm SoCs to communicate with off-chip Power Management
ICs (PMICs).  Notably missing from this patchset is an implementation of
a spmi device/slave driver, which is still forthcoming.  With this
patchset in it's current state, it is possible to perform register
accesses to a slave via debugfs.

[1]: http://www.mipi.org/specifications/system-power-management-interface

Josh Cartwright (1):
  spmi: document the PMIC arbiter SPMI bindings

Kenneth Heitke (2):
  spmi: Linux driver framework for SPMI
  spmi: Add MSM PMIC Arbiter SPMI controller

 .../devicetree/bindings/spmi/spmi-pmic-arb.txt     |  26 +
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/of/Kconfig                                 |   6 +
 drivers/of/Makefile                                |   1 +
 drivers/of/of_spmi.c                               |  74 +++
 drivers/spmi/Kconfig                               |  24 +
 drivers/spmi/Makefile                              |   9 +
 drivers/spmi/spmi-dbgfs.c                          | 591 +++++++++++++++++++++
 drivers/spmi/spmi-dbgfs.h                          |  37 ++
 drivers/spmi/spmi-pmic-arb.c                       | 499 +++++++++++++++++
 drivers/spmi/spmi.c                                | 449 ++++++++++++++++
 include/linux/mod_devicetable.h                    |   8 +
 include/linux/of_spmi.h                            |  37 ++
 include/linux/spmi.h                               | 337 ++++++++++++
 15 files changed, 2101 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt
 create mode 100644 drivers/of/of_spmi.c
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-dbgfs.c
 create mode 100644 drivers/spmi/spmi-dbgfs.h
 create mode 100644 drivers/spmi/spmi-pmic-arb.c
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/linux/of_spmi.h
 create mode 100644 include/linux/spmi.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

