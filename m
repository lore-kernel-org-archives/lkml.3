Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaKTFqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:46:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18332 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaKTFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:46:17 -0500
X-AuditID: cbfee691-f79b86d000004a5a-59-546d80267698
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        pankaj.dubey@samsung.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v3 0/5] exynos: Move pmu driver to driver/soc folder and add
 exynos7 support
Date: Thu, 20 Nov 2014 11:09:23 +0530
Message-id: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWyRsSkWletITfE4McWVYuGqyEWvQuuslls
	enyN1eLyrjlsFjPO72OyWLT1C7sDm8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFp
	3na2gmaxiu1TvjE3ME4U6GLk5JAQMJH4tnEbG4QtJnHh3nowW0hgKaPE2YPmMDWz77SzdDFy
	AcUXMUosu7GOFcKZwCRxdtVKsA42AWOJnzv3s3cxcnCICHhLLL+mCFLDLNDEKHFu3mVWkBph
	gTiJU8cPMYPYLAKqEkePHmIBsXkF3CTmLr/CBNIrIaAgMWeSDUivhMBrNomVW46yQtQLSHyb
	DFIPUiMrsekAM8RxkhIHV9xgmcAouICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYEie
	/vds4g7G+wesDzEKcDAq8fAmWOSGCLEmlhVX5h5iNAXaMJFZSjQ5Hxj4eSXxhsZmRhamJqbG
	RuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MLpGl7PY7jI/osGWVDjlwiQ+
	FYGkrvCimyWTNnMd4LgUPu+5rpxQwZUULdtC0XrTfD724pirwgta4wpKjq4z7n8Q1hZy8OlJ
	368rpXe7qijk7rFs5dF7OFV0jk2Gmqvju5mzQz+cvBd/q6nWhTey+KSgt0SbNMduO/llLCqS
	azUuRyaovwxVYinOSDTUYi4qTgQA3dLSY0QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jAV21htwQg5b7MhYNV0MsehdcZbPY
	9Pgaq8XlXXPYLGac38dksWjrF3YHNo/NS+o9+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8l
	My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjHj0rztbAXNYhXbp3xjbmCcKNDFyMkhIWAiMftOOwuELSZx
	4d56ti5GLg4hgUWMEsturGOFcCYwSZxdtZINpIpNwFji58797F2MHBwiAt4Sy68pgtQwCzQx
	Spybd5kVpEZYIE7i1PFDzCA2i4CqxNGjh8A28Aq4ScxdfoUJpFdCQEFiziSbCYzcCxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEh/wz6R2MqxosDjEKcDAq8fAmWOSGCLEmlhVX5h5i
	lOBgVhLh/VQJFOJNSaysSi3Kjy8qzUktPsRoCrR8IrOUaHI+MB7zSuINjU3MTY1NLU0sTMws
	lcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUw1j//s6pcbNpR3nM5M3uX3KlnWBcgyfE1XdBz
	pvLMsDtTkzT/3bpy8WbZhbK303QXfXdLTqm5xrjp5nXJMikfnaYlpTsiprxpsFzKdK5IQNZT
	+aQdW+Y18dwAeT6v+mli8YE5DLGKVlb6m3J4lad9i7e/kmr74OvpqYEfBCpm73tjrZ839fxK
	JZbijERDLeai4kQAwnkKUo8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series [1 - 5] performs,

1) Moves pmu driver to driver/soc/samsung folder. This is needed as exynos7 is
   an arm64 based platform and hence PMU driver should be in driver folder.
   Some discussion happened about this in the v1 version. Finally adding it in
   driver/soc folder as it too SoC specific and not a general driver.
   Entire discussion can be found here (A).
2) Add exynos7 PMU support.
3) Enables the driver for 32bit arm exynos platforms.

Changes from V2:
* Added review comment changes suggested by Pankaj.
* Removed mfd client support in this patch series. This will be added later in
  the power domain patch series.
* Link to V2 can be found here (B)

Changes from V1:
* Move pmu driver in driver/soc/samsung folder
* Removed the power domain features. They will posted as a separate series.
* Added exynos7 PMU support.
* Link to v1 can be found here (A)

This complete patch series is rebased on Kukjin for-next tree.

(A) - http://www.spinics.net/lists/linux-samsung-soc/msg38442.html
(B) - http://www.spinics.net/lists/arm-kernel/msg375910.html

Amit Daniel Kachhap (5):
  ARM: EXYNOS: Move pmu specific header files under "linux/soc/samsung"
  drivers: soc: Add support for Exynos PMU driver
  driver: soc: exynos-pmu: Add an API to be called after wakeup
  drivers: soc: exynos-pmu: Add support for Exynos7
  arm: exynos: Select SOC_SAMSUNG config option

 .../devicetree/bindings/arm/samsung/pmu.txt        |    1 +
 arch/arm/mach-exynos/Kconfig                       |    1 +
 arch/arm/mach-exynos/Makefile                      |    2 +-
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    4 +-
 arch/arm/mach-exynos/suspend.c                     |    4 +-
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   20 +
 drivers/soc/samsung/Makefile                       |    1 +
 .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |  445 +++++++++++++++++++-
 .../linux/soc/samsung}/exynos-pmu.h                |    1 +
 .../linux/soc/samsung/exynos-regs-pmu.h            |  273 ++++++++++++
 15 files changed, 745 insertions(+), 15 deletions(-)
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (63%)
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (89%)
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (63%)

-- 
1.7.9.5

