Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaH3Mv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:51:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33558 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaH3MvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:51:24 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 0/4] Add support for Ricoh RN5T618 PMIC
Date: Sat, 30 Aug 2014 14:50:22 +0200
Message-Id: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ricoh RN5T618 is a power management IC which includes 3 step-down DCDC
converters, 7 low-dropout regulators, a Li-ion battery charger, fuel
gauge, ADC, GPIOs and a watchdog timer.

This series adds a MFD core driver and separate drivers to support the
regulator and watchdog functionalities.

The patchset has been tested on a Tronsmart Vega S89 Elite TV box on
top of other patches needed to support the Amlogic Meson SoC. The tree
with all the changes is available at:

  https://github.com/bengal/linux/tree/rn5t618-v2

Changes since v1:
  - moved all header file changes to the first patch
  - mfd: allow modular build
  - mfd: removed printk after mfd registration
  - regulator: rebased on regulator/for-next
  - wdt: initialized heartbeat parameter to 0 instead of -1
  - wdt: simplified code path in set_timeout function
  - wdt: fixed module unloading
  - wdt: made 'time' unsigned in struct rn5t618_wdt_map

Beniamino Galvani (4):
  mfd: Add Ricoh RN5T618 PMIC core driver
  regulator: add driver for Ricoh RN5T618 regulators
  watchdog: add driver for Ricoh RN5T618 watchdog
  mfd: rn5t618: document device tree bindings

 Documentation/devicetree/bindings/mfd/rn5t618.txt |   36 ++++
 drivers/mfd/Kconfig                               |   11 +
 drivers/mfd/Makefile                              |    1 +
 drivers/mfd/rn5t618.c                             |  134 ++++++++++++
 drivers/regulator/Kconfig                         |    6 +
 drivers/regulator/Makefile                        |    1 +
 drivers/regulator/rn5t618-regulator.c             |  143 +++++++++++++
 drivers/watchdog/Kconfig                          |   11 +
 drivers/watchdog/Makefile                         |    1 +
 drivers/watchdog/rn5t618_wdt.c                    |  198 ++++++++++++++++++
 include/linux/mfd/rn5t618.h                       |  228 +++++++++++++++++++++
 11 files changed, 770 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rn5t618.txt
 create mode 100644 drivers/mfd/rn5t618.c
 create mode 100644 drivers/regulator/rn5t618-regulator.c
 create mode 100644 drivers/watchdog/rn5t618_wdt.c
 create mode 100644 include/linux/mfd/rn5t618.h

-- 
1.7.10.4

