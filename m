Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3IZRVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:21:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3IZRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:21:08 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 0/5] ARM: shmobile: CPUFreq support on Lager
Date: Thu, 26 Sep 2013 19:20:55 +0200
Message-Id: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:GbmEfQw1/Sdk3wLwbp+xyIDlsXe9mS1Bw5n4c3pcBzs
 sOZ0hr7IpWKqkxywP0Oa1HLKQuYH+YfFQUERLHGto22jeooFYV
 uqrcoOcmLr7GXqd/mINHsV9lF45CmO7rd241oLe6RU8RLosTOW
 4/u9rW5MsfEtHaaNezVhTpQdM/b+09go0t5qkN6WsyMNNLcaE8
 2H4FZKggDi9GZ9QAVZLHYCPCP+s+rybbcefcJWHUFounQDRSgx
 7imDuJIg/h2+luL6VuCTukt/vWpqo7oZUNku1CC8vmwyf5skve
 RqfR53d/mwnqObnI67B73RB1WK4OYIvTq7QBeySMP1SkMyhgB6
 U9e6pWKVrDIVWj2ZGk23XrPKzRzfbmPAZr04vJ0duSDOW+REYX
 2OSSDv2bjr06Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lager a da9210 regulator is used to supply DVFS power to the SoC. This
patch series adds I2C and Z-clock support on r8a7790 and CPUFreq support
for the Lager board. Please note, that patch 4/4 is an RFC as explained
inline.

Developed on top of today's

    git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git    devel

plus i2c-rcar patches from my earlier patch series

[PATCH v2 0/5] i2c: rcar: Device Tree support and clock improvements

and the "sh-pfc: r8a7790: Add I2C pin groups and functions" patch from
Ulrich Hecht.

All changes since v1 are noted in respective patches. They all are trivial,
still as soon as test hardware is available, it would be good to run-time
test this version too.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (5):
  pinctrl: sh-pfc: r8a7790: add pin definitions for the I2C3 interface
  ARM: shmobile: r8a7790: add I2C clocks and aliases for the DT mode
  ARM: shmobile: r8a7790: add I2C DT nodes
  ARM: shmobile: r8a7790: add CPUFreq clock support
  ARM: shmobile: lager: (DEVEL) add CPUFreq support

 arch/arm/boot/dts/r8a7790-lager-reference.dts  |   33 +++++
 arch/arm/boot/dts/r8a7790.dtsi                 |   40 ++++++
 arch/arm/mach-shmobile/Kconfig                 |    2 +
 arch/arm/mach-shmobile/board-lager-reference.c |    4 +-
 arch/arm/mach-shmobile/clock-r8a7790.c         |  160 ++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c           |   28 ++++
 6 files changed, 266 insertions(+), 1 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
