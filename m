Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaCRUTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:19:21 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50293 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbaCRUTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:19:18 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [PATCH 00/11] ARM: at91: rework main and slow clk implementation
Date: Tue, 18 Mar 2014 21:18:33 +0100
Message-Id: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series introduce the real clock model (as described in atmel datasheets)
for slow and main clocks.

The modifications introduced by this series break the DT compat, but, as the
at91 CCF based implementation is pretty new (introduced in 3.14 only for sama5
eval boards) I think it won't impact a lot of users.

I tested it on sama5d3.
Alexandre, Jean-Jacques, could you test this series on your eval boards
(sam9261ek and sam9rlek) so that we can move to this new model and hopefully
consider the at91 clk DT binding as (almost :-)) stable.

Jean-Jacques, as you can see I reworked my first implementation as you
suggested, do you want me to add your Signed-off-by in the next version ?

Mike, if this series is accepted, I'd like to get it merged as soon as possible
to prevent other developpers from using a deprecated DT binding.

Best Regards,

Boris

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

 .../devicetree/bindings/clock/at91-clock.txt       |  128 ++++-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   10 +
 arch/arm/boot/dts/at91sam9261.dtsi                 |   10 +-
 arch/arm/boot/dts/at91sam9261ek.dts                |    4 +
 arch/arm/boot/dts/at91sam9rl.dtsi                  |   45 +-
 arch/arm/boot/dts/at91sam9rlek.dts                 |    8 +
 arch/arm/boot/dts/sama5d3.dtsi                     |   61 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |   10 +
 drivers/clk/at91/Makefile                          |    4 +-
 drivers/clk/at91/clk-main.c                        |  581 +++++++++++++++++---
 drivers/clk/at91/clk-slow.c                        |  467 ++++++++++++++++
 drivers/clk/at91/pmc.c                             |   12 +
 drivers/clk/at91/pmc.h                             |    9 +
 drivers/clk/at91/sckc.c                            |   57 ++
 drivers/clk/at91/sckc.h                            |   22 +
 include/linux/clk/at91_pmc.h                       |    1 +
 16 files changed, 1342 insertions(+), 87 deletions(-)
 create mode 100644 drivers/clk/at91/clk-slow.c
 create mode 100644 drivers/clk/at91/sckc.c
 create mode 100644 drivers/clk/at91/sckc.h

-- 
1.7.9.5

