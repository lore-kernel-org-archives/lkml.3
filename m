Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbaD3Roi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:44:38 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64573 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212AbaD3Rof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:44:35 -0400
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        mark.rutland@arm.com, andrew@lunn.ch, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, linux-i2c@vger.kernel.org,
        matt.porter@linaro.org, jdelvare@suse.de,
        laurent.pinchart+renesas@ideasonboard.com, vpalatin@chromium.org,
        sameo@linux.intel.com, linux-doc@vger.kernel.org,
        bjorn.andersson@sonymobile.com, u.kleine-koenig@pengutronix.de,
        kevin.strasser@linux.intel.com, devicetree@vger.kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        linux@arm.linux.org.uk, andriy.shevchenko@linux.intel.com,
        ch.naveen@samsung.com, linux-arm-kernel@lists.infradead.org,
        shane.huang@amd.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, linux@prisktech.co.nz,
        galak@codeaurora.org, schwidefsky@de.ibm.com,
        maxime.ripard@free-electrons.com
Subject: [PATCH v3 0/7] Add cros_ec changes for newer boards
Date: Wed, 30 Apr 2014 10:44:03 -0700
Message-Id: <1398879850-9111-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the most critical cros_ec changes for newer boards
using cros_ec.  Specifically:
* Fixes timing/locking issues with the previously upstreamed (but
  never used upstream) cros_ec_spi driver.
* Updates the cros_ec header file to the latest version which allows
  us to use newer EC features like i2c tunneling.
* Adds an i2c tunnel driver to allow communication to the EC's i2c
  devices.

This _doesn't_ get the EC driver fully up to speed with what's in the
current Chromium OS trees.  There are a whole slew of cleanup patches
there, an addition of an LPC transport mode, and exports of functions
to userspace.  Once these patches land and we have functionality we
can continue to pick more cleanup patches.

Changes in v3:
- Separate out packet sizing from packet stuffing.
- Get rid of useless dev_dbg.
- Check command_sendrecv against NULL.
- Don't check np against NULL.
- Get rid of useless error on memory alloc fail.
- Get rid of useless platform_set_drvdata(dev, NULL);

Changes in v2:
- Update tunnel binding as per swarren
- Removed i2c20 alias for i2c tunnel

Bill Richardson (1):
  mfd: cros_ec: Sync to the latest cros_ec_commands.h from EC sources

David Hendricks (1):
  mfd: cros_ec: spi: calculate delay between transfers correctly

Doug Anderson (5):
  mfd: cros_ec: spi: Add mutex to cros_ec_spi
  mfd: cros_ec: spi: Make the cros_ec_spi timeout more reliable
  mfd: cros_ec: spi: Increase cros_ec_spi deadline from 5ms to 100ms
  i2c: ChromeOS EC tunnel driver
  ARM: tegra: Add the EC i2c tunnel to tegra124-venice2

 .../devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt |   39 +
 arch/arm/boot/dts/tegra124-venice2.dts             |   26 +
 drivers/i2c/busses/Kconfig                         |    9 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |  318 ++++++
 drivers/mfd/cros_ec.c                              |    7 +-
 drivers/mfd/cros_ec_spi.c                          |   67 +-
 include/linux/mfd/cros_ec.h                        |    4 +-
 include/linux/mfd/cros_ec_commands.h               | 1128 ++++++++++++++++++--
 9 files changed, 1507 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt
 create mode 100644 drivers/i2c/busses/i2c-cros-ec-tunnel.c

-- 
1.9.1.423.g4596e3a

