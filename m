Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaIAI3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:29:15 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40754 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaIAI3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:29:13 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: lee.jones@linaro.org, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, grant.likely@linaro.org, khilman@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, zhangnian@huawei.com
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH 0/3] Add MFD and regulator drivers for Hi6421 PMIC SoC
Date: Mon,  1 Sep 2014 16:28:32 +0800
Message-Id: <1409560115-30646-1-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds an MFD core driver and a regulator driver for Hi6421 PMIC
SoC.

Hi6421 is a PMIC SoC designed and manufactured by HiSilicon Ltd. It includes
multi-functions, such as regulators, codec, ADCs, Coulomb counter, etc.
Hi6421 can be used in various Hi3620 SoC based boards. Registers in Hi6421 are
memory bus mapped, so in this design they are accessed by regmap-mmio APIs.

Hi6421 regulator driver is applied since v5. So move the related patches out.

---
changes in v8:
 * remove unused field in struct hi6421_pmic
 * fixes of coding style

changes in v7:
 * merge conflict in drivers/mfd/Makefile
 * use devm_ioremap_resource, as devm_request_and_ioremap is deprecated and
    now removed.
 * incorporate feedback from maintainer
    - Documentation as a separate patch
    - dts node rename from 'pmic' to 'hi6421'

changes in v6:
 * rebase to v3.17-rc1:
  - use devm_ioremap_resource in hi6421 mfd driver
  - add 'const' before var regulator_ops in new funcs in regulator core
 * fix build error in drivers/regulator/mc13892-regulator.c
     due to 'const' in regulator_desc.ops
 * remove patch to hi3xxx_defconfig

changes in v5:
 * rename _regulator_delay to _regulator_enable_delay
 * clean up hi6421_regulator_enable(), add 100us protective gap into
     regulator_desc's .enable_time
 * code clean up, fixes for style checking

changes in v4:
 * regulator: core:
  - add const qualifier to ops in struct regulator_desc
  - factor out _regulator_delay from _regulator_do_enable
  - add guard delay between calling regulator_disable and _enable
 * hi6421 regulator:
  - bug fix: missing min_uV for linear regualtor BUCK0~2
  - bug fix: wrong volt values in buck_3_voltages table
  - add const to hi6421 regulator_ops
  - use ldo_linear and ldo_linear_range in applicable LDOs.
  - rename regulator-name to conform to names in board schematics.

changes in v3:
 * hi6421: regulator: remove setting of constraints on board-specific
     capabilities
 * delete unecessary compatible property "hisilicon,hi6421-regulators"
 * change regulator enable/disable callback APIs to support protection
gaps, as
     required by hi6421 spec
 * split regulator set_mode/get_mode callback APIs to LDOs and BUCKs
 * delete hi6421.dtsi, mfd and regulator nodes are now in board config .dts

changes in v2:
 * use MFD APIs to manage sub-devices of Hi6421
 * use regmap-mmio for register access
 * use only generic regulator device tree property
 * rewrite regulator driver using helper APIs from both regulator and regmap

v1: first drop

Guodong Xu (3):
  Documentation: mfd: add docs for hi6421 dt
  mfd: Add hi6421 PMIC core driver
  ARM: dts: hi3620-hi4511: Add HI6421 MFD and regulator nodes

 Documentation/devicetree/bindings/mfd/hi6421.txt |  38 ++++
 arch/arm/boot/dts/hi3620-hi4511.dts              | 233 +++++++++++++++++++++++
 drivers/mfd/Kconfig                              |  13 ++
 drivers/mfd/Makefile                             |   1 +
 drivers/mfd/hi6421-pmic-core.c                   | 113 +++++++++++
 include/linux/mfd/hi6421-pmic.h                  |  41 ++++
 6 files changed, 439 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/hi6421.txt
 create mode 100644 drivers/mfd/hi6421-pmic-core.c
 create mode 100644 include/linux/mfd/hi6421-pmic.h

-- 
1.9.1

