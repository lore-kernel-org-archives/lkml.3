Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab3BMCr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:47:58 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64513 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3BMCr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:47:57 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Rob Landley <rob@landley.net>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Luigi Semenzato <semenzato@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Che-Liang Chiou <clchiou@chromium.org>,
        Jonathan Kliegman <kliegs@chromium.org>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        "Mike A. Chan" <mikechan@google.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Sourav Poddar <sourav.poddar@ti.com>, Tom Keel <thomas.keel@intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH v2 0/6] Add ChromeOS Embedded Controller support
Date: Tue, 12 Feb 2013 18:42:20 -0800
Message-Id: <1360723347-28701-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ChromeOS Embedded Controller (EC) is an Open Source EC implementation
used on ARM and Intel Chromebooks. Current implementations use a Cortex-M3
connected on a bus (such as I2C, SPI, LPC) to the AP. A separate interrupt
line is used to indicate when the EC needs service.

Functions performed by the EC vary by platform, but typically include
battery charging, keyboard scanning and power sequencing.

This series includes support for the EC message protocol, and implements
a matrix keyboard handler for Linux using the protocol. The EC performs
key scanning and passes scan data in response to AP requests. This is
used on the Samsung ARM Chromebook. No driver is available for LPC at
present.

This series can in principle operate on any hardware, but for it to actually
work on the Samsung ARM Chromebook, it needs patches which are currently in
progress to mainline: Exynos FDT interrupt support and I2C bus arbitration.

The driver is device-tree-enabled and a suitable binding is included in
this series. Example device tree nodes are included in the examples,
but no device tree patch for exynos5250-snow is provided at this stage, since
we must wait for the above-mentioned patches to land to avoid errors from
dtc. This can be added with a follow-on patch when that work is complete.

Changes in v2:
- Remove use of __devinit/__devexit
- Remove use of __devinit/__devexit
- Remove use of __devinit/__devexit
- Add new patch to decode matrix-keypad DT binding
- Remove use of __devinit/__devexit
- Use function to read matrix-keypad parameters from DT
- Remove key autorepeat parameters from DT binding and driver
- Use unsigned int for rows/cols

Simon Glass (6):
  mfd: Add ChromeOS EC messages header
  mfd: Add ChromeOS EC implementation
  mfd: Add ChromeOS EC I2C driver
  mfd: Add ChromeOS EC SPI driver
  Input: matrix-keymap: Add function to read the new DT binding
  Input: Add ChromeOS EC keyboard driver

 .../devicetree/bindings/input/cros-ec-keyb.txt     |   72 +
 Documentation/devicetree/bindings/mfd/cros-ec.txt  |   56 +
 drivers/input/keyboard/Kconfig                     |   12 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/cros_ec_keyb.c              |  394 ++++++
 drivers/input/keyboard/lpc32xx-keys.c              |   11 +-
 drivers/input/keyboard/omap4-keypad.c              |   16 +-
 drivers/input/keyboard/tca8418_keypad.c            |   11 +-
 drivers/input/matrix-keymap.c                      |   20 +
 drivers/mfd/Kconfig                                |   28 +
 drivers/mfd/Makefile                               |    3 +
 drivers/mfd/cros_ec.c                              |  219 ++++
 drivers/mfd/cros_ec_i2c.c                          |  262 ++++
 drivers/mfd/cros_ec_spi.c                          |  412 ++++++
 include/linux/input/matrix_keypad.h                |   11 +
 include/linux/mfd/cros_ec.h                        |  190 +++
 include/linux/mfd/cros_ec_commands.h               | 1369 ++++++++++++++++++++
 17 files changed, 3067 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/cros-ec-keyb.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/cros-ec.txt
 create mode 100644 drivers/input/keyboard/cros_ec_keyb.c
 create mode 100644 drivers/mfd/cros_ec.c
 create mode 100644 drivers/mfd/cros_ec_i2c.c
 create mode 100644 drivers/mfd/cros_ec_spi.c
 create mode 100644 include/linux/mfd/cros_ec.h
 create mode 100644 include/linux/mfd/cros_ec_commands.h

-- 
1.8.1

