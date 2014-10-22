Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaJVQ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:29:35 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43345 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaJVQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:29:33 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, arnd@arndb.de
Cc: b35083@freescale.com, bpringlemeir@nbsps.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 0/4] ARM: vf610: restructure device trees
Date: Wed, 22 Oct 2014 18:27:53 +0200
Message-Id: <1413995277-2844-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is v2 of "ARM: dts: vf500/vf610: support VF500 SoC",
and grew by some patches. It now also solves some issues uncovered
by the "ARM: vf610m4: Add Vybrid Cortex-M4 support" patchset.  The
next Cortex-M4 patchset will then base on this patchset.

I could again not use the -M/-B parameter to generate smaller and
better readable patches. Those patches ended up not apply-able.

Changes in v2:
- Assign fixed input clocks to clock controller module to ensure correct
  initialization order
- Get rid of "clocks"-node and move fixed clocks to the root level
- Move peripherals to vfxxx.dtsi to allow share the nodes for Cortex-A5
  and Cortex-M4 SoC device trees.
  
Stefan Agner (4):
  ARM: dts: vf610: assign oscillator to clock module
  ARM: imx: clk-vf610: get input clocks from assigned clocks
  ARM: dts: vf610: create generic base device trees
  ARM: dts: vf500-colibri: add Colibri VF50 support

 .../devicetree/bindings/clock/vf610-clock.txt      |  15 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi          |  54 +++
 arch/arm/boot/dts/vf-colibri.dtsi                  | 142 ++++++
 arch/arm/boot/dts/vf500-colibri-eval-v3.dts        |  17 +
 arch/arm/boot/dts/vf500-colibri.dtsi               |  20 +
 arch/arm/boot/dts/vf500.dtsi                       | 171 +++++++
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts        |  47 +-
 arch/arm/boot/dts/vf610-colibri.dtsi               | 137 +-----
 arch/arm/boot/dts/vf610-cosmic.dts                 |  14 +-
 arch/arm/boot/dts/vf610-twr.dts                    |  37 +-
 arch/arm/boot/dts/vf610.dtsi                       | 507 +--------------------
 arch/arm/boot/dts/vfxxx.dtsi                       | 436 ++++++++++++++++++
 arch/arm/mach-imx/clk-vf610.c                      |  20 +-
 14 files changed, 920 insertions(+), 698 deletions(-)
 create mode 100644 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
 create mode 100644 arch/arm/boot/dts/vf-colibri.dtsi
 create mode 100644 arch/arm/boot/dts/vf500-colibri-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/vf500-colibri.dtsi
 create mode 100644 arch/arm/boot/dts/vf500.dtsi
 create mode 100644 arch/arm/boot/dts/vfxxx.dtsi

-- 
2.1.2

