Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaDBHe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:34:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63643 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbaDBHeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:14 -0400
X-AuditID: cbfee690-b7f266d00000287c-88-533bbd5fdb82
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 0/7] ARM: Exynos: PMU cleanup and refactoring for using DT
Date: Wed, 02 Apr 2014 16:50:51 +0900
Message-id: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t8zA934vdbBBvP2iVksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DKeLViNkvBBf6K3Wcb2RsYJ/B0MXJySAiYSKxc8YANwhaTuHBvPZDNxSEksIxR
	4t3fNYxdjBxgRZ9+x0DEFzFKvHq6hgnCaWOSuH/iPiNIN5uArsST93OZQWwRgWyJS7NusYDY
	zAJFEm/W/QHbICzgJfF+0kWwOIuAqsTLVa/AenkF3CV+z5vCArFMQWLOJBuQ+RICv9kknv79
	zQhRLyDxbfIhqBpZiU0HmCGOlpQ4uOIGywRGwQWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLz
	czcxQsJ0wg7GewesDzEmA42byCwlmpwPDPO8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamCUdPtoNd+azTkq2fPelle3tax4Fxm65dxw6OYRCtOV
	F9DU1JrIc9RZ/rO1fyFDR8i9Px3hipO9v8zna437efDDHq/g6fv0XHJ++hx44VH+oXRbD5tZ
	pc1EhS07v7lbZfhYG0tWbHh7Vkk0tzZh1/GO1QcdXhj1zt/x+8kW3z8tfWk7Tz65oKLEUpyR
	aKjFXFScCABfbzPfaQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jAd34vdbBBj33BC2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wu7A7tHS3MPmsXlJvUffllWMHp83yQWwRDUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHi1YjZLwQX+it1nG9kbGCfwdDFycEgI
	mEh8+h3TxcgJZIpJXLi3nq2LkYtDSGARo8Srp2uYIJw2Jon7J+4zglSxCehKPHk/lxnEFhHI
	lrg06xYLiM0sUCTxZt0fNhBbWMBL4v2ki2BxFgFViZerXoH18gq4S/yeN4UFYrGCxJxJNhMY
	uRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6CZ1I7GFc2WBxiFOBgVOLhPXDeKliI
	NbGsuDL3EKMEB7OSCC/nJOtgId6UxMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucDIzSvJN7Q2MTM
	yNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjn7T8klfpzK09EepVw2+dF
	LjdlsjQ/8P7rE/zVyvPydGTmZaYL1mKXd8b2lnFM6tp0YhkbT9uBjzxyGw9y8j3dcYL5jXsk
	34tg2Y3ZL0z2lGQWrrxQy6n6VfmNZ4+dskJDrpzVtpNXjGqvrLU4KzD1jc79h5Kmdq8uxwvf
	cXvRxVtjF3w5oFqJpTgj0VCLuag4EQCddftvxgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series, does some minor cleanup and modifies Exynos PMU related
code for mapping Exynos Power Management Unit (PMU) base address from device
tree. Since PMU offsets are used across many files under mach-exynos, it
introduces one helper function to get PMU base address in exynos.c.

This patch series is preparation for moving PMU related code out of machine
folder and converting into a driver.

This patch requires change in Exynos4210, Exynos4212 and Exynos4412 dtsi files,
which I will post shortly as separate patch series.

These patches are created on top of kgene for-next branch.
We have tested these patches for System boot and PMU initialization of
Exynos5250 and Exynos5260 (with some internal patches).
For rest Exynos SoC it has been only compile tested.

Pankaj Dubey (4):
  ARM: EXYNOS: Cleanup  "mach-exynos/common.h" file
  ARM: EXYNOS: Correct file path in comment message
  ARM: EXYNOS: Move "regs-pmu" header inclusion in common.h
  ARM: EXYNOS: Refactored code for PMU register mapping via DT

Young-Gun Jang (3):
  ARM: EXYNOS: Move SYSREG definition into sys-reg specific file
  ARM: EXYNOS: Remove regs-pmu.h file dependency from pm_domain
  ARM: EXYNOS: Add support for mapping PMU base address via DT

 arch/arm/mach-exynos/common.h           |   10 +-
 arch/arm/mach-exynos/cpuidle.c          |   29 +-
 arch/arm/mach-exynos/exynos.c           |   58 +++-
 arch/arm/mach-exynos/hotplug.c          |    5 +-
 arch/arm/mach-exynos/include/mach/map.h |    3 -
 arch/arm/mach-exynos/platsmp.c          |   15 +-
 arch/arm/mach-exynos/pm.c               |   55 ++--
 arch/arm/mach-exynos/pm_domains.c       |    2 +-
 arch/arm/mach-exynos/pmu.c              |   35 +--
 arch/arm/mach-exynos/regs-pmu.h         |  510 +++++++++++++++----------------
 arch/arm/mach-exynos/regs-sys.h         |   22 ++
 11 files changed, 405 insertions(+), 339 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

-- 
1.7.10.4

