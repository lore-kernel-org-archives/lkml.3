Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3GBRF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:05:29 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.101]:24784 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab3GBRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:05:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1372784718!7164158!16
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 00/11] spi: spi-ep93xx: tidy up and convert to queued driver infrastructure
Date: Tue, 2 Jul 2013 10:04:50 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307021004.51080.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a bit of housekeeping in this driver and convert it to use the
SPI queued driver infrastructure.

v2: rebased on next-20130702
    address some comments from Ryan Mallon and Mika Westerberg
    added a couple more cleanup patches

    Patch 1/11 was already applied by Mark Brown. It is included here only for
    completeness.

H Hartley Sweeten (11):
  spi: spi-ep93xx: always handle transfer specific settings
  spi: spi-ep93xx: use read,write instead of __raw_* variants
  spi: spi-ep93xx: remove bits_per_word() helper
  spi: spi-ep93xx: get platform resources early in (*probe)
  spi: spi-ep93xx: use devm_clk_get()
  spi: spi-ep93xx: remove dev_err() for kzalloc() failure
  spi: spi-ep93xx: remove 'dss' from per chip private data
  spi: spi-ep93xx: don't bother calculating the divisors in ep93xx_spi_setup()
  spi: spi-ep93xx: move the clock divider calcs into ep93xx_spi_chip_setup()
  spi: spi-ep93xx: convert to the queued driver infrastructure
  spi: spi-ep93xx: use master->cur_msg for in-flight message

 drivers/spi/spi-ep93xx.c | 437 ++++++++++++++---------------------------------
 1 file changed, 127 insertions(+), 310 deletions(-)

-- 
1.8.1.4

