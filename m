Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaHACpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:45:05 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:53573 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751663AbaHACpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:45:01 -0400
From: Feng Kan <fkan@apm.com>
To: linux@roeck-us.net, dbaryshkov@gmail.com, catalin.marinas@arm.com,
        dwmw2@infradead.org, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V9 0/6] Add X-Gene platform reboot mechanism
Date: Thu, 31 Jul 2014 19:45:51 -0700
Message-Id: <1406861157-29169-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reboot driver for the X-Gene platform. Add generic syscon reboot
driver.

V9 Change:
	- rebase on Guenter Roeck's V5 reset handler patch set. This 
	  allows for a generic reset to be call rather than the arm
	  specific reset handler.

V8 Change:
	- change Kconfig to depend on ARM || ARM64 || COMPILE_TEST

V7 Change:
	- Seem V3 on, the patches were not making in to the mailinglist.
	- Fix build error produced by other ARCH while including this
	  driver. Set to depend on arm64 ARCH for now.

V6 Change:
	- Add documentation for scu node.

V5 Change:
	- Documentation update, endian and access size.

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


Feng Kan (6):
  power: reset: Add generic SYSCON register mapped reset
  Documentation: power: reset: Add documentation for generic SYSCON
    reboot driver
  Documentation: arm64: add SCU dts binding documentation to linux
    kernel
  arm64: dts: Add X-Gene reboot driver dts node
  arm64: Select reboot driver for X-Gene platform
  power: reset: Remove X-Gene reboot driver

 Documentation/devicetree/bindings/arm/apm/scu.txt  |  17 ++++
 .../bindings/power/reset/syscon-reboot.txt         |  23 +++++
 arch/arm64/Kconfig                                 |   2 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |  12 +++
 drivers/power/reset/Kconfig                        |  12 +--
 drivers/power/reset/Makefile                       |   2 +-
 drivers/power/reset/syscon-reboot.c                |  98 ++++++++++++++++++++
 drivers/power/reset/xgene-reboot.c                 | 103 ---------------------
 8 files changed, 158 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/apm/scu.txt
 create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
 create mode 100644 drivers/power/reset/syscon-reboot.c
 delete mode 100644 drivers/power/reset/xgene-reboot.c

-- 
1.9.1

