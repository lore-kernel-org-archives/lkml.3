Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaDBIHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:07:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14554 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaDBIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:07:34 -0400
X-AuditID: cbfee690-b7f266d00000287c-37-533bc5444e50
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RFC PATCH 0/2] Add support for Exynos PMU driver
Date: Wed, 02 Apr 2014 17:24:43 +0900
Message-id: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t8zA12Xo9bBBu37TS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wu7A7tHS3MPmsXlJvUffllWMHp83yQWwRHHZpKTm
	ZJalFunbJXBlfPl6lLVgmUDF6nOLmRsYL/N0MXJySAiYSJy9uYwNwhaTuHBvPZgtJLCMUeLc
	VtEuRnawmnlAUS6g6HRGiTcT/rBCOG1MEofWz2cCqWcT0JV48n4uM4gtIpAtcWnWLRYQm1mg
	SOLNuj9gM4UFrCRar/SA1bAIqEqsXfQNqIaDg1fAXeLqBRsQU0JAQWLOJBuQ8RICv9kketrf
	skOUC0h8m3yIBaJGVmLTAWaIiyUlDq64wTKBUXABI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k
	/NxNjJAAnbCD8d4B60OMyUDjJjJLiSbnAwM8ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYTWt1GHTvKPQvf6rn/MraJvVscd9kh/Vn0xiCJh09
	VnlBe9J+Y9vO+DaVnSZWQrOlOO4WSXmeLWrwqnjJKGzgdYh3oU660+QGX+VpqzfPiTAo/+h8
	t6ay8MvJwNT/W/29l0SKf20P33d/JesHkeDJwpL6849c+XKZ3y7u3LFI+Yq4L0e23LitxFKc
	kWioxVxUnAgABQpGBmYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQV2Xo9bBBm9nGVosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPHl61HWgmUCFavPLWZuYLzM08XIziEh
	YCIxj62LkRPIEpO4cG89kM3FISQwnVHizYQ/rBBOG5PEofXzmUCq2AR0JZ68n8sMYosIZEtc
	mnWLBcRmFiiSeLPuD9gkYQEridYrPWA1LAKqEmsXfQOq4eDgFXCXuHrBBsSUEFCQmDPJZgIj
	9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwRHwTGoH48oGi0OMAhyMSjy8B85bBQux
	JpYVV+YeYpTgYFYS4eU6aB0sxJuSWFmVWpQfX1Sak1p8iDEZaPdEZinR5HxgdOaVxBsam5gZ
	WRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+MUrz1pqVfVzK6qPd/8S7m3
	IO1KhHyrkdHvO1fW310fuuaefIRB4ORENp81X62vutSb5R8p+hN3d7rThK9Wy43C59VXvTdz
	zonN8m/aefL30uStbNpda2c5TmlcGNF0TqWYu8tPabZ9ndYLrl++eZnuGo+c1qX/6tS5Lb5v
	ue+Fz+Wh8wMn7ldiKc5INNRiLipOBAAoBecsxAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series tries to remove machine specific implementation
of Power Management Unit from "mach-exynos" to driver form.
In case of ARM32 we had machine folder such as "mach-exynos" but
moving forward with ARM64 SoC support we can not have any more such
machine folders, keeping that in mind we have planned to move PMU
implementation out of machine folder and give it driver form.
Since PMU binding already exist as "samsung, exynosxxx-pmu, syscon"
and Syscon driver is located under "drivers/mfd" we are moving 
Exynos PMU driver under "drivers/mfd", but suggestions are welcome.

This patch series is based on kgene for-next and depends on following
patch series
1) ARM: Exynos: PMU cleanup and refactoring for using DT
   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg27875.html

We have tested this driver for System boot and PMU initialization on Exynos5250
and Exynos5260 (with support of some internal patches).

Pankaj Dubey (1):
  ARM: EXYNOS: remove arch specific PMU implementation

Younggun Jang (1):
  drivers: mfd: Add support of exynos-pmu driver

 arch/arm/mach-exynos/Kconfig                |    2 +
 arch/arm/mach-exynos/Makefile               |    2 -
 arch/arm/mach-exynos/common.h               |   22 +-
 arch/arm/mach-exynos/pmu.c                  |  426 ---------------------
 arch/arm/mach-exynos/regs-pmu.h             |  310 ----------------
 drivers/mfd/Kconfig                         |    9 +
 drivers/mfd/Makefile                        |    2 +
 drivers/mfd/exynos-pmu.c                    |  534 +++++++++++++++++++++++++++
 include/linux/mfd/samsung/exynos-pmu.h      |   31 ++
 include/linux/mfd/samsung/exynos-regs-pmu.h |  308 +++++++++++++++
 10 files changed, 890 insertions(+), 756 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/pmu.c
 delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
 create mode 100644 drivers/mfd/exynos-pmu.c
 create mode 100644 include/linux/mfd/samsung/exynos-pmu.h
 create mode 100644 include/linux/mfd/samsung/exynos-regs-pmu.h

-- 
1.7.10.4

