Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaJMUMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:12:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50045 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMUMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:12:07 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 0/6] add basic rk3288 smp support
Date: Mon, 13 Oct 2014 13:11:56 -0700
Message-Id: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rk3288 is qual-core CPU Soc, we enable the smp in this patch.

In version 3 we use regmap and pmu syscon for cpu power on/off.
This should be work after Pankaj Dubey's patch applied:
"syscon: Decouple syscon interface from platform devices"
(https://lkml.org/lkml/2014/9/30/156)

Changes in v4:
- add rockchip,pmu property into cpus.txt
- merge patch "fix up rk3288 smp cpu hotplug" into this patch
- remove "rockchip,rk3288-pmu-sram" because we don't use it here
- remove "[PATCH v3 2/6] ARM: dts: rockchip: use the same pmu node"

Changes in v3:
- add pmu regmap patches in version 3
- use one ops and secondary_starup for all rockchip SOCs
- pick back the power domain operation for cpu hotplug
- remove 'enable-method' from this patch
- add compitable name "rockchip,rk3288-pmu-sram" for pmu-intmem

Changes in v2:
- use rk3288_boot_secondary instead ofsmp_boot_secondary
- discards the power domain operation
- handle the per cpu starup when actived by 'sev'
- adjust the alignment

Kever Yang (6):
  ARM: rockchip: convert to regmap and use pmu syscon if available
  ARM: rockchip: add option to access the pmu via a phandle in
    smp_operations
  ARM: dts: rockchip: add pmu references to cpus nodes
  ARM: rockchip: add basic smp support for rk3288
  ARM: dts: rockchip: add intmem node for rk3288 smp support
  ARM: dts: rockchip: add reset for CPU nodes

 Documentation/devicetree/bindings/arm/cpus.txt |   9 +
 arch/arm/boot/dts/rk3288.dtsi                  |  18 ++
 arch/arm/mach-rockchip/headsmp.S               |   5 +-
 arch/arm/mach-rockchip/platsmp.c               | 223 ++++++++++++++++++++-----
 4 files changed, 211 insertions(+), 44 deletions(-)

-- 
1.9.1

