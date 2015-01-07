Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbbAGFwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:52:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59493 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbbAGFwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:52:01 -0500
From: Vignesh R <vigneshr@ti.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Brad Griffis <bgriffis@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Jan Kardell <jan.kardell@telliq.com>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH v6 0/6] Touchscreen performance related fixes
Date: Wed, 7 Jan 2015 11:19:33 +0530
Message-ID: <1420609779-11156-1-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is rebase of v4 onto v3.19-rc1. It also fixes concerns
expressed on v4 wrt simultaneous use of IIO and TSC.

I have tested this patch series on am335x-evm and Beaglebone black
with lcd7-cape.

Note that, these patches do not work as expected on Beaglebone Black
with BB-View 4.3 Cape from Farnell due to a hardware issue in the cape.

Change log:
v6:
 - Reorder patch 4 and 5.

v5:
 - Rebased onto v3.19-rc1
 - minor changes in patch 2,3 and 5.

v3:
 - Replace delta filtering logic in TSC driver with median filtering
   as suggested by Richard.
 - Addressed Lee Jones comments.

v2:
 - Addressed comments by Hartmut Knaack
 - patch 2 was split into two as per Lee Jones comment

Brad Griffis (2):
  input: touchscreen: ti_am335x_tsc Interchange touchscreen and ADC
    steps
  input: touchscreen: ti_am335x_tsc: Remove udelay in interrupt handler

Vignesh R (4):
  mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache save
  input: touchscreen: ti_am335x_tsc: Read charge delay from DT
  ARM: dts: AM335x: Make charge delay a DT parameter for TSC
  input: touchscreen: ti_am335x_tsc: Replace delta filtering with median
    filtering

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |  15 ++
 arch/arm/boot/dts/am335x-evm.dts                   |   1 +
 drivers/iio/adc/ti_am335x_adc.c                    |   5 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          | 197 ++++++++++++---------
 drivers/mfd/ti_am335x_tscadc.c                     |  13 +-
 include/linux/mfd/ti_am335x_tscadc.h               |   4 +-
 6 files changed, 137 insertions(+), 98 deletions(-)

-- 
1.9.1

