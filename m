Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3AXDp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:45:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58128 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab3AXDpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:45:16 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <gururaja.hebbar@ti.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v4 0/8] MFD: ti_am335x_tscadc: DT support and TSC features addition
Date: Thu, 24 Jan 2013 09:15:04 +0530
Message-ID: <1358999112-31192-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

This patch set is a cumulative set of [1] and [2] sent earlier.

Note that there are no code changes in either of the patch set,
only rebased on top of Linus's v3.8-rc3 tag to make sure that
all the patches apply without any conflicts.

This patch set has been tested on AM335x EVM.

[1] http://www.spinics.net/lists/linux-input/msg23060.html
[2] http://www.spinics.net/lists/linux-input/msg23090.html

Changes in v4:
	Subnodes and their properties documentation added.
	Non-standard properties prefixed with vendor name.

Changes in v3:
	No code change.

Changes in v2:
	Patch "input: ti_am335x_tsc: Add variance filter"
	from v1 has been dropped.
	Add MFD device DT node in AM335x EVM.

Patil, Rachna (8):
  input: ti_am335x_tsc: Step enable bits made configurable
  input: ti_am335x_tsc: Order of TSC wires, made configurable
  input: touchscreen: ti_tsc: remove unwanted fifo flush
  MFD: ti_am335x_tscadc: add device tree binding information
  MFD: ti_am335x_tscadc: Add DT support
  input: ti_am335x_tsc: Add DT support
  IIO: ti_am335x_adc: Add DT support
  arm/dts: AM335x-evm: Add TSC/ADC MFD device support

 .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   52 ++++
 arch/arm/boot/dts/am335x-evm.dts                   |   13 +
 arch/arm/boot/dts/am33xx.dtsi                      |    8 +
 drivers/iio/adc/ti_am335x_adc.c                    |   26 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |  266 +++++++++++++++++---
 drivers/mfd/ti_am335x_tscadc.c                     |   28 ++-
 include/linux/input/ti_am335x_tsc.h                |   12 +
 include/linux/mfd/ti_am335x_tscadc.h               |   11 +-
 8 files changed, 364 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt

-- 
1.7.9.5

