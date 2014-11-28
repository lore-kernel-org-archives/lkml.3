Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaK1B1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:27:07 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54902 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaK1B1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:27:04 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 0/7] Pinctrl support for Zynq
Date: Thu, 27 Nov 2014 17:26:26 -0800
Message-Id: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here is v2 of this series. On the functional side, adding the support
for USB mux groups is probably the biggest change. Most other changes
are mostly cosmetic (typos, function names, documentation, ...).
More detailed changelogs are included with the respective patches.

Regarding DT, I separated pinconf from pinmux nodes and updated
documentation accordingly to enforce that separation.
The parser, though, still handles everything in order to not break
backwards compatibility.

And finally, as Linus requested, I patched one of the Qualcomm drivers
to use the features added in 'pinctrl: pinconf-generic: Allow driver to
specify DT params'. I don't have that HW so, that is compile tested only
and may take some more work to work on HW.

So much for the changes. What didn't change? I left the parts that have
been described as "kludgy" as they were, in order to maintain backwards
compatibility and not break current users of pinconf-generic
functionality.

The audience is again limited to pinctrl stakeholders.

	Thanks,
	Sören

Soren Brinkmann (7):
  pinctrl: pinconf-generic: Infer map type from DT property
  pinctrl: pinconf-generic: Allow driver to specify DT params
  pinctrl: zynq: Document DT binding
  pinctrl: Add driver for Zynq
  ARM: zynq: Enable pinctrl
  ARM: zynq: DT: Add pinctrl information
  pinctrl: qcom-spmi-gpio: Migrate to pinconf-generic

 .../bindings/pinctrl/xlnx,zynq-pinctrl.txt         |  104 ++
 arch/arm/boot/dts/zynq-7000.dtsi                   |    8 +-
 arch/arm/boot/dts/zynq-zc702.dts                   |  181 +++
 arch/arm/boot/dts/zynq-zc706.dts                   |  152 +++
 arch/arm/mach-zynq/Kconfig                         |    2 +
 drivers/pinctrl/Kconfig                            |    8 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |    2 +-
 drivers/pinctrl/pinconf-generic.c                  |  199 ++--
 drivers/pinctrl/pinconf.c                          |    4 +-
 drivers/pinctrl/pinconf.h                          |   22 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |    2 +-
 drivers/pinctrl/pinctrl-tz1090-pdc.c               |    2 +-
 drivers/pinctrl/pinctrl-tz1090.c                   |    2 +-
 drivers/pinctrl/pinctrl-zynq.c                     | 1176 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |  125 +--
 drivers/pinctrl/sh-pfc/pinctrl.c                   |    2 +-
 include/linux/pinctrl/pinconf-generic.h            |   25 +
 include/linux/pinctrl/pinctrl.h                    |    9 +
 19 files changed, 1804 insertions(+), 222 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-zynq.c

-- 
2.1.3.1.ge241007

