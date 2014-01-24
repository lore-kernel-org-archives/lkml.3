Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaAXIui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:50:38 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:38900 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaAXIoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/14] spi: rspi: Add support for RZ/A1H, DT, and Quad/Dual on QSPI
Date: Fri, 24 Jan 2014 09:43:50 +0100
Message-Id: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Mark,

This patch series
  1. refactors the Renesas RSPI/QSPI driver,
  2. adds support for RSPI in the r7s72100 aka RZ/A1H SoC,
  3. adds support for DT binding,
  4. adds support for Quad/Dual SPI Transfers on QSPI in the r8a7790/r8a7791
     aka R-Car H2/M2 SoCs.

SoC and board integration patches will be posted in a separate series.

It was tested on the r7s72100-based Genmai reference board using loopback
mode, and on the r8a7791-based Koelsch reference board using the Spansion
s25fl512s SPI FLASH.

Quad Write Transfers were not tested, as this needs support in the m25p80
driver first. Also, it's of limited use, as FLASH programming is slow.

Overview:
    [   01/14] spi: rspi: Remove unused mesg parameter from
    			  {send,receive}_pio()
    [   02/14] spi: rspi: Use core message handling
    [   03/14] spi: rspi: Abstract 8/16-bit Data Register access
    [   04/14] spi: rspi: Add rspi_data_{out,in,out_in}() helpers
    [   05/14] spi: rspi: Abstract transfer_one() for RSPI and QSPI
    [   06/14] spi: rspi: Merge rspi_send_pio() and rspi_receive_pio()
    [   07/14] spi: rspi: Merge qspi_send_pio() and qspi_receive_pio()
    [v3 08/14] spi: rspi: Add support for more than one interrupt
    [   09/14] spi: rspi: Add support for RSPI on RZ/A1H
    [v3 10/14] spi: rspi: Add support for loopback mode
    [v2 11/14] spi: rspi: Convert to clk_prepare_enable/disable_unprepare
    [v2 12/14] spi: rspi: Use NULL as the clock ID
    [v4 13/14] spi: rspi: Add DT support
    [   14/14] spi: rspi: Add support for Quad and Dual SPI Transfers on QSPI

The series contains new work, and remaining/rebased/updated patches from the
following series that had been posted before:
    [PATCH v2 0/8] spi: rspi: Add support for RZ/A1H
    [PATCH v3 0/9] Renesas RSPI/QSPI DT support

Patches [03/14] and [09/14] completely replace the old handling using
platform data in
    [4/8 V2] spi: rspi: Add support for 8-bit Data Register access
    [5/8 V2] spi: rspi: Add support for no TX only mode
    [6/8 V2] spi: rspi: Add support for missing SPCR2 register
by a new "rspi-rz" platform device name binding.

Please review, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

