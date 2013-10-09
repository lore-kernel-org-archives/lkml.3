Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3JIV3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:29:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48491 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab3JIV3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:29:43 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V6 00/15] ARM: OMAP3+: support cpufreq-cpu0 for device tree boot
Date: Wed, 9 Oct 2013 16:28:49 -0500
Message-ID: <1381354144-7134-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The series is based on Tero's V8 of patches[1] - enables the use of
cpufreq-cpu0 generic driver for all OMAP and related derivatives.

I will stop copy pasting the series complete history and point at [2].

Main changes since V5:
- no more clock driver as part of this series[3] - instead depend on clock
  conversion[1].
- added DRA7/OMAP5

Notes:
- i have organized the series such that
  * patches 1-6 could go to Tony/Kevin/Paul trees
  * Dts series is further split up given continued uncertaininty of v8 clock dts
    nodes into two sets
	- patches 7-10 are based on Benoit's for_13/dts branch and can apply
	  there independently.
	- patches 11-15 are dependent on 7-10 patches + clock nodes being
	  available.
- Given the uncertainity with clock nodes, I recommend we get rid of the
  dependencies (1-10) and decide on clock nodes once the story is clearer.
	- if we feel I should squash up clock nodes 9+14, 10+15, I can do that
	  as well.

Series is built on top of V3.12-rc4 + the following maintainer tree merges
	git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt for_3.13/dts
	git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tag 'fixes-against-v3.12-rc3-take2' and omap-for-v3.13/soc branch
Available here: https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v6

Test Script: http://pastebin.pandaboard.org/index.php/view/64137893

Test-log:
BeagleBoard-XM (OMAP36xx): http://pastebin.pandaboard.org/index.php/view/64740438
PandaBoard-ES (OMAP4460): http://pastebin.pandaboard.org/index.php/view/13763478
BeagleBone-Black(AM335x): http://pastebin.pandaboard.org/index.php/view/46018613
OMAP5uEVM (OMAP5432): http://pastebin.pandaboard.org/index.php/view/54353148
DRA7-EVM (DRA7xx): http://pastebin.pandaboard.org/index.php/view/70955776

J Keerthy (5):
  ARM: dts: dra7-evm: add smps123 supply for CPU
  ARM: dts: OMAP5: Add CPU OPP table
  ARM: dts: DRA7: Add CPU OPP table
  ARM: dts: OMAP5: add clock nodes for CPU
  ARM: dts: DRA7: add clock nodes for CPU

Nishanth Menon (10):
  ARM: OMAP3+: do not register non-dt OPP tables for device tree boot
  ARM: OMAP2+: AM33XX: add lateinit hook for calling pm late init
  ARM: OMAP2+: AM43XX: add lateinit hook for calling pm late init
  ARM: OMAP2+: OMAP5: add lateinit hook for calling pm late init
  ARM: OMAP2+: DRA7: add lateinit hook for calling pm late init
  ARM: OMAP3+: use cpu0-cpufreq driver in device tree supported boot
  ARM: dts: omap5-uevm: add smps123 supply for CPU
  ARM: dts: OMAP3: add clock nodes for CPU
  ARM: dts: OMAP4: add clock nodes for CPU
  ARM: dts: AM33XX: add clock nodes for CPU

 arch/arm/boot/dts/am33xx.dtsi       |    4 ++++
 arch/arm/boot/dts/dra7-evm.dts      |    4 ++++
 arch/arm/boot/dts/dra7.dtsi         |   13 ++++++++++++-
 arch/arm/boot/dts/omap3.dtsi        |    5 +++++
 arch/arm/boot/dts/omap4.dtsi        |    5 +++++
 arch/arm/boot/dts/omap5-uevm.dts    |    4 ++++
 arch/arm/boot/dts/omap5.dtsi        |   15 ++++++++++++++-
 arch/arm/mach-omap2/board-generic.c |    4 ++++
 arch/arm/mach-omap2/common.h        |    4 ++++
 arch/arm/mach-omap2/io.c            |   24 ++++++++++++++++++++++++
 arch/arm/mach-omap2/opp.c           |    4 ++++
 arch/arm/mach-omap2/pm.c            |   12 +++++++++---
 12 files changed, 93 insertions(+), 5 deletions(-)

[1] http://marc.info/?t=138133284200006&r=1&w=2
[2] http://marc.info/?l=linux-arm-kernel&m=136804009618594&w=2
[3] http://marc.info/?t=136804008400001&r=1&w=2

Regards,
Nishanth Menon
-- 
1.7.9.5

