Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaHRIdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:33:23 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41462 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaHRIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:33:20 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mike Turquette <mturquette@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v9 0/6] Add Maxim 77802 clocks support
Date: Mon, 18 Aug 2014 10:32:58 +0200
Message-Id: <1408350784-15577-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

This series add support for the clocks present in the Maxim
77802 Power Managment IC. Previously, the series was part
of a bigger one [0] that aimed to add support for all the
devices in the max77802 PMIC. But now the Maxim 77802 PMIC
dependencies were already merged for 3.17 so the series can
be split and each driver can go through the relevant tree.

The support needed for the clocks in the max77802 is very
similar to the one for the ones in the max77686 so a generic
driver was added that allows to remove the duplicated code
for both drivers. Patch 01/06 adds a dt binding include that
can be used to share the max77686 clocks between the driver
and the DTS files. Patch 02/06 adds the generic clock driver
for maxim pmic clocks and patch 03/06 converts the existing
max77686 clock driver to the generic one. Patch 04/06 adds
some improvements to the max77686 clock driver DT binding.
Patch 05/06 adds the max77802 clock driver and finally patch
06/06 adds the DT binding documentation for this driver.

I kept the version numbering from the old series so this is
version 9 although there were no changes on the max77802 clock
driver since v5 of the old series and all the patches had been
already acked by you so I hope there won't be issues to get
them merged.

The series were tested on an Exynos5250 Snow (max77686) and
Exynos5420 Peach Pit (max77802) machines and applies cleanly
to both 3.17-rc1 and today's linux-next (20140818).

Javier Martinez Canillas (6):
  clk: max77686: Add DT include for MAX77686 PMIC clock
  clk: Add generic driver for Maxim PMIC clocks
  clk: max77686: Convert to the generic max clock driver
  clk: max77686: Improve Maxim 77686 PMIC clocks binding
  clk: Add driver for Maxim 77802 PMIC clocks
  clk: max77802: Add DT binding documentation

 .../devicetree/bindings/clock/maxim,max77686.txt   |  16 +-
 .../devicetree/bindings/clock/maxim,max77802.txt   |  44 +++++
 drivers/clk/Kconfig                                |  11 ++
 drivers/clk/Makefile                               |   2 +
 drivers/clk/clk-max-gen.c                          | 192 +++++++++++++++++++++
 drivers/clk/clk-max-gen.h                          |  32 ++++
 drivers/clk/clk-max77686.c                         | 183 +-------------------
 drivers/clk/clk-max77802.c                         |  98 +++++++++++
 include/dt-bindings/clock/maxim,max77686.h         |  23 +++
 include/dt-bindings/clock/maxim,max77802.h         |  22 +++
 10 files changed, 445 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
 create mode 100644 drivers/clk/clk-max-gen.c
 create mode 100644 drivers/clk/clk-max-gen.h
 create mode 100644 drivers/clk/clk-max77802.c
 create mode 100644 include/dt-bindings/clock/maxim,max77686.h
 create mode 100644 include/dt-bindings/clock/maxim,max77802.h

Best regards,
Javier

