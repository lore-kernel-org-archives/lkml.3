Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaIUOL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 10:11:29 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48343 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaIUOL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 10:11:26 -0400
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
From: Benoit Masson <benoitm@perenite.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Sun, 21 Sep 2014 16:11:23 +0200
Message-ID: <-7443282711873112734@unknownmsgid>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>
> Guys,
Hi
>
> this is a patch set preparing barebox support for ix4-300d. As usual,
> I stumbled upon a few nice-to-haves before actually touching ix4-300d
> dts. As it is a mach-mvebu thing, I just added the related mailing
> lists instead of each of the DT maintainers.
>
> First 5 patches consolidate SoC-specific pinctrl nodes to one common
> node in armada-xp.dtsi, compatible overwrites for each SoC, and node
> alias usage for each board. Also, ge{0,1} pinctrl settings are moved
> to the common node from one board specific node.
>
> Last 3 patches then use that ge{0,1} pinctrl settings on ix4-300d which
> is vital for bootloader init. During exploration of ix4-300d, I also
> found a i2c eeprom that has not been added to the dts, yet. Finally,
> there is only one 74hc595 on ix4 mainboard while dts property is set
> for two.
>
> I cannot recall in detail what is on that eeprom, but IIRC it is nothing
> important. Some reg,addr pairs for some init stuff that should have
> already been done by stock u-boot. Anyway, adding the node will do no
> harm.
>
> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
> a hurry. I only compile tested this, so a formal Tested-by from Benoit
> for the ix4 and any other Armada XP board would be great.
I'm not sure what to test since I only receive some patch from the
series of 8. Should I get all 8 or only those you sent me. I'll be
able to test during next week.
>
> Sébastien
>
Thanks benoît
>
> Sebastian Hesselbarth (8):
>  ARM: mvebu: armada-xp: Consolidate pinctrl node
>  ARM: mvebu: armada-xp: Add node alias to pinctrl and add base address
>  ARM: mvebu: armada-xp: Use pinctrl node alias
>  ARM: mvebu: armada-xp: Move GE0/1 pinctrl settings for RGMII
>  ARM: mvebu: armada-xp: Add GE0 pinctrl settings for GMII
>  ARM: mvebu: armada-xp: Add RGMII pinctrl to Lenovo ix4-300d
>  ARM: mvebu: armada-xp: Add I2C eeprom on Lenovo ix4-300d
>  ARM: mvebu: armada-xp: Fix 74hc595 count for Lenovo ix4-300d
>
> arch/arm/boot/dts/armada-xp-axpwifiap.dts        |  58 +++-----
> arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts  |  73 +++++-----
> arch/arm/boot/dts/armada-xp-mv78230.dtsi         |  15 +--
> arch/arm/boot/dts/armada-xp-mv78260.dtsi         |  15 +--
> arch/arm/boot/dts/armada-xp-mv78460.dtsi         |  15 +--
> arch/arm/boot/dts/armada-xp-netgear-rn2120.dts   | 164 +++++++++++------------
> arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  14 +-
> arch/arm/boot/dts/armada-xp.dtsi                 |  37 +++++
> 8 files changed, 202 insertions(+), 189 deletions(-)
>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Benoit Masson <yahoo@perenite.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> --
> 2.0.0
>
