Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab3JPPmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:42:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43910 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760800Ab3JPPjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:39:41 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V7 0/8] ARM: OMAP3+: support cpufreq-cpu0 for device tree boot
Date: Wed, 16 Oct 2013 10:39:00 -0500
Message-ID: <1381937948-27057-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series enables the use of cpufreq-cpu0 generic driver for all
OMAP and related derivatives. Only patch#8 in the series, which
introduces CPU clock nodes, depends on Tero's V8 patch series for clock
nodes[1]

I will stop copy pasting the series complete history and point at [2].

Main changes since V6[3]:
- squashed patches for a minimal set
- i have organized the series such that 1 to 7 can immediately be merged
  if desired:
	- patches 1,2,3 can go to Tony's omap-for-v3.13/quirk [4]
	- patches 4-7 can go to Benoit's for_3.13/dts [5]
	- patch 8 needs to depend on [1] and should eventually go to [5]

NOTES: obviously without clock nodes cpufreq will not function.

Test Script: http://pastebin.com/VvJPjsne

Test-log:
BeagleBoard-XM (OMAP36xx): http://pastebin.com/XZDNaHPf
PandaBoard-ES (OMAP4460): http://pastebin.com/qQCmA2ng
BeagleBone-Black(AM335x): http://pastebin.com/98FX4uYW
OMAP5uEVM (OMAP5432): http://pastebin.com/NXj3L636
DRA7-EVM (DRA7xx): http://pastebin.com/0kKT3TXy

J Keerthy (3):
  ARM: dts: dra7-evm: add smps123 supply for CPU
  ARM: dts: OMAP5: Add CPU OPP table
  ARM: dts: DRA7: Add CPU OPP table

Nishanth Menon (5):
  ARM: OMAP3+: do not register non-dt OPP tables for device tree boot
  ARM: OMAP2+: add missing lateinit hook for calling pm late init
  ARM: OMAP3+: use cpu0-cpufreq driver in device tree supported boot
  ARM: dts: omap5-uevm: add smps123 supply for CPU
  ARM: dts: OMAP3: add clock nodes for CPU

[1] http://marc.info/?t=138133284200006&r=1&w=2
[2] http://marc.info/?l=linux-arm-kernel&m=136804009618594&w=2
[3] http://marc.info/?l=devicetree&m=138135419203492&w=2
[4] https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/log/?h=omap-for-v3.13/quirk

 arch/arm/boot/dts/am33xx.dtsi       |    4 ++++
 arch/arm/boot/dts/dra7-evm.dts      |    4 ++++
 arch/arm/boot/dts/dra7.dtsi         |   13 ++++++++++++-
 arch/arm/boot/dts/omap3.dtsi        |    5 +++++
 arch/arm/boot/dts/omap4.dtsi        |    5 +++++
 arch/arm/boot/dts/omap5-uevm.dts    |    4 ++++
 arch/arm/boot/dts/omap5.dtsi        |   15 ++++++++++++++-
 arch/arm/mach-omap2/board-generic.c |    4 ++++
 arch/arm/mach-omap2/common.h        |    4 ++++
 arch/arm/mach-omap2/io.c            |   20 ++++++++++++++++++++
 arch/arm/mach-omap2/opp.c           |    4 ++++
 arch/arm/mach-omap2/pm.c            |   12 +++++++++---
 12 files changed, 89 insertions(+), 5 deletions(-)

Regards,
Nishanth Menon
-- 
1.7.9.5

