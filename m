Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaHFNrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:47:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaHFNrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:47:35 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <airlied@linux.ie>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <bcousson@baylibre.com>
CC: <tony@atomide.com>, <broonie@kernel.org>,
        <liam.r.girdwood@linux.intel.com>, <peter.ujfalusi@ti.com>,
        <detheridge@ti.com>, <zonque@gmail.com>, <t-kristo@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 0/9] Beaglebone-Black HDMI audio
Date: Wed, 6 Aug 2014 16:47:15 +0300
Message-ID: <cover.1407332062.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code has a functional dependency to:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg108199.html

Without the above patch the audio card does not probe.

The code has been rebased on top of Linux 3.16 merged with 
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next
with http://www.mail-archive.com/linux-omap@vger.kernel.org/msg108199.html
cherry-picked on top.

All patches have gone trough some cleaning up since the RFC version of
these patches over half a year ago.

Jyri Sarha (9):
  ASoC: mcasp: Fix implicit BLCK divider setting
  clk: add gpio controlled clock
  drm/tilcdc: Add I2S HDMI audio config for tda998x
  ASoC: davinci-evm: HDMI audio support for TDA998x trough McASP I2S
    bus
  ASoC: davinci: HDMI audio build for AM33XX and TDA998x
  ARM: dts: am33xx: Add external clock provider
  ARM: dts: am335x-boneblack: Add HDMI audio support
  ARM: OMAP2+: omap2plus_defconfig: TDA998X HDMI trough tilcdc,slave
  ARM: OMAP2+: omap2plus_defconfig: Enable BeagleBone Black HDMI audio
    support

 .../devicetree/bindings/clock/gpio-clock.txt       |   21 ++
 .../bindings/sound/davinci-evm-audio.txt           |    4 +-
 arch/arm/boot/dts/am335x-boneblack.dts             |   54 +++++
 arch/arm/boot/dts/am33xx.dtsi                      |   10 +
 arch/arm/configs/omap2plus_defconfig               |    5 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-gpio.c                             |  206 ++++++++++++++++++++
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   24 ++-
 include/linux/clk-provider.h                       |   23 +++
 sound/soc/davinci/Kconfig                          |   12 ++
 sound/soc/davinci/davinci-evm.c                    |   82 +++++++-
 sound/soc/davinci/davinci-mcasp.c                  |   14 +-
 12 files changed, 449 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/gpio-clock.txt
 create mode 100644 drivers/clk/clk-gpio.c

-- 
1.7.9.5

