Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3H1FpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:45:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3H1FpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:45:12 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-7f-521d8e621a9f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH 0/3] thermal: samsung: Add TMU for Exynos5420
Date: Wed, 28 Aug 2013 11:15:16 +0530
Message-id: <1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkRjepTzbI4NRcTouGqyEW84+cY7VY
	s/8nk0XvgqtsFpd3zWGz+Nx7hNFixvl9TBaLtv1ntnjysI/NgdNj56y77B6L97xk8ujbsorR
	4/iN7UwenzfJBbBGcdmkpOZklqUW6dslcGWsfDufveAQR8Wdc61MDYw32boYOTgkBEwkjpzj
	6WLkBDLFJC7cWw8U5uIQEljKKHHqQD8bRMJE4vynH0wQiUWMEr0PvzJDOD1MEht+T2MEqWIT
	MJM4uGg1O4gtIuAlMevhVbAOZoH1jBKHtq9lBkkIC9hKtD9qAhvLIqAqcb2/kQXE5hVwkWi9
	tJAR4iQFiTmTbEDCnAJuEi+W7WMCsYUEXCVe/JrJDjJTQmAdu8Sf7QuYIOYISHybfIgFoldW
	YtMBZoirJSUOrrjBMoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwMA//e9Z/w7G
	uwesDzEmA42byCwlmpwPjJy8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTA2RLja54Qd3mA7/dKX6U/jt8w5nJ65zeN42vXb/bZs8hzartmqG/27
	KroNftROZZts2ZnqcJNjerJPgtHytYwSKQ8fLDNI9c/dcuz2m51Tmd2nLLF/Fd13Y8olDpmM
	JRZ1Pcadn+dUFXw2eS/urqDUwXfHfbspx5JsmcsFG/l8jD8pv3r8J1GJpTgj0VCLuag4EQA0
	j6p1kgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAd2kPtkggxPuFg1XQyzmHznHarFm
	/08mi94FV9ksLu+aw2bxufcIo8WM8/uYLBZt+89s8eRhH5sDp8fOWXfZPRbvecnk0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix8u189oJD
	HBV3zrUyNTDeZOti5OSQEDCROP/pBxOELSZx4d56oDgXh5DAIkaJ3odfmSGcHiaJDb+nMYJU
	sQmYSRxctJodxBYR8JKY9fAqE0gRs8B6RolD29cygySEBWwl2h81ga1gEVCVuN7fyAJi8wq4
	SLReWgg0iANonYLEnEk2IGFOATeJF8v2gV0hJOAq8eLXTPYJjLwLGBlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgTH1TPpHYyrGiwOMQpwMCrx8FpslgkSYk0sK67MPcQowcGsJMJb8h8o
	xJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAmM8riTc0NjE3NTa1NLEwMbMkTVhJnPdgq3Wg
	kEB6YklqdmpqQWoRzBYmDk6pBkbttR9bF+z1++ASZyx+Y8F+plu8T3ZUTgg//dlzr9vdXsk3
	J2LWFMsU7NESmpb10PXBlT/VG7e7bbLMZSlkWftAJ+Xg5B+/fUUTJCU0nVOfmC5rc+JYP33l
	2qRdc+NMNp/ofnn2+x3BmPYJIc8lbk1VFeYOOS7crlTLEjcp+OmS23UZEaH2U74qsRRnJBpq
	MRcVJwIAuLzEF+8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patchset adds the TMU support for Exynos5420
1. correct the fall interrupt en, status bit fields
  Fixes an existing bug in the register field access
2. Add TMU support for Exynos5420 SoCs
  Adds support for Exynos5420. (These changes were tested on a different
  kernel version)
3. Handle the misplaced TRIMINFO register
  Discussion was going on at https://lkml.org/lkml/2013/8/7/59
  Handles the misplaced register on Exynos5420 Only

Naveen Krishna Chatradhi (3):
  thermal: samsung: correct the fall interrupt en, status bit fields
  thermal: samsung: Add TMU support for Exynos5420 SoCs
  thermal: exynos: Handle the misplaced TRIMINFO register

 .../devicetree/bindings/thermal/exynos-thermal.txt |   21 +++++
 drivers/thermal/samsung/exynos_tmu.c               |   38 ++++++--
 drivers/thermal/samsung/exynos_tmu.h               |    3 +
 drivers/thermal/samsung/exynos_tmu_data.c          |   92 ++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.h          |   10 ++-
 5 files changed, 158 insertions(+), 6 deletions(-)

-- 
1.7.9.5

