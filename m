Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaBKCSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:18:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64357 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBKCSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:18:10 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-93-52f9885d9828
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v1 0/1] Boot all secondary cores on Exynos SoC's
Date: Tue, 11 Feb 2014 11:15:28 +0900
Message-id: <1392084929-14116-1-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xy7qxHT+DDNYtF7GYtO4Ak8XD9TdZ
	LPrfLGS1OPdqJaNF74KrbBabHl9jtbi8aw6bxYzz+5gsbl/mtVh6/SKTxYTpa1ksWvceYbf4
	3fOJ2WL981OMFutnvGaxmDrjB7uDgMeaeWsYPVqae9g8Lvf1Mnn8XfWC2WPnrLvsHiuXf2Hz
	2LSqk83jzrU9bB6bl9R79G1ZxejxeZNcAHcUl01Kak5mWWqRvl0CV8bfKSfYCs6yVizbld7A
	eIKli5GTQ0LARKJrxQomCFtM4sK99WwgtpDAUkaJppM+XYxcQHYvk0Rj0y7WLkYODjYBbYkt
	O7xAakQEFCQ29z5jBbGZBY6xSCyakg9iCws4SBw4c4oZxGYRUJW4sHsm2C5eAVeJ7ifzGCF2
	KUp0P5vANoGRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkJD9soNx8TGrQ4wCHIxK
	PLwbFH8GCbEmlhVX5h5ilOBgVhLhPWsHFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC4ycnlc0J8
	8JT/fie+dje6Hbt8TuCJ1CGWT6GPSib95y306uvPzDO3EORbptCnpC2zIvdmjr9WnJ6m0DOn
	zbevrHfS2T6R6aGFOENarsaC+gzNF1ee7dYw2nCh+1jA0aqbfpUVT2/+lGkW2cSx5VYHx/UU
	yf0eic03jd9pcAkkFMj5lS7h+qvEUpyRaKjFXFScCADAHvx3NwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to implementation of exynos_boot_secondary function
only one secondary core boots on Exynos SoC's.

Two new functions added to power up and power down secondary cores:

static int exynos_core_power_up(unsigned int cpu);
static int exynos_core_power_down(unsigned int cpu).

Tested on linux kernel v3.14-rc2.

Comments and additions would be appreciated.
Thank you.
	Tarek.

Tarek Dakhran (1):
  ARM: EXYNOS: enable boot all secondary cpus instead 2

 arch/arm/mach-exynos/hotplug.c  |   11 ++++--
 arch/arm/mach-exynos/platsmp.c  |   75 ++++++++++++++++++++++++++++-----------
 arch/arm/mach-exynos/regs-pmu.h |    5 +++
 3 files changed, 68 insertions(+), 23 deletions(-)

-- 
1.7.10.4

