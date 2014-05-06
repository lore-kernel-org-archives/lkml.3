Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaEFNY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:24:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54107 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaEFNYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:24:55 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mturquette@linaro.org>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ldewangan@nvidia.com>,
        <linux-doc@vger.kernel.org>, <nm@ti.com>, <robh+dt@kernel.org>
Subject: [PATCH v2 0/2] clk: Support for Palmas clk32kg and clk32kgaudio clocks
Date: Tue, 6 May 2014 16:24:43 +0300
Message-ID: <1399382685-14781-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v1:
- binding documentation and driver has been separated based on Nishanth Menon's
  comment

v1 of the driver can be found:
https://lkml.org/lkml/2014/4/3/104

Palmas class of devices can provide 32K clock(s) to be used by other devices
on the board. Depending on the actual device the provided clocks can be:
CLK32K_KG and CLK32K_KGAUDIO
or only one:
CLK32K_KG (TPS659039 for example)

Use separate compatible flags for the two 32K clock.
A system which needs or have only one of the 32k clock from
Palmas will need to add node(s) for each clock as separate section
in the dts file.
The two compatible property is:
"ti,palmas-clk32kg" for clk32kg clock
"ti,palmas-clk32kgaudio" for clk32kgaudio clock

Apart from the register control of the clocks - which is done via
the clock API there is a posibility to enable the external sleep
control. In this way the clock can be enabled/disabled on demand by the
user of the clock.

Regards,
Peter
---
Peter Ujfalusi (2):
  dt/bindings: Binding documentation for Palmas clk32kg and clk32kgaudio
    clocks
  clk: Add driver for Palmas clk32kg and clk32kgaudio clocks

 .../bindings/clock/clk-palmas-clk32kg-clocks.txt   |  35 +++
 drivers/clk/Kconfig                                |   7 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-palmas.c                           | 307 +++++++++++++++++++++
 include/dt-bindings/mfd/palmas.h                   |  18 ++
 5 files changed, 368 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt
 create mode 100644 drivers/clk/clk-palmas.c
 create mode 100644 include/dt-bindings/mfd/palmas.h

-- 
1.9.2

