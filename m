Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaIPKq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:46:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45323 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaIPKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:46:57 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>, devicetree@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/3] add basic rk3288 smp support
Date: Tue, 16 Sep 2014 18:44:27 +0800
Message-Id: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 is qual-core CPU Soc, we need to enable the smp.
This patchset works with either arch-timer use the phisical counter
in kernel or the firmware initialize the arch-timer virtual counter
offset and use virtual counter in kernel.

Changes in v2:
- add documentation
- use rk3288_boot_secondary instead ofsmp_boot_secondary
- discards the power domain operation
- handle the per cpu starup when actived by 'sev'
- adjust the alignment

Kever Yang (3):
  Documentation: dt-bindings: add dt binding info for rk3288-smp
  ARM: rockchip: add basic smp support for rk3288
  ARM: dts: add intmem node for rk3288 smp support

 Documentation/devicetree/bindings/arm/cpus.txt |  1 +
 arch/arm/boot/dts/rk3288.dtsi                  | 18 ++++++++
 arch/arm/mach-rockchip/core.h                  |  1 +
 arch/arm/mach-rockchip/headsmp.S               | 14 ++++++
 arch/arm/mach-rockchip/platsmp.c               | 63 +++++++++++++++++++++++---
 5 files changed, 91 insertions(+), 6 deletions(-)

-- 
1.9.1

