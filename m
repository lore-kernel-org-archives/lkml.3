Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaDYMrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:47:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46026 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaDYMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:47:48 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-b2-535a5972628e
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, b.zolnierkie@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RFC PATCH v2 0/3] Add support for Exynos PMU driver
Date: Fri, 25 Apr 2014 22:05:28 +0900
Message-id: <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+ZoW5RZFSwQfssK4uNM9azWiybdJfN
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81os2vqF3WL9jNcsFjefbWey2NGymsWB26OluYfN
	Y/OSeo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKeH54AmvBI9GKI3ua2BsYjwh0MXJwSAiY
	SFw4mdHFyAlkiklcuLeerYuRi0NIYBmjxNk1LWwQCROJ1oVvmCASixgl5vS8g6pqY5KY//EK
	C0gVm4CuxJP3c5lBbBGBbIkrjfeZQYqYBa4ySpx82Q6WEBawlXi6cgMjiM0ioCrR/n4ZWJxX
	wF3i9LLDLBAnKUjMmWQDEuYU8JD4Pm0+WLkQUMmFv0fBrpAQ2MQu0XdpGzPEHAGJb5MPQfXK
	Smw6wAxxtaTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERIBE3cw3j9g
	fYgxGWjcRGYp0eR8YATllcQbGpsZWZiamBobmVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVANj7oevPzXaFa+c/7zkSWvjWh+tUx78fPxlytltYleOxLJxqjdqbE3a43Tn
	s71WWrjsE23D85Z8Jm9FlumdOeQVtmWCTq4I6+yNdxyzn5noFSQdPhf4bkfp/Xfng+prd11N
	dLynv+P9odsp1nN22hUzhf6yn2x5ybuvd1tODcerfXcux5dvTFugxFKckWioxVxUnAgA/NTj
	nZYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd2iyKhgg10zTC02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdov1M16zWNx8tp3JYkfLahYHbo+W5h42
	j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bz
	wxNYCx6JVhzZ08TewHhEoIuRk0NCwESideEbJghbTOLCvfVsXYxcHEICixgl5vS8g3LamCTm
	f7zCAlLFJqAr8eT9XGYQW0QgW+JK431mkCJmgauMEidftoMlhAVsJZ6u3MAIYrMIqEq0v18G
	FucVcJc4veww0CAOoHUKEnMm2YCEOQU8JL5Pmw9WLgRUcuHvUaYJjLwLGBlWMYqmFiQXFCel
	5xrqFSfmFpfmpesl5+duYgRH2DOpHYwrGywOMQpwMCrx8H5QiwwWYk0sK67MPcQowcGsJML7
	wS8qWIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgdGfVxJvaGxiZmRpZGZhZGJuTpqwkjjv
	gVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MrEvUVXYuqNFY1eTzl8P0ZUB52qKLVWb5+oV12Svl
	F+6/d3DHgdeH/mub3ZhnFJo+J3+Cxw9e4xcbd0ltrjx01dWxkyfBM8fWL+hfjcK7KdOYZzVK
	vMvNX/qIVVeudc+Zw0/lY//t3/ayZIfCTxbZI27VX2caxq91t5x+0dbw/NM596zfcTafV2Ip
	zkg01GIuKk4EAMxqFjP0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves PMU implementation from "mach-exynos/pmu.c" to
"drivers/mfd/exynos-pmu.c". Patch v1 was posted as RFC [1].


In case of ARM32 we had machine folder such as "mach-exynos" but
moving forward with ARM64 SoC support we can not have any more such
machine folders, keeping that in mind we have planned to move PMU
implementation out of machine folder, so that common piece of code
can be reused.

This patch series is based on kgene for-next and depends on following
patch series
 a) [PATCH v2 0/5] Add PMU node for Exynos SoCs
	https://lkml.org/lkml/2014/4/25/216
 b) [PATCH v2 00/10] ARM: Exynos: PMU cleanup and refactoring for using DT
	https://lkml.org/lkml/2014/4/25/252


1) [RFC PATCH 0/2] Add support for Exynos PMU driver
	https://lkml.org/lkml/2014/4/2/69

Changes since v1:
 - Rebased on Kukjin Kim's for-next (3.15_rc1 tag)
 - Added patch: Move PMU specific definitions from common.h
 - Added patch: Move pmu specific header files under "linux/mfd/samsung"
 - Removed patch: ARM: EXYNOS: remove arch specific PMU implementation
	As suggested breaking down patches into smalled pieces for better review.
	Also modified all changes in pmu.c under mach-exynos itself and then
	prepared patches moving files from mach-exynos to "drivers/mfd"

Pankaj Dubey (2):
  ARM: EXYNOS: Move pmu specific header files under "linux/mfd/samsung"
  drivers: mfd: Add support for Exynos PMU driver

Younggun Jang (1):
  ARM: EXYNOS: Move PMU specific definitions from common.h

 arch/arm/mach-exynos/Kconfig                |    2 +
 arch/arm/mach-exynos/Makefile               |    2 -
 arch/arm/mach-exynos/common.h               |   17 -
 arch/arm/mach-exynos/cpuidle.c              |    3 +-
 arch/arm/mach-exynos/exynos.c               |    2 +-
 arch/arm/mach-exynos/hotplug.c              |    2 +-
 arch/arm/mach-exynos/platsmp.c              |    2 +-
 arch/arm/mach-exynos/pm.c                   |    3 +-
 arch/arm/mach-exynos/pmu.c                  |  522 ---------------------------
 arch/arm/mach-exynos/regs-pmu.h             |  308 ----------------
 drivers/mfd/Kconfig                         |    9 +
 drivers/mfd/Makefile                        |    1 +
 drivers/mfd/exynos-pmu.c                    |  521 ++++++++++++++++++++++++++
 include/linux/mfd/samsung/exynos-pmu.h      |   31 ++
 include/linux/mfd/samsung/exynos-regs-pmu.h |  308 ++++++++++++++++
 15 files changed, 879 insertions(+), 854 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/pmu.c
 delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
 create mode 100644 drivers/mfd/exynos-pmu.c
 create mode 100644 include/linux/mfd/samsung/exynos-pmu.h
 create mode 100644 include/linux/mfd/samsung/exynos-regs-pmu.h

-- 
1.7.10.4

