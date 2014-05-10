Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaEJG7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:59:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27730 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaEJG7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:59:51 -0400
X-AuditID: cbfee61b-b7f766d00000646c-f1-536dce664537
From: y@samsung.com
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 0/6] Introducing Exynos ChipId driver
Date: Sat, 10 May 2014 16:18:01 +0900
Message-id: <1399706287-13919-1-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t9jAd20c7nBBhsOylj8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtn5ht1g/4zWLA7vH71+TGD02L6n36NuyitHj8ya5AJYoLpuU
	1JzMstQifbsErozFm/exFexRqug5sZqxgXGVZBcjJ4eEgInEjdZpTBC2mMSFe+vZQGwhgUWM
	Es+aZbsYuYDsNiaJq88bWLsYOTjYBIQlph7QAqkREciWuNJ4nxnEZhZIl3jwdgIriC0sYCHx
	aeZ0sDksAqoSd84+AbN5BWwlOrb+ZgMZIyGgIDFnks0ERu4FjAyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYKD4pn0DsZVDRaHGAU4GJV4eAvf5gQLsSaWFVfmHmKU4GBWEuFdcTA3WIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAMj0+GlZnmv/rxn
	ZD6y69MegfgL+TKraiN8wh0zRWK2ZX3guSSkFbRjS9W322f/yj9wSjy+5OTDykW5IrMbXWx0
	j9bzpd+zuf/uwtMfF4tWSr7p6A7u6DC2mNeXcNxmcXtv+5sWvpbNr1vWd4gJlOvsm73YRuf9
	nVnfs44fdj3ea/566ooTekVzlFiKMxINtZiLihMBMu0FFwYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

This patch series attempts to get rid of soc_is_exynosXXXX macros
and eventually with the help of this series we can probably get
rid of CONFIG_SOC_EXYNOSXXXX in near future.
Each Exynos SoC has ChipID block which can give information about
SoC's product Id and revision number. Currently we have single
DT binding information for this as "samsung,exynos4210-chipid".
But Exynos4 and Exynos5 SoC series have one small difference in
chip Id, with resepect to product id bit-masks. So it means we
should have separate compatible string for these different series
of SoCs. So I have added second compatible string for handling
this difference. 
This patch series is based on Kukjin Kim's for-next (3.14_rc1 tag)
and prepared on top of following patch series and it's dependent
patch series.

[1]: Map SYSRAM through generic SRAM bindings by Sachin Kamat.
	http://www.spinics.net/lists/arm-kernel/msg327677.html
[2]: Exynos PMU cleanup and refactoring.
	https://lkml.org/lkml/2014/4/30/44
[3]: Introduce drivers/soc and add QCOM GSBI driver.
	https://lkml.org/lkml/2014/4/24/520

Revision 2 and it's discussion can be found here
 - https://lkml.org/lkml/2014/5/6/100

Changes since v2:
 - Reorganized patches as suggested by Tomasz Figa.
 - Addressed review comments of Tomasz Figa in i2c-s3c2410.c file.

Changes since v1:
 - Added patch to move i2c interrupt re-configuration code from exynos.c
   to i2c driver, as suggested by Arnd.
 - After above patch only user of SYS_I2C_CFG register is pm.c so moving
   save/restore of this register also into i2c driver.
 - Spiltted up exynos4 and exynos5 machine descriptors to get rid from
   soc_is_exynos4/exynos5 kind of macros, as suggested by Arnd.
 - Changed location of chipid driver to "drivers/soc".
 - Added drivers/base/soc.c provided infrastructure to make SoC specific 
   information avaible to user space via sysfs entry, as suggested by Arnd.


Pankaj Dubey (6):
  i2c: s3c2410: Handle i2c sys_cfg register in i2c driver
  ARM: EXYNOS: Remove i2c sys configuration related code
  ARM: EXYNOS: Remove soc_is_exynos4/5 from exynos.c
  ARM:  EXYNOS: Remove unused header inclusion from hotplug.c
  soc: samsung: exynos-chipid: Add Exynos Chipid driver support
  ARM: EXYNOS: Refactoring to remove soc_is_exynos macros from exynos

 .../bindings/arm/samsung/exynos-chipid.txt         |   21 +++
 .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/exynos4.dtsi                     |    2 +-
 arch/arm/boot/dts/exynos5.dtsi                     |    7 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    4 +
 arch/arm/boot/dts/exynos5420.dtsi                  |    4 +
 arch/arm/mach-exynos/exynos.c                      |  119 ++++----------
 arch/arm/mach-exynos/hotplug.c                     |    2 -
 arch/arm/mach-exynos/include/mach/map.h            |    3 -
 arch/arm/mach-exynos/platsmp.c                     |   11 +-
 arch/arm/mach-exynos/pm.c                          |   36 ++---
 arch/arm/mach-exynos/regs-sys.h                    |   22 ---
 arch/arm/plat-samsung/include/plat/cpu.h           |   60 -------
 drivers/clk/samsung/clk-exynos4.c                  |    2 +-
 drivers/cpufreq/exynos-cpufreq.c                   |    9 +-
 drivers/cpufreq/exynos-cpufreq.h                   |    1 -
 drivers/cpufreq/exynos4x12-cpufreq.c               |    5 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   32 ++++
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   10 ++
 drivers/soc/samsung/Makefile                       |    1 +
 drivers/soc/samsung/exynos-chipid.c                |  166 ++++++++++++++++++++
 include/linux/exynos-soc.h                         |   46 ++++++
 25 files changed, 357 insertions(+), 210 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt
 delete mode 100644 arch/arm/mach-exynos/regs-sys.h
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/exynos-soc.h

-- 
1.7.10.4

