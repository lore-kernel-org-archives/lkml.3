Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514AbaEFIdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:33:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49569 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244AbaEFIdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:15 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-81-53689e4881dd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 0/6] Introducing Exynos ChipId driver
Date: Tue, 06 May 2014 17:51:16 +0900
Message-id: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t8zY12PeRnBBmu/Gln8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtn5ht1g/4zWLA7vH71+TGD02L6n36NuyitHj8ya5AJYoLpuU
	1JzMstQifbsErowZcw6zFOxVqLi/U7aB8ap4FyMnh4SAicThx5MYIWwxiQv31rOB2EICyxgl
	NkxNhKnZ2LeItYuRCyg+nVHi1vSL7BBOG5PE53vXWEGq2AR0JZ68n8sMYosIZEtcabwPZjML
	pEs8eDsBrEZYwELi2pcbYBtYBFQlev5MB7N5Bdwlbn38DFTPAbRNQWLOJBuQ+RIC39kkfmyd
	wQRRLyDxbfIhFogaWYlNB5ghjpOUOLjiBssERsEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS
	83M3MULCtHcH4+0D1ocYk4HGTWSWEk3OB4Z5Xkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwOvXGpwnfPnluluiHJ71PV15oElm3557ycqMExjdb
	13RPkFi25bZhWfV6A4GfHB530j7ss98rVXg60ibu35V525YJbNZ86Blh2BDivOejTdj3tFcc
	F2IOX+VM36fB3umSsMTz+2OXO7Md5/CfkJ7Rb2le67O9qdG0pqJSX5EpNfCRRXpb5isJJZbi
	jERDLeai4kQA4PVzv2kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQV2PeRnBBlc/61r8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtn5ht1g/4zWLA7vH71+TGD02L6n36NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZM+YcZinYq1Bxf6dsA+NV8S5GTg4J
	AROJjX2LWCFsMYkL99azdTFycQgJTGeUuDX9IjuE08Yk8fneNbAqNgFdiSfv5zKD2CIC2RJX
	Gu+D2cwC6RIP3k4AqxEWsJC49uUGG4jNIqAq0fNnOpjNK+AucevjZ6B6DqBtChJzJtlMYORe
	wMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Dp5J7WBc2WBxiFGAg1GJh/fEyvRgIdbE
	suLK3EOMEhzMSiK89fkZwUK8KYmVValF+fFFpTmpxYcYk4GWT2SWEk3OB8ZoXkm8obGJmZGl
	kZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwHvC63mt9irk/MNRkt6ChCUu1
	hkiOjuZJxwf/tp/kPbdf8cfFFzYt0ic8t9acna5ycFbDr5+R95ZoPrgdfsI5+sa+WymxFX+5
	pcVrbs2d0bbL/9PXhZ3+hdujJxYle3Coucaxfqtu9bLaHxJ468fmx78FMnuKOmsfGvBkKlq+
	1vbXtV3QvmmNEktxRqKhFnNRcSIAqEvgc8cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

[1]: Map SYSRAM through generic SRAM bindings.
	http://www.spinics.net/lists/arm-kernel/msg327677.html
[2]: Exynos PMU cleanup and refactoring.
	https://lkml.org/lkml/2014/4/30/44
[3]: Introduce drivers/soc and add QCOM GSBI driver.
	https://lkml.org/lkml/2014/4/24/520

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
  i2c: s3c2410: Moving I2C interrupt re-configuration code into i2c
    driver
  ARM: EXYNOS: Move SYS_I2C_CFG register save/restore to i2c driver
  ARM: EXYNOS: remove soc_is_exynos4/5 from exynos.c
  ARM:  EXYNOS: remove unused header inclusion from hotplug.c
  soc: samsung: exynos-chipid: Add Exynos Chipid driver support
  ARM: EXYNOS: Refactoring to remove soc_is_exynosXXXX macros from
    exynos

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
 arch/arm/mach-exynos/platsmp.c                     |   10 +-
 arch/arm/mach-exynos/pm.c                          |   36 ++---
 arch/arm/mach-exynos/regs-sys.h                    |   22 ---
 arch/arm/plat-samsung/include/plat/cpu.h           |   60 -------
 drivers/clk/samsung/clk-exynos4.c                  |    2 +-
 drivers/cpufreq/exynos-cpufreq.c                   |    9 +-
 drivers/cpufreq/exynos-cpufreq.h                   |    1 -
 drivers/cpufreq/exynos4x12-cpufreq.c               |    5 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   35 +++++
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   10 ++
 drivers/soc/samsung/Makefile                       |    1 +
 drivers/soc/samsung/exynos-chipid.c                |  166 ++++++++++++++++++++
 include/linux/exynos-soc.h                         |   46 ++++++
 25 files changed, 359 insertions(+), 210 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-chipid.txt
 delete mode 100644 arch/arm/mach-exynos/regs-sys.h
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-chipid.c
 create mode 100644 include/linux/exynos-soc.h

-- 
1.7.10.4

