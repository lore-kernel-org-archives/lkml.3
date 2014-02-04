Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaBDTYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:24:40 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:58406 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbaBDTYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:24:38 -0500
Subject: [PATCH v2 0/6] ARM: sunxi: Add driver for SD/MMC hosts found on
 allwinner sunxi SOCs 
To: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Date: Tue, 04 Feb 2014 20:24:13 +0100
Message-ID: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
The following patchset adds support for the SD/MMC host found in the Allwinner SoCs.
It contains all the necessary modifications for clock environment and also the device
tree script modification which add it to all the boards using it.
The clock environment function needed for phase offset configuration has
been proposed and implemented by Emilio.
This patchset is the second attempt to send this driver upstream.
I'm looking forward to the acceptance of this patchset into mainline.

best regards
David

---

David Lanzendörfer (4):
      ARM: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi SoCs
      ARM: dts: sun7i: Add support for mmc
      ARM: dts: sun4i: Add support for mmc
      ARM: dts: sun5i: Add support for mmc

Emilio López (1):
      clk: sunxi: Implement MMC phase control

Hans de Goede (1):
      ARM: sunxi: clk: export clk_sunxi_mmc_phase_control


 arch/arm/boot/dts/sun4i-a10-a1000.dts            |    8 
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts       |    8 
 arch/arm/boot/dts/sun4i-a10.dtsi                 |   54 +
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts |   30 +
 arch/arm/boot/dts/sun5i-a10s.dtsi                |   44 +
 arch/arm/boot/dts/sun5i-a13-olinuxino-micro.dts  |   15 
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts        |   15 
 arch/arm/boot/dts/sun5i-a13.dtsi                 |   37 +
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts      |    8 
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts       |    8 
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts  |   23 +
 arch/arm/boot/dts/sun7i-a20.dtsi                 |   61 ++
 drivers/clk/sunxi/clk-sunxi.c                    |   35 +
 drivers/mmc/host/Kconfig                         |    8 
 drivers/mmc/host/Makefile                        |    2 
 drivers/mmc/host/sunxi-mci.c                     |  848 ++++++++++++++++++++++
 drivers/mmc/host/sunxi-mci.h                     |  239 ++++++
 include/linux/clk/sunxi.h                        |   22 +
 18 files changed, 1465 insertions(+)
 create mode 100644 drivers/mmc/host/sunxi-mci.c
 create mode 100644 drivers/mmc/host/sunxi-mci.h
 create mode 100644 include/linux/clk/sunxi.h

-- 
Signature
