Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaHYNkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:40:53 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62369 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaHYNkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:40:51 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: lee.jones@linaro.org, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, grant.likely@linaro.org, khilman@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, zhangnian@huawei.com
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH 0/2] Hi6421 MFD driver
Date: Mon, 25 Aug 2014 21:39:39 +0800
Message-Id: <1408973982-2072-1-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add MFD driver for Hi6421 SoC.

It's based on my previous v6 patchset for Hi6421 MFD & regulator driver. But
since regulator part is applied, I rebased the MFD part to v3.17-rc1, merged
review feedback from Lee Jones, solved conflict in Makefile, and fixed a build
error.

Hi6421 is a PMIC SoC designed and manufactured by HiSilicon Ltd. It includes
multi-functions, such as regulators, codec, ADCs, Coulomb counter, etc.
Hi6421 can be used in various Hi3620 SoC based boards. Registers in Hi6421 are
memory bus mapped, so in this design they are accessed by regmap-mmio APIs.

---
changes in this version:
 * merge conflict in drivers/mfd/Makefile
 * use devm_ioremap_resource, as devm_request_and_ioremap is deprecated and
    now removed.
 * incorporate feedback from maintainer
    - Documentation as a separate patch
    - dts node rename from 'pmic' to 'hi6421'
based on v6 patchset for Hi6421 MFD & regulator

Guodong Xu (3):
  Documentation: mfd: add docs for hi6421 dt
  mfd: Add hi6421 PMIC core driver
  ARM: dts: hi3620-hi4511: Add HI6421 MFD and regulator nodes

 Documentation/devicetree/bindings/mfd/hi6421.txt |  38 ++++
 arch/arm/boot/dts/hi3620-hi4511.dts              | 233 +++++++++++++++++++++++
 drivers/mfd/Kconfig                              |  13 ++
 drivers/mfd/Makefile                             |   1 +
 drivers/mfd/hi6421-pmic-core.c                   | 112 +++++++++++
 include/linux/mfd/hi6421-pmic.h                  |  42 ++++
 6 files changed, 439 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/hi6421.txt
 create mode 100644 drivers/mfd/hi6421-pmic-core.c
 create mode 100644 include/linux/mfd/hi6421-pmic.h

-- 
1.9.1

