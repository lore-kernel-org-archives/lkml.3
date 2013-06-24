Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3FXRZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:25:12 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37678 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:25:09 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 0/3] Add support for the Nuvoton NAU7802 ADC to the cfa10049
Date: Mon, 24 Jun 2013 19:24:56 +0200
Message-Id: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v3 of the patchset that adds support for the 3 Nuvoton NAU7802 ADCs
present on the CFA-10049 board from Crystalfontz. The first patch adds the
driver, the next ones are adding them in the DT after switching the second i2c
bus to bitbanging following a lot of timeout issues we have on that bus.

Changes in v3:
 - removed the min_conversion knob in sysfs, it is now hardcoded to 6
 - added error checking in probe
 - corrected error checking
 - corrected possibly uninitialized vldo
 - used ARRAY_SIZE(nau7802_chan_array) instead of 2
 - added that vldo refers to the internal voltage regulator

Changes in v2:
 - channels are now statically allocated
 - no wrappers around i2c functions
 - sampling_freq is a shared attribute
 - setting gain is done through scale
 - cosmetics changes (s/idev/indio_dev/, blank lines before returns)
 - use of sign_extend32 to extend the sign
 - reading scale now returns IIO_VAL_FRACTIONAL_LOG2
 - no dt lookup for interrupts, this is done in of_i2c.c but that was mask due
 to a bug.

what I didn't address is setting the external reference voltage through a fixed
regulator and I kept the vldo attribute to set the internal voltage reference in
the DT as Jonathan seemed to be ok with that. If anybody is using a nau7802 with
an external reference, it will still be time to add the fixed regulator. It
shouldn't be difficult but I don't have any hardware to test.

Regards,

Alexandre Belloni (1):
  iio: Add Nuvoton NAU7802 ADC driver

Maxime Ripard (2):
  ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
  ARM: mxs: cfa10049: Add NAU7802 ADCs to the device tree

 .../bindings/iio/adc/nuvoton-nau7802.txt           |  18 +
 arch/arm/boot/dts/imx28-cfa10049.dts               | 126 +++--
 drivers/iio/adc/Kconfig                            |   9 +
 drivers/iio/adc/Makefile                           |   1 +
 drivers/iio/adc/nau7802.c                          | 576 +++++++++++++++++++++
 5 files changed, 687 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
 create mode 100644 drivers/iio/adc/nau7802.c

-- 
1.8.1.2

