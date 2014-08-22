Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbaHVOFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:05:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43961 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbaHVODB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:03:01 -0400
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 00/10] ARM: OMAP5 / DRA7: Add framework for suspend and cpuidle
Date: Fri, 22 Aug 2014 09:02:24 -0500
Message-ID: <1408716154-26101-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series are various fixes and improvements for
supporting suspend-to-ram. This depends on the following for basic functionality:
series 1/6 where powerdomain fixes were involved.
This will at least allow wake up from an internal source such as from a wakeup timer:
For example with https://github.com/nmenon/linux-2.6-playground/commit/92e5e7407aa707ad6be8ae3b5bf21cfc741daab6

pinctrl series allows for external wakeup event sources like pushbutton etc.

NOTE: OMAP5 and DRA7 definitions of power states and suspend targets
are almost identical (except for core power domain target state as part of suspend).

NOTE: This also needs missing hwmod and dts entries for various
peripherals that will eventually arrive over a period of time.

This is part 5/6 series which actually enables framework for
suspend-to-ram and cpuidle for OMAP5 and DRA7

Each of series is based on v3.17-rc1 and this specific series is available:
weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/powerdomain-fixes

git repo: https://github.com/nmenon/linux-2.6-playground.git push/v3.17/powerdomain-fixes

An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework

Example test log:
DRA7 based BeagleBoard X15: http://slexy.org/view/s2jgsH8bos (wakeup from external using pinctrl wakeup).
OMAP5UEVM: http://slexy.org/view/s20MiQJQIq (external pinctrl not hooked)

Rajendra Nayak (3):
  ARM: OMAP5 / DRA7: PM: Avoid all SAR saves
  ARM: OMAP5 / DRA7: Enable CPU RET on suspend
  ARM: DRA7: Add hook in SoC initcalls to enable pm initialization

Santosh Shilimkar (7):
  ARM: OMAP5 / DRA7: PM: Update CPU context register offset
  ARM: OMAP5 / DRA7: PM: Set MPUSS-EMIF clock-domain static dependency
  ARM: OMAP5 / DRA7: PM / wakeupgen: Enables ES2 PM mode by default
  ARM: OMAP5 / DRA7: PM: Enable Mercury retention mode on CPUx
    powerdomains
  ARM: OMAP5 / DRA7: PM: Provide a dummy startup function for CPU
    hotplug
  ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
  ARM: OMAP5: Add hook in SoC initcalls to enable pm initialization

 arch/arm/mach-omap2/common.h              |    2 +-
 arch/arm/mach-omap2/cpuidle44xx.c         |   82 ++++++++++++++++++++++-
 arch/arm/mach-omap2/io.c                  |    6 ++
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |  102 ++++++++++++++++++++---------
 arch/arm/mach-omap2/omap-secure.h         |    1 +
 arch/arm/mach-omap2/omap-wakeupgen.c      |   19 +++++-
 arch/arm/mach-omap2/omap-wakeupgen.h      |    1 +
 arch/arm/mach-omap2/pm44xx.c              |   47 +++++++++++--
 8 files changed, 220 insertions(+), 40 deletions(-)

-- 
1.7.9.5

