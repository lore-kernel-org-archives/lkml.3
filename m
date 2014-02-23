Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBWWID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:08:03 -0500
Received: from ring0.de ([5.45.105.125]:59202 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaBWWIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:08:00 -0500
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
Subject: [RFCv2 0/5] Convert twl4030-madc to IIO API
Date: Sun, 23 Feb 2014 23:07:46 +0100
Message-Id: <1393193271-16717-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140223220140.GA1258@earth.universe>
References: <20140223220140.GA1258@earth.universe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is RFCv2 for converting twl4030-madc to the IIO API and
adding DT support. The patchset compiles, but has not yet been
tested on real hardware. I plan to convert rx51-battery to the
IIO framework in the near future and test this patchset on my
Nokia N900.

Changes since RFCv1:
 * Add ti,system-uses-second-madc-irq DT property needed by Belisko Marek
 * Fix issues reported by Jonathan Cameron

TODO:
 * Test patchset on real hardware
 * Convert consumer drivers to IIO API
  - rx51-battery
  - twl4030-madc-battery
  - twl4030-madc-hwmon (=> deprecate in favour of iio-hwmon)
 * remove old kernel API from twl4030-madc

-- Sebastian

Sebastian Reichel (5):
  mfd: twl4030-madc: Use managed resources
  mfd: twl4030-madc: Add DT support and convert to IIO framework
  mfd: twl4030-madc: Cleanup driver
  Documentation: DT: Document twl4030-madc binding
  mfd: twl4030-madc: Move driver to drivers/iio/adc

 .../devicetree/bindings/iio/adc/twl4030-madc.txt   |  24 +
 drivers/iio/adc/Kconfig                            |  10 +
 drivers/iio/adc/Makefile                           |   1 +
 drivers/iio/adc/twl4030-madc.c                     | 914 +++++++++++++++++++++
 drivers/mfd/Kconfig                                |  10 -
 drivers/mfd/Makefile                               |   1 -
 drivers/mfd/twl4030-madc.c                         | 818 ------------------
 7 files changed, 949 insertions(+), 829 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
 create mode 100644 drivers/iio/adc/twl4030-madc.c
 delete mode 100644 drivers/mfd/twl4030-madc.c

-- 
1.8.5.3

