Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaAWTXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:23:23 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:47289 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752973AbaAWTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:23:20 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 0/5] Add X-Gene platform reboot mechanism
Date: Thu, 23 Jan 2014 11:19:56 -0800
Message-Id: <1390504801-24483-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reboot driver for the X-Gene platform. Add generic syscon reboot
driver.

V4 Change:
	- Remove old X-Gene reboot driver
	- Add generic syscon reboot driver
	- Add DTS and Kconfig for X-Gene reboot using syscon method

V3 Change:
	- Remove the reboot driver's use of acpi resource patch.
	- Change the reboot driver to use syscon to parse out 
	  system clock register. Remove the old method of getting
	  register from the reboot driver directly.
	- Remove documentation since its now simple.
V2 Change:
	- Add support for using ACPI resource.


Feng Kan (5):
  power: reset: Add generic SYSCON register mapped reset
  power: reset: Remove X-Gene reboot driver
  arm64: dts: Add X-Gene reboot driver dts node
  arm64: Select reboot driver for X-Gene platform
  Documentation: power: reset: Add documentation for generic SYSCON
    reboot driver

 .../bindings/power/reset/syscon-reboot.txt         |   16 +++
 arch/arm64/Kconfig                                 |    2 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   13 +++
 drivers/power/reset/Kconfig                        |    8 +-
 drivers/power/reset/Makefile                       |    2 +-
 drivers/power/reset/syscon-reboot.c                |  100 +++++++++++++++++++
 drivers/power/reset/xgene-reboot.c                 |  103 --------------------
 7 files changed, 136 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
 create mode 100644 drivers/power/reset/syscon-reboot.c
 delete mode 100644 drivers/power/reset/xgene-reboot.c

-- 
1.7.6.1

