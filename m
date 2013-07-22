Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3GVOFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:05:01 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.111]:62398 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451Ab3GVOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:04:59 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-2.tower-200.messagelabs.com!1374501894!11361230!4
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <alexandre.belloni@free-electrons.com>, <jic23@kernel.org>,
        <lars@metafoo.de>, <fabio.estevam@freescale.com>, <marex@denx.de>,
        <hector.palacios@digi.com>
Subject: [PATCH v3 0/5] iio: mxs-lradc: add support to optional divider_by_two
Date: Mon, 22 Jul 2013 16:03:58 +0200
Message-ID: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This is v3 of the patchset that adds support to the optional 
divider_by_two of LRADC channels.

Changes in v3:
- Fix merge conflict with previous existing patch.
- Fix ampersand in function callback assignment.
- Removed unused parameters of function to read single sample.
- Ennumeration for two-dimensional array of scale (with divider
  by two disabled or enabled), for improved readability.
- Created struct with integer and nano parts of the scale 
  attribute, for improved readability.

Changes in v2:
- Fix the sample mask passed by the touchscreen driver to the input
  subsytem, to be 12 bits.
- Move the reference voltages to the Device Tree.
- Rebased to avoid conflict with Marek Vasut's prior patch.
- Use IIO_DEVICE_ATTR() macro for adding scale_available property to
  all channels.
- Make 'is_divided' unsigned int.

Notes:
- Other fixes were discussed in v1 but they were not part of this
  patchset changes, and should be handled in a separate patch.
- The 64bit math to calculate the integer and decimal parts of the
  scaling attribute is a bit unreadable but used in other similar
  drivers like ad7791, ad7793, and ad7192. If it is to be changed
  it should be done in parallel with these, in a different patch.

The first patch changes the realbits to 12. The 
second adds the channels reference voltages to the DT.
The following add the scale read operation, scale_available read 
operation, and scale write operation.

This was tested on a custom i.MX28 platform.
Could someone please test on an i.MX23?


Hector Palacios (5):
  iio: mxs-lradc: change the realbits to 12
  ARM: dts: add reference voltage property for MXS LRADC
  iio: mxs-lradc: add scale attribute to channels
  iio: mxs-lradc: add scale_available file to channels
  iio: mxs-lradc: add write_raw function to modify scale

 .../bindings/staging/iio/adc/mxs-lradc.txt         |   9 +-
 arch/arm/boot/dts/imx23.dtsi                       |   4 +
 arch/arm/boot/dts/imx28.dtsi                       |   4 +
 drivers/staging/iio/adc/mxs-lradc.c                | 255 ++++++++++++++++++---
 4 files changed, 242 insertions(+), 30 deletions(-)

