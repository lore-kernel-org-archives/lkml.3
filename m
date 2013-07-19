Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab3GSJOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:14:46 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.100]:31815 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760117Ab3GSJOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:14:09 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-10.tower-200.messagelabs.com!1374225243!16108572!8
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <marex@denx.de>, <alexandre.belloni@free-electrons.com>,
        <jic23@kernel.org>, <lars@metafoo.de>, <fabio.estevam@freescale.com>,
        <hector.palacios@digi.com>
Subject: [PATCH v2 0/5] iio: mxs-lradc: add support to optional divider_by_two
Date: Fri, 19 Jul 2013 11:13:23 +0200
Message-ID: <1374225208-28940-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This is v2 of the patchset that adds support to the optional 
divider_by_two of LRADC channels. 

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
 drivers/staging/iio/adc/mxs-lradc.c                | 249 ++++++++++++++++++---
 4 files changed, 231 insertions(+), 35 deletions(-)

