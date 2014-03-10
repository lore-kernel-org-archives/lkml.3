Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaCJRZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:25:43 -0400
Received: from ring0.de ([5.45.105.125]:40386 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbaCJRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:25:39 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv3 0/9] Convert twl4030-madc to IIO API and add DT support
Date: Mon, 10 Mar 2014 18:25:20 +0100
Message-Id: <1394472329-15485-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is PATCHv3 for converting twl4030-madc to the IIO API and
adding DT support. The plan is to remove the private twl4030-madc
API once all users have been removed or converted to the IIO API.
The patchset compiles and has been tested on my Nokia N900.

Changes since PATCHv2 [0]:
 * Added Tested-by: Marek Belisko to all patches, which modify
   code used by twl4030-madc-battery driver
 * Update madc->use_second_irq as suggested by Lee Jones
 * Use dev_err instead of dev_dbg for error messages in probe function
 * Add a space between "{" and ".compatible"
 * Decrease indention of closing "}" in twl4030_madc_driver.driver

[0] https://lkml.org/lkml/2014/3/4/815

-- Sebastian

Sebastian Reichel (9):
  mfd: twl4030-madc: Use managed resources
  mfd: twl4030-madc: Add DT support and convert to IIO framework
  mfd: twl4030-madc: Cleanup driver
  mfd: twl-core: Add twl_i2c_read/write_u16
  mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
  Documentation: DT: Document twl4030-madc binding
  mfd: twl4030-madc: Move driver to drivers/iio/adc
  iio: documentation: Add ABI documentation for *_mean_raw
  iio: inkern: add iio_read_channel_average_raw

 Documentation/ABI/testing/sysfs-bus-iio            |   8 +
 .../devicetree/bindings/iio/adc/twl4030-madc.txt   |  24 ++
 drivers/iio/adc/Kconfig                            |  10 +
 drivers/iio/adc/Makefile                           |   1 +
 drivers/{mfd => iio/adc}/twl4030-madc.c            | 302 +++++++++++++--------
 drivers/iio/inkern.c                               |  18 ++
 drivers/mfd/Kconfig                                |  10 -
 drivers/mfd/Makefile                               |   1 -
 include/linux/i2c/twl.h                            |  12 +
 include/linux/i2c/twl4030-madc.h                   |   2 +-
 include/linux/iio/consumer.h                       |  13 +
 11 files changed, 275 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
 rename drivers/{mfd => iio/adc}/twl4030-madc.c (75%)

-- 
1.9.0

