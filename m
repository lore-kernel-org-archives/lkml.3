Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbbAIPoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:44:16 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57387 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbbAIPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:44:10 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 0/7] pinctrl support for Zynq
Date: Fri,  9 Jan 2015 07:43:44 -0800
Message-Id: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.1.1.gb42cc81
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I rebased my branch onto your current pinctrl/devel. Other than that
this should be exactly what has been sent out as v3. This time I'll use
the gmail SMTP again, which hopefully resolves the encoding issue.

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
 include/linux/pinctrl/pinconf-generic.h            |   29 +
 include/linux/pinctrl/pinctrl.h                    |    9 +
 19 files changed, 1808 insertions(+), 222 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/xlnx,zynq-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-zynq.c

-- 
2.2.1.1.gb42cc81

