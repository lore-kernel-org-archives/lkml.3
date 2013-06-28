Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3F1Sm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:42:58 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.195]:53611 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab3F1Sm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:42:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1372444971!11205921!6
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] spi: spi-ep93xx: tidy up and convert to queued driver infrastructure
Date: Fri, 28 Jun 2013 11:41:38 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281141.38864.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a bit of housecleaning in this driver and convert it to use the
SPI queued driver infrastructure.

H Hartley Sweeten (8):
  spi: spi-ep93xx: use read,write instead of __raw_* variants
  spi: spi-ep93xx: use bits_per_word_mask
  spi: spi-ep93xx: always handle transfer specific settings
  spi: spi-ep93xx: remove bits_per_word() helper
  spi: spi-ep93xx: remove 'dss' from per chip private data
  spi: spi-ep93xx: don't bother calculating the divisors in ep93xx_spi_setup()
  spi: spi-ep93xx: move the clock divider calcs into ep93xx_spi_chip_setup()
  spi: spi-ep93xx: convert to the queued driver infrastructure

 drivers/spi/spi-ep93xx.c | 366 ++++++++++-------------------------------------
 1 file changed, 75 insertions(+), 291 deletions(-)

-- 
1.8.1.4

