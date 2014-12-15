Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873AbaLOL7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:59:31 -0500
Received: from mail-yk0-f182.google.com ([209.85.160.182]:65335 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaLOL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:59:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 00/13] mtd: st_spi_fsm: Align with ST's internal development
Date: Mon, 15 Dec 2014 11:59:07 +0000
Message-Id: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian, all,
 
 [x] Bulid test
 [x] Bisectable
 [x] Smatch
 [x] Sparse

v3:
  Further aligned with upstream changes as suggested by Peter Griffin.
  The clk_ignore_unused kernel command line parameter is due to be turned
  off on STiH4* platforms, so we no longer give the driver the chance to
  opt-out of fetching the EMI clock.  We also now provide syscfg offsets
  inside the driver, as it's simpler and reduces the cost of having lots
  of extra DT properties.
 
v2:
  These are the last remaining patches in the set, all rebased and
  with the DT documentation requested after the last submission.
 
v1:
  This patch-set updates ST's FSM SPI-NOR driver with all the internal
  goodness which has happened since the initial (now upstreamed) snapshot
  was taken. It covers just over 6 months worth of internal development
  and bug-fixes. A final whitespace clean-up is also appended to the set
  - to make it look pretty and stuff. :)

Angus Clark (3):
  mtd: st_spi_fsm: Add support for N25Q512 and N25Q00A devices
  mtd: st_spi_fsm: Update Spansion device entries
  mtd: st_spi_fsm: Improve busy wait handling

Lee Jones (9):
  mtd: st_spi_fsm: Extend fsm_clear_fifo to handle unwanted bytes
  mtd: st_spi_fsm: Obtain and use EMI clock
  mtd: st_spi_fsm: dt-bindings: Deprecate generic compatible string
  mtd: st_spi_fsm: Fetch boot device locations from DT match tables
  mtd: st_spi_fsm: Fix [-Wsign-compare] build warning
  mtd: st_spi_fsm: Update the JEDEC probe to handle extended READIDs
  mtd: st_spi_fsm: General tidy-up
  ARM: STi: stih416: Use new platform specific compatible string
  ARM: STi: stih416: Supply EMI clock reference to FSM SPI NOR

Nunzio Raciti (1):
  mtd: st_spi_fsm: Add support for Micron N25Q512A

 Documentation/devicetree/bindings/mtd/st-fsm.txt |  20 +-
 arch/arm/boot/dts/stih416.dtsi                   |   6 +-
 drivers/mtd/devices/st_spi_fsm.c                 | 747 +++++++++++++++--------
 include/dt-bindings/clock/stih416-clks.h         |   1 +
 4 files changed, 519 insertions(+), 255 deletions(-)

-- 
1.9.1

