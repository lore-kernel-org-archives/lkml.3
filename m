Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaGGPTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:19:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58231 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbaGGPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:19:30 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/5] Add a driver for the atmel ram controller
Date: Mon,  7 Jul 2014 17:19:10 +0200
Message-Id: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel ram controller needs one or more clocks to work. For now the
CLK_IGNORE_UNUSED flag is used on those clocks. This patch set introduce a
driver that will take care of taking those clocks.

The final goal is also to move the ioremap done in mach-at91 to that driver with
a proper power management driver.

Alexandre Belloni (5):
  memory: add a driver for atmel ram controllers
  ARM: at91: select ATMEL_RAMC when using OF
  ARM: at91/dt: sama5d3: define mpddr clock and ramc clocks
  ARM: at91/dt: at91sam9: use ddrck in ramc
  clk: at91: remove the useless CLK_IGNORE_UNUSED flag

 .../devicetree/bindings/arm/atmel-at91.txt         |  1 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  2 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  2 +
 arch/arm/boot/dts/sama5d3.dtsi                     |  9 +-
 arch/arm/mach-at91/Kconfig                         |  4 +
 drivers/clk/at91/clk-system.c                      |  8 +-
 drivers/memory/Kconfig                             |  8 ++
 drivers/memory/Makefile                            |  1 +
 drivers/memory/atmel-ramc.c                        | 96 ++++++++++++++++++++++
 9 files changed, 123 insertions(+), 8 deletions(-)
 create mode 100644 drivers/memory/atmel-ramc.c

-- 
1.9.1

