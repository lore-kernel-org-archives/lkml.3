Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3FZIvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:51:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47272 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZIvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:51:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>, Jean Delvare <khali@linux-fr.org>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/4] Add an hwmon driver for the mxs soc internal sensor
Date: Wed, 26 Jun 2013 10:51:09 +0200
Message-Id: <1372236673-20725-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is ading a simple driver for the i.mx28 internal die temperature
sensor.

The first two patches are preparation patches an can be applied now.

The first patch is adding the #io-channel-cells to the lrdac on i.mx28 so that
it becomes an inkernel iio provider.

The second patch defines the lradc as present on the cfa-10036 and thus removes
it from i.mx28-cfa10049.dts and imx28-cfa10055.dts as they both include
imx28-cfa10036.dts

The third patch adds the driver itself.

And the final patch adds the driver bindings to the cfa-10036.

Alexandre Belloni (4):
  arm: mxs: Add #io-channel-cells property to lradc
  arm: mxs: add lradc to cfa10036
  hwmon: Add a simple driver to read the MXS SoC temperature
  arm: mxs: Add mxs internal temp sensor to cfa-10036

 .../devicetree/bindings/hwmon/mxs-cputemp.txt      |  18 +++
 Documentation/hwmon/mxs-cputemp                    |  29 +++++
 arch/arm/boot/dts/imx28-cfa10036.dts               |  10 ++
 arch/arm/boot/dts/imx28-cfa10049.dts               |   1 -
 arch/arm/boot/dts/imx28-cfa10055.dts               |   1 -
 arch/arm/boot/dts/imx28.dtsi                       |   1 +
 drivers/hwmon/Kconfig                              |  10 ++
 drivers/hwmon/Makefile                             |   1 +
 drivers/hwmon/mxs-cputemp.c                        | 132 +++++++++++++++++++++
 9 files changed, 201 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/mxs-cputemp.txt
 create mode 100644 Documentation/hwmon/mxs-cputemp
 create mode 100644 drivers/hwmon/mxs-cputemp.c

-- 
1.8.1.2

