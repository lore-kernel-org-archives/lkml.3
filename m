Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3FLQ6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:58:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:44533 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3FLQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:58:36 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: am335x: TSC & ADC reworking including DT pieces, take 5
Date: Wed, 12 Jun 2013 18:58:01 +0200
Message-Id: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I did the cosmetic changes of the subject line and removed the changes
from within the sob lines in each patch. I dropped the "#define XPP
STEPCONFIG_XPP" thingy and patch #1 which removed regmap from mfd. Not
that I agree with it, I just do not want to miss the merge window due to
this.

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://breakpoint.cc/bigeasy/linux tags/am335x_tsc-adc

for you to fetch changes up to 1460c152c53335b5403045d056502eda1204c33a:

  iio: ti_am335x_adc: check if we found the value (2013-06-12 18:50:23 +0200)

----------------------------------------------------------------
A complete refurbished series inclunding:
- DT support for the MFD, TSC and ADC driver & platform device support,
  which has no users, has been killed.
- iio_map from last series is gone and replaced by proper nodes in the
  device tree.
- suspend fixes which means correct data structs are taken and no
  interrupt storm
- fifo split which should problem with TSC & ADC beeing used at the same
  time
- The ADC channels are now checked before blindly applied. That means the
  touch part reads X, Y and Z coordinates and does not mix them up. Same
  goes for the IIO ADC driver.
- The IIO ADC driver now creates files named in_voltageX_raw where X
  represents the ADC line instead of a number starting at 0. A read from
  this file can return -EBUSY in case touch is busy and the ADC didn't
  collect a value.

----------------------------------------------------------------
Pantelis Antoniou (2):
      iio: ti_tscadc: provide datasheet_name and scan_type
      mfd: ti_tscadc: deal with partial activation

Patil, Rachna (7):
      input: ti_am33x_tsc: Step enable bits made configurable
      input: ti_am33x_tsc: Order of TSC wires, made configurable
      input: ti_am33x_tsc: remove unwanted fifo flush
      input: ti_am33x_tsc: Add DT support
      iio: ti_am335x_adc: Add DT support
      mfd: ti_am335x_tscadc: Add DT support
      arm: am33xx: add TSC/ADC mfd device support

Sebastian Andrzej Siewior (12):
      mfd: input: iio: ti_am335x_adc: use one structure for ti_tscadc_dev
      input: ti_am33x_tsc: remove platform_data support
      iio: ti_am335x_adc: remove platform_data support
      mfd: ti_am335x_tscadc: remove platform_data support
      input: mfd: ti_am335x_tsc remove remaining platform data pieces
      mfd: input: ti_am335x_tsc: rename device from tsc to TI-am335x-tsc
      mfd: iio: ti_am335x_adc: rename device from tiadc to TI-am335x-adc
      input: ti_am335x_adc: use only FIFO0 and clean up a little
      input: ti_am335x_tsc: ACK the HW_PEN irq in ISR
      input: ti_am335x_tsc: return IRQ_NONE if there was no IRQ for us
      iio: ti_am335x_adc: Allow to specify input line
      iio: ti_am335x_adc: check if we found the value

 .../bindings/input/touchscreen/ti-tsc-adc.txt      |   44 +++
 arch/arm/boot/dts/am335x-evm.dts                   |   14 +
 arch/arm/boot/dts/am33xx.dtsi                      |   18 ++
 drivers/iio/adc/ti_am335x_adc.c                    |  132 ++++++---
 drivers/input/touchscreen/ti_am335x_tsc.c          |  288 ++++++++++++++------
 drivers/mfd/ti_am335x_tscadc.c                     |  112 ++++++--
 include/linux/input/ti_am335x_tsc.h                |   23 --
 include/linux/mfd/ti_am335x_tscadc.h               |   35 +--
 include/linux/platform_data/ti_am335x_adc.h        |   14 -
 9 files changed, 486 insertions(+), 194 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
 delete mode 100644 include/linux/input/ti_am335x_tsc.h
 delete mode 100644 include/linux/platform_data/ti_am335x_adc.h

Sebastian

