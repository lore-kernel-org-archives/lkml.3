Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaBZAYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:24:42 -0500
Received: from ring0.de ([5.45.105.125]:46965 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbaBZAYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:24:39 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
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
Subject: [RFCv3 0/7] Convert twl4030-madc to IIO API and add DT support
Date: Wed, 26 Feb 2014 01:24:23 +0100
Message-Id: <1393374270-20079-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393193271-16717-1-git-send-email-sre@debian.org>
References: <1393193271-16717-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is RFCv3 for converting twl4030-madc to the IIO API and
adding DT support. The patchset compiles and has been tested
on my Nokia N900.

Changes since RFCv2:
 * Use "--find-renames" for the move from mfd/ to iio/adc/ ;)
 * Added Acked-by from Lee Jones (MFD subsystem maintainer)
 * Fixed issue found by Joe Perches
  - twl4030_madc_request.do_avg should be bool instead of u16
 * Fixed issues found by Peter Meerwald
  - some style issues (e.g. /** instead of /*)
  - typos
  - usage of u16 read/write
 * Tested with converted rx51-battery driver on Nokia N900

TODO:
 * Remove twl4030-madc-hwmon in favour of iio-hwmon
   This driver is currently only used by board-omap3beagle.c
   and board-rx51-peripherals.c. The instanciation in the
   rx51 boardcode is a bug, since actually only twl4030-madc
   is needed. Thus board-omap3beagle.c needs to be updated to
   iio-hwmon and board-rx51-peripherals.c to twl4030-madc.
   Both tasks are pretty trivial and twl4030-madc-hwmon can
   be removed afterwards :)
 * Update twl4030-madc-battery to the IIO API. I guess Marek
   will do this update in the near future, since he is currently
   writing DT bindings for the driver.
 * I updated twl4030-madc-battery already and will send it
   in a separate patchset.
 * Once all of the above steps happened the old API can be
   removed from the driver, which allows some more cleanups.

-- Sebastian

Sebastian Reichel (7):
  mfd: twl4030-madc: Use managed resources
  mfd: twl4030-madc: Add DT support and convert to IIO framework
  mfd: twl4030-madc: Cleanup driver
  mfd: twl-core: Add twl_i2c_read/write_u16
  mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
  Documentation: DT: Document twl4030-madc binding
  mfd: twl4030-madc: Move driver to drivers/iio/adc

 .../devicetree/bindings/iio/adc/twl4030-madc.txt   |  24 ++
 drivers/iio/adc/Kconfig                            |  10 +
 drivers/iio/adc/Makefile                           |   1 +
 drivers/{mfd => iio/adc}/twl4030-madc.c            | 278 +++++++++++++--------
 drivers/mfd/Kconfig                                |  10 -
 drivers/mfd/Makefile                               |   1 -
 include/linux/i2c/twl.h                            |  12 +
 include/linux/i2c/twl4030-madc.h                   |   2 +-
 8 files changed, 224 insertions(+), 114 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
 rename drivers/{mfd => iio/adc}/twl4030-madc.c (77%)

-- 
1.8.5.3

