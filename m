Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbaGOM6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:58:09 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:45268 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986AbaGOM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:28 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v3 0/4] ARM: vf610: add FlexCAN support
Date: Tue, 15 Jul 2014 14:56:17 +0200
Message-Id: <cover.1405428166.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for Vybrid (aka vf610) to the FlexCAN
controller and extends the device tree accordingly.

Changes in v3:
- Return error number in flexcan_get_berr_counter if clock enabling fails
- Add the FLEXCANX_EN clocks as new clocks

Changes in v2:
- Split out patch (seperate dt, clocks and driver changes)
- Use spaces for hardware feature flags table
- Remove drive-by change of esdhc register length
- Added related fix which enables clock in berr_counter

Stefan Agner (4):
  ARM: dts: vf610: add FlexCAN node
  ARM: imx: clk-vf610: fix FlexCAN clock gating
  can: flexcan: switch on clocks before accessing ecr register
  can: flexcan: add vf610 support for FlexCAN

 arch/arm/boot/dts/vf610.dtsi            | 23 +++++++++
 arch/arm/mach-imx/clk-vf610.c           |  6 ++-
 drivers/net/can/flexcan.c               | 91 +++++++++++++++++++++++++++++----
 include/dt-bindings/clock/vf610-clock.h |  4 +-
 4 files changed, 110 insertions(+), 14 deletions(-)

-- 
2.0.1

