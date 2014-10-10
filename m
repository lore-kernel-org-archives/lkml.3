Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaJJV0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:26:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58937 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJJV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:26:23 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/6] add basic rk3288 smp support
Date: Fri, 10 Oct 2014 14:26:04 -0700
Message-Id: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 is qual-core CPU Soc, we enable the smp in this patch.

In version 3 we use regmap and pmu syscon for cpu power on/off.
This should be work after Pankaj Dubey's patch applied:
(https://lkml.org/lkml/2014/9/30/156)

Changes in v3:
- add pmu regmap patches in version 3
- use one ops and secondary_starup for all rockchip SOCs
- pick back the power domain operation for cpu hotplug
- add compitable name "rockchip,rk3288-pmu-sram" for pmu-intmem

Changes in v2:
- use rk3288_boot_secondary instead ofsmp_boot_secondary
- discards the power domain operation
- handle the per cpu starup when actived by 'sev'
- adjust the alignment

Kever Yang (6):
  ARM: rockchip: convert to regmap and use pmu syscon if available
  ARM: dts: rockchip: use the same pmu node name as before
  ARM: rockchip: add option to access the pmu via a phandle in
    smp_operations
  ARM: dts: rockchip: add pmu references to cpus nodes
  ARM: rockchip: add basic smp support for rk3288
  ARM: dts: rockchip: add intmem node for rk3288 smp support

 arch/arm/boot/dts/rk3288.dtsi    |  21 ++++-
 arch/arm/mach-rockchip/headsmp.S |   5 +-
 arch/arm/mach-rockchip/platsmp.c | 188 +++++++++++++++++++++++++++++----------
 3 files changed, 167 insertions(+), 47 deletions(-)

-- 
1.9.1

