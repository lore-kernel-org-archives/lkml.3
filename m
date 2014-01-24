Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaAXMuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:50:10 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:59420 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaAXMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:05 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] ARM: shmobile: RSPI RZ and QSPI SoC and board integration
Date: Fri, 24 Jan 2014 13:49:36 +0100
Message-Id: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Simon, Magnus,

This patch series contains SoC and board integration for
  1. RSPI in the r7s72100 aka RZ/A1H SoC on the Genmai reference board,
  2. QSPI in the r8a7791 aka R-Car M2 SoC on the Koelsch reference board.

It was tested on the r7s72100-based Genmai reference board using loopback
mode, and on the r8a7791-based Koelsch reference board using the Spansion
s25fl512s SPI FLASH.

Actual functioning for some parts may depend on the series "[PATCH 0/14]
spi: rspi: Add support for RZ/A1H, DT, and Quad/Dual on QSPI" I posted
earlier today.

Overview:
    [v4 01/15] ARM: shmobile: r7s72100 clock: Add RSPI clocks
    [v4 02/15] ARM: shmobile: genmai legacy: Add RSPI support
    [v4 03/15] [WIP] ARM: shmobile: genmai legacy: Add preliminary RSPI
	       pinmux setup
    [v2 04/15] ARM: shmobile: genmai defconfig: Enable RSPI
    [v2 05/15] ARM: shmobile: r7s72100 clock: Add RSPI clocks for DT
    [v4 06/15] ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
    [v4 07/15] ARM: shmobile: genmai reference dts: Add RSPI nodes
    [v3 08/15] ARM: shmobile: r8a7791 clock: add QSPI clocks
    [v3 09/15] ARM: shmobile: koelsch legacy: Add QSPI support
    [v3 10/15] ARM: shmobile: koelsch defconfig: Enable RSPI and MTD_M25P80
    [v2 11/15] ARM: shmobile: r8a7791 dtsi: Add QSPI node
    [v2 12/15] ARM: shmobile: koelsch dts: Add QSPI nodes
    [   13/15] ARM: shmobile: lager legacy: Switch QSPI to named IRQs
    [   14/15] ARM: shmobile: koelsch legacy: Enable Quad SPI transfers for
	       the SPI FLASH
    [   15/15] ARM: shmobile: koelsch dts: Enable Quad SPI transfers

Earlier versions of these have been posted before in:
    "[PATCH V3 0/5] SoC and board integration for RSPI on r7s72100/genmai"
    "[PATCH V2 0/4] SoC and board integration for QSPI on r8a7791/koelsch"
    "[PATCH 0/9] Renesas RSPI/QSPI DT support"

The series is based on renesas-devel-v3.13-20140124, with pinctrl work 
accepted by Linus, Magnus' pinctrl, Wolfram's riic, Simon's sh_eth,
Valentine's i2c, and Laurent's SCIF DT work applied on top.
[Simon: I don't know in which order you will merge these. If you want me
 to rebase my patches, just ask! Thanks!]

All of these should be safe to apply, without runtime dependencies on other
parts, except for [14/15] and [15/15]: those must not go in before
"[14/14] spi: rspi: Add support for Quad and Dual SPI Transfers on QSPI",
as this would disable SPI FLASH access (the SPI core rejects Quad SPI slaves
without Quad SPI master support).

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
