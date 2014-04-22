Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaDVNMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:12:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48433 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220AbaDVNMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:47 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 00/11] ARM: at91: rework main and slow clk implementation
Date: Tue, 22 Apr 2014 15:12:29 +0200
Message-Id: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series introduce the real clock model (as described in atmel datasheets)
for slow and main clocks.

The modifications introduced by this series break the DT compat, but, as the
at91 CCF based implementation is pretty new (introduced in 3.14 only for sama5
eval boards) I think it won't impact a lot of users.

Nicolas, Mike, if this series is accepted, I'd like to get it merged as soon as
possible to prevent other developpers from using a deprecated DT binding.
Moreover, I think this series should go through the same path for both clk
and DT changes (whatever path is chosen: either at91 or clk tree) because the
changes are tightly coupled.

Best Regards,

Boris

Changes since v2:
 - add missing compatible in pmc.c
 - fix sam9261 slow clock definition
 - move xtal nodes out of /clocks node
 - fix DT bindings documentation
 - fix main RC oscillator initilization

Changes since v1:
- fix sam9rl main clk definition
Boris BREZILLON (11):
  clk: at91: rework main clk implementation
  clk: at91: update main clk documentation
  clk: at91: add slow clks driver
  clk: at91: add slow clk documentation
  ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
  ARM: at91/dt: add xtal frequencies to sama5d3xcm boards
  ARM: at91/dt: add xtal frequencies to sama5d3 xplained board
  ARM: at91/dt: move at91sam9261 SoC to the new main clock model
  ARM: at91/dt: define main xtal frequency of the at91sam9261ek board
  ARM: at91/dt: move at91sam9rl SoC to the new slow/main clock models
  ARM: at91/dt: define sam9rlek crystal frequencies

 .../devicetree/bindings/clock/at91-clock.txt       | 128 ++++-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   8 +
 arch/arm/boot/dts/at91sam9261.dtsi                 |  23 +-
 arch/arm/boot/dts/at91sam9261ek.dts                |   4 +
 arch/arm/boot/dts/at91sam9rl.dtsi                  |  46 +-
 arch/arm/boot/dts/at91sam9rlek.dts                 |   9 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  61 ++-
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |   8 +
 drivers/clk/at91/Makefile                          |   4 +-
 drivers/clk/at91/clk-main.c                        | 577 ++++++++++++++++++---
 drivers/clk/at91/clk-slow.c                        | 467 +++++++++++++++++
 drivers/clk/at91/pmc.c                             |  17 +
 drivers/clk/at91/pmc.h                             |   9 +
 drivers/clk/at91/sckc.c                            |  57 ++
 drivers/clk/at91/sckc.h                            |  22 +
 include/linux/clk/at91_pmc.h                       |   1 +
 16 files changed, 1352 insertions(+), 89 deletions(-)
 create mode 100644 drivers/clk/at91/clk-slow.c
 create mode 100644 drivers/clk/at91/sckc.c
 create mode 100644 drivers/clk/at91/sckc.h

-- 
1.8.3.2

