Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaKCTGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:06:01 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62920 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaKCTF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:05:58 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org
Subject: [PATCH 0/7] Pinctrl support for Zynq
Date: Mon,  3 Nov 2014 11:05:24 -0800
Message-Id: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think we're getting closer. I re-organized the series to illustrate
the dependencies better instead of my development process. The
respective patches have some more details and also changelog.

The first three patches essentially extend pinconf-generic by:
 - properly support and distinguish between the 'groups' and 'pins' DT
   properties
 - option for drivers to use the pinconf-generic infrastructure with the
   generic + driver-specific DT parameters

Doing so, resulted in one change in the API. I fixed up all the
call-sites I found, I hope.

The last four patches are the platform specific stuff. The actual
driver, DT update, documentation, etc.
The DT binding have been revised another time to conform better with how
the generic parameters are defined.

Since the Zynq-specific parts rely on the pinconf-generic changes, I
keep the audience to pinctrl stakeholders. Once there is an agreement on
those patches I will post the Zynq patches on the relevant lists.

	Thanks,
	Soren

Soren Brinkmann (7):
  pinctrl: pinconf-generic: Declare dt_params/conf_items const
  pinctrl: pinconf-generic: Infer map type from DT property
  pinctrl: pinconf-generic: Allow driver to specify DT params
  pinctrl: zynq: Document DT binding
  pinctrl: Add driver for Zynq
  ARM: zynq: Enable pinctrl
  ARM: zynq: DT: Add pinctrl information

 .../bindings/pinctrl/xlnx,zynq-pinctrl.txt         |   90 ++
 arch/arm/boot/dts/zynq-7000.dtsi                   |    8 +-
 arch/arm/boot/dts/zynq-zc702.dts                   |  143 +++
 arch/arm/boot/dts/zynq-zc706.dts                   |  120 ++
 arch/arm/mach-zynq/Kconfig                         |    2 +
 drivers/pinctrl/Kconfig                            |    8 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |    6 +-
 drivers/pinctrl/pinconf-generic.c                  |  192 ++--
 drivers/pinctrl/pinconf.h                          |    1 +
 drivers/pinctrl/pinctrl-rockchip.c                 |    2 +-
 drivers/pinctrl/pinctrl-tz1090-pdc.c               |    2 +-
 drivers/pinctrl/pinctrl-tz1090.c                   |    2 +-
 drivers/pinctrl/pinctrl-zynq.c                     | 1164 ++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pinctrl.c                   |    2 +-
 include/linux/pinctrl/pinconf-generic.h            |   25 +
 include/linux/pinctrl/pinctrl.h                    |    8 +
 17 files changed, 1683 insertions(+), 93 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-zynq.c

-- 
1.9.1

